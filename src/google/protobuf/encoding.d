module google.protobuf.encoding;

import std.algorithm : map;
import std.range : chain, ElementType, empty;
import std.traits : isArray, isAssociativeArray, isBoolean, isFloatingPoint, isIntegral, ValueType;
import google.protobuf.common;
import google.protobuf.internal;

auto toProtobuf(T)(T value)
if (isBoolean!T)
{
    return value ? [cast(ubyte) 0x01] : [cast(ubyte) 0x00];
}

unittest
{
    import std.array : array;

    assert(true.toProtobuf.array == [0x01]);
    assert(false.toProtobuf.array == [0x00]);
}

auto toProtobuf(Wire wire = Wire.none, T)(T value)
if (isIntegral!T)
{
    static if (wire == Wire.none)
    {
        return Varint(value);
    }
    else static if (wire == Wire.fixed)
    {
        return value.encodeFixed;
    }
    else static if (wire == Wire.zigzag)
    {
        return Varint(zigZag(value));
    }
    else
    {
        assert(0, "Invalid wire encoding");
    }
}

nothrow unittest
{
    import std.array : array;

    assert(10.toProtobuf.array == [0x0a]);
    assert((-1).toProtobuf.array == [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x01]);
    assert((-1L).toProtobuf.array == [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x01]);
    assert(0xffffffffffffffffUL.toProtobuf.array == [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x01]);

    assert(1L.toProtobuf!(Wire.fixed).array == [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]);
    assert(1.toProtobuf!(Wire.fixed).array == [0x01, 0x00, 0x00, 0x00]);
    assert((-1).toProtobuf!(Wire.fixed).array == [0xff, 0xff, 0xff, 0xff]);
    assert(0xffffffffU.toProtobuf!(Wire.fixed).array == [0xff, 0xff, 0xff, 0xff]);

    assert(1.toProtobuf!(Wire.zigzag).array == [0x02]);
    assert((-1).toProtobuf!(Wire.zigzag).array == [0x01]);
    assert(1L.toProtobuf!(Wire.zigzag).array == [0x02]);
    assert((-1L).toProtobuf!(Wire.zigzag).array == [0x01]);
}

auto toProtobuf(T)(T value)
if (isFloatingPoint!T)
{
    return value.encodeFixed;
}

unittest
{
    import std.array : array;

    assert((0.0).toProtobuf.array == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]);
    assert((0.0f).toProtobuf.array == [0x00, 0x00, 0x00, 0x00]);
}

auto toProtobuf(T)(T value)
if (is(T == string) || is(T == bytes))
{
    return chain(Varint(value.length), cast(ubyte[]) value);
}

unittest
{
    import std.array : array;

    assert("abc".toProtobuf.array == [0x03, 'a', 'b', 'c']);
    assert("".toProtobuf.array == [0x00]);
    assert((cast(bytes) [1, 2, 3]).toProtobuf.array == [0x03, 1, 2, 3]);
    assert((cast(bytes) []).toProtobuf.array == [0x00]);
}

auto toProtobuf(Wire wire = Wire.none, T)(T value)
if (isArray!T && !is(T == string) && !is(T == bytes))
{
    import std.range : hasLength;

    static assert(hasLength!T, "Cannot encode array with unknown length");

    static if (wire == Wire.none)
    {
        auto result = value.map!(a => a.toProtobuf).sizedJoiner;
    }
    else
    {
        static assert(isIntegral!(ElementType!T), "Cannot specify wire format for non-integral arrays");

        auto result = value.map!(a => a.toProtobuf!wire).sizedJoiner;
    }

    return chain(Varint(result.length), result);
}

unittest
{
    import std.array : array;

    assert([false, false, true].toProtobuf.array == [0x03, 0x00, 0x00, 0x01]);
    assert([1, 2].toProtobuf!(Wire.fixed).array == [0x08, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00]);
    assert([1, 2].toProtobuf.array == [0x02, 0x01, 0x02]);
    assert([-54L, 54L].toProtobuf!(Wire.zigzag).array == [0x02, 0x6b, 0x6c]);
}

auto toProtobuf(T)(T value)
if (is(T == class) || is(T == struct))
{
    import std.meta : AliasSeq;
    import std.traits : hasMember;

    static if (hasMember!(T, "toProtobuf"))
    {
        return value.toProtobuf;
    }
    else static if (is(Message!T.fields == AliasSeq!()))
    {
        return cast(ubyte[]) null;
    }
    else
    {
        import std.algorithm : joiner;
        import std.array : array;

        enum fieldExpressions = [Message!T.fieldNames]
            .map!(a => "value.toProtobufByField!(T." ~ a ~ ")")
            .joiner(", ")
            .array;
        enum resultExpression = "chain(" ~ fieldExpressions ~ ")";

        static if (isRecursive!T)
        {
            static if (is(T == class))
            {
                if (value is null)
                    return cast(SizedRange!ubyte) sizedRangeObject(cast(ubyte[]) null);
            }

            return cast(SizedRange!ubyte) mixin(resultExpression).sizedRangeObject;
        }
        else
        {
            static if (is(T == class))
            {
                if (value is null)
                    return typeof(mixin(resultExpression)).init;
            }

            return mixin(resultExpression);
        }
    }
}

unittest
{
    import std.array : array;

    class Foo
    {
        @Proto(1) int bar = protoDefaultValue!int;
        @Proto(3) bool qux = protoDefaultValue!bool;
        @Proto(2, Wire.fixed) long baz = protoDefaultValue!long;
        @Proto(4) string quux = protoDefaultValue!string;

        @Proto(5) Foo recursion = protoDefaultValue!Foo;
    }

    Foo foo;
    assert(foo.toProtobuf.empty);
    foo = new Foo;
    assert(foo.toProtobuf.empty);
    foo.bar = 5;
    foo.baz = 1;
    foo.qux = true;
    assert(foo.toProtobuf.array == [0x08, 0x05, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x01]);
}

unittest
{
    import std.array : array;

    struct EmptyMessage
    {
    }

    EmptyMessage emptyMessage;
    assert(emptyMessage.toProtobuf.empty);
}

unittest
{
    import std.array : array;
    import std.typecons : Yes;

    struct Foo
    {
        @Proto(1) int[] bar = protoDefaultValue!(int[]);
        @Proto(2, Wire.zigzag, Yes.packed) int[] baz = protoDefaultValue!(int[]);
    }

    Foo foo;
    assert(foo.toProtobuf.empty);
    foo.bar = [1, 2];
    foo.baz = [3, 4];
    assert(foo.toProtobuf.array == [0x08, 0x01, 0x08, 0x02, 0x12, 0x02, 0x06, 0x08]);
}

unittest
{
    struct Foo
    {
        @Proto(1) int bar = protoDefaultValue!int;

        auto toProtobuf()
        {
            return [0x08, 0x00];
        }
    }

    Foo foo;
    assert(foo.toProtobuf == [0x08, 0x00]);
}

private static auto toProtobufByField(alias field, T)(T message)
{
    import std.meta : Alias;

    static assert(is(Alias!(__traits(parent, field)) == T), "Field and message are different types");
    static assert(validateProto!(protoByField!field, typeof(field)));
    enum proto = protoByField!field;
    enum fieldName = __traits(identifier, field);
    enum fieldInstanceName = "message." ~ fieldName;

    static if (isOneof!field)
    {
        auto oneofCase = __traits(getMember, message, oneofCaseFieldName!field);
        enum fieldCase = "T." ~ typeof(oneofCase).stringof ~ "." ~ oneofAccessorName!field;

        if (oneofCase != mixin(fieldCase))
            return emptySizedRange!(typeof(mixin(fieldInstanceName).toProtobufByProto!proto));
    }
    else
    {
        if (mixin(fieldInstanceName) == protoDefaultValue!(typeof(field)))
            return emptySizedRange!(typeof(mixin(fieldInstanceName).toProtobufByProto!proto));
    }

    return mixin(fieldInstanceName).toProtobufByProto!proto;
}

unittest
{
    import std.array : array;
    import std.typecons : Yes;

    struct Foo
    {
        @Proto(1) int f10 = 10;
        @Proto(16) int f11 = 10;
        @Proto(2048) bool f12 = true;
        @Proto(262144) bool f13 = true;

        @Proto(20) bool f20 = false;
        @Proto(21) int f21 = 0;
        @Proto(22, Wire.fixed) int f22 = 0;
        @Proto(23, Wire.zigzag) int f23 = 0;
        @Proto(24) long f24 = 0L;
        @Proto(25) double f25 = 0.0;
        @Proto(26) string f26 = "";
        @Proto(27) bytes f27 = [];

        @Proto(30) int[] f30 = [1, 2];
        @Proto(31, Wire.none, Yes.packed) int[] f31 = [1, 2];
        @Proto(32, Wire.none, Yes.packed) int[] f32 = [128, 2];
    }

    Foo foo;

    assert(foo.toProtobufByField!(Foo.f10).array == [0x08, 0x0a]);
    assert(foo.toProtobufByField!(Foo.f11).array == [0x80, 0x01, 0x0a]);
    assert(foo.toProtobufByField!(Foo.f12).array == [0x80, 0x80, 0x01, 0x01]);
    assert(foo.toProtobufByField!(Foo.f13).array == [0x80, 0x80, 0x80, 0x01, 0x01]);

    assert(foo.toProtobufByField!(Foo.f20).empty);
    assert(foo.toProtobufByField!(Foo.f21).empty);
    assert(foo.toProtobufByField!(Foo.f22).empty);
    assert(foo.toProtobufByField!(Foo.f23).empty);
    assert(foo.toProtobufByField!(Foo.f24).empty);
    assert(foo.toProtobufByField!(Foo.f25).empty);
    assert(foo.toProtobufByField!(Foo.f26).empty);
    assert(foo.toProtobufByField!(Foo.f27).empty);

    assert(foo.toProtobufByField!(Foo.f30).array == [0xf0, 0x01, 0x01, 0xf0, 0x01, 0x02]);
    assert(foo.toProtobufByField!(Foo.f31).array == [0xfa, 0x01, 0x02, 0x01, 0x02]);
    assert(foo.toProtobufByField!(Foo.f32).array == [0x82, 0x02, 0x03, 0x80, 0x01, 0x02]);
}

private auto toProtobufByProto(Proto proto, T)(T value)
if (isBoolean!T ||
    isFloatingPoint!T ||
    is(T == string) ||
    is(T == bytes) ||
    (isArray!T && proto.packed))
{
    static assert(validateProto!(proto, T));

    static if (proto.wire == Wire.none)
    {
        return chain(encodeTag!(proto, T), value.toProtobuf);
    }
    else
    {
        return chain(encodeTag!(proto, T), value.toProtobuf!(proto.wire));
    }
}

private auto toProtobufByProto(Proto proto, T)(T value)
if (isIntegral!T)
{
    static assert(validateProto!(proto, T));

    enum wire = proto.wire;
    return chain(encodeTag!(proto, T), value.toProtobuf!wire);
}

private auto toProtobufByProto(Proto proto, T)(T value)
if (isArray!T && !proto.packed && !is(T == string) && !is(T == bytes))
{
    static assert(validateProto!(proto, T));

    enum elementProto = Proto(proto.tag, proto.wire);
    return value
        .map!(a => a.toProtobufByProto!elementProto)
        .sizedJoiner;
}

private auto toProtobufByProto(Proto proto, T)(T value)
if (isAssociativeArray!T)
{
    static assert(validateProto!(proto, T));

    enum keyProto = Proto(MapFieldTag.key, keyWireToWire(proto.wire));
    enum valueProto = Proto(MapFieldTag.value, valueWireToWire(proto.wire));

    return value
        .byKeyValue
        .map!(a => chain(a.key.toProtobufByProto!keyProto, a.value.toProtobufByProto!valueProto))
        .map!(a => chain(encodeTag!(proto, T), Varint(a.length), a))
        .sizedJoiner;
}

unittest
{
    import std.array : array;
    import std.typecons : Yes;

    assert([1, 2].toProtobufByProto!(Proto(1)).array == [0x08, 0x01, 0x08, 0x02]);
    assert((int[]).init.toProtobufByProto!(Proto(1)).empty);
    assert([1, 2].toProtobufByProto!(Proto(1, Wire.none, Yes.packed)).array == [0x0a, 0x02, 0x01, 0x02]);
    assert([128, 2].toProtobufByProto!(Proto(1, Wire.none, Yes.packed)).array == [0x0a, 0x03, 0x80, 0x01, 0x02]);
    assert((int[]).init.toProtobufByProto!(Proto(1, Wire.none, Yes.packed)).array == [0x0a, 0x00]);

    assert((int[int]).init.toProtobufByProto!(Proto(1)).empty);
    assert([1: 2].toProtobufByProto!(Proto(1)).array == [0x0a, 0x04, 0x08, 0x01, 0x10, 0x02]);
    assert([1: 2].toProtobufByProto!(Proto(1, Wire.fixedValue)).array ==
        [0x0a, 0x07, 0x08, 0x01, 0x15, 0x02, 0x00, 0x00, 0x00]);
}

private auto toProtobufByProto(Proto proto, T)(T value)
if (is(T == class) || is(T == struct))
{
    static assert(validateProto!(proto, T));

    auto encodedValue = value.toProtobuf;
    auto result = chain(encodeTag!(proto, T), Varint(encodedValue.length), encodedValue);

    static if (isRecursive!T)
    {
        return cast(SizedRange!ubyte) result.sizedRangeObject;
    }
    else
    {
        return result;
    }
}
