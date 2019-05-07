module google.protobuf.text_encoding;

import std.traits : isArray, isAssociativeArray, isBoolean, isFloatingPoint, isIntegral, isSigned;
import google.protobuf.common;

private enum indentSize = 2;

string toProtobufText(T)(T value)
if (isBoolean!T)
{
    return value ? "true" : "false";
}

string toProtobufText(T)(T value)
if (isIntegral!T)
{
    import std.conv : to;

    return value.to!string;
}

string toProtobufText(T)(T value)
if (isFloatingPoint!T)
{
    import std.conv : to;
    import std.math : isInfinity, isNaN;

    if (value.isNaN)
        return "NaN";
    else if (value.isInfinity)
        return value < 0 ? "-inf" : "inf";
    else
        return value.to!string;
}

string toProtobufText(T)(T value)
if (is(T == string))
{
    import std.string : replace;

    return `"` ~ value.replace(`"`, `\"`) ~ `"`;
}

string toProtobufText(T)(T value)
if (is(T == bytes))
{
    import std.array : appender;
    import std.format : format;

    auto result = appender!string(`"`);

    foreach (ubyte b; value) {
        switch (b) {
        case 9:
            result.put(`\t`);
            break;
        case 10:
            result.put(`\n`);
            break;
        case 13:
            result.put(`\r`);
            break;
        case 34:
            result.put(`\"`);
            break;
        case 39:
            result.put(`\'`);
            break;
        case 92:
            result.put(`\\`);
            break;
        default:
            if (32 <= b && b < 127)
                result.put(b);
            else
                result.put(b.format!"%03o");
            break;
        }
    }
    result.put(`"`);

    return result.data;
}

unittest
{
    assert(toProtobufText(true) == "true");
    assert(toProtobufText(false) == "false");
    assert(toProtobufText(1) == "1");
    assert(toProtobufText(1U) == "1");
    assert(toProtobufText(1L) == "1");
    assert(toProtobufText(1UL) == "1");

    assert(toProtobufText(1.1f) == "1.1");
    assert(toProtobufText(1.1) == "1.1");
    assert(toProtobufText(double.nan) == "NaN");
    assert(toProtobufText(float.infinity) == "inf");
    assert(toProtobufText(-double.infinity) == "-inf");

    assert(toProtobufText("foo\"") == `"foo\""`);
    assert(toProtobufText(cast(bytes) "foo") == `"foo"`);
}

string toProtobufText(T)(T value, size_t indent = 0)
if (is(T == class) || is(T == struct))
{
    import std.meta : AliasSeq;
    import std.traits : hasMember;

    static if (is(T == class))
    {
        if (value is null)
        {
            return "";
        }
    }

    static if (hasMember!(T, "toProtobufText"))
    {
        return value.toProtobufText;
    }
    else
    {
        import std.array : appender;

        auto result = appender!string;

        foreach (fieldName; Message!T.fieldNames)
        {
            static if (isOneof!(mixin("T." ~ fieldName)))
            {
                auto oneofCase = __traits(getMember, value, oneofCaseFieldName!(mixin("T." ~ fieldName)));
                enum fieldCase = "T." ~ typeof(oneofCase).stringof ~ "." ~ oneofAccessorName!(mixin("T." ~ fieldName));

                if (oneofCase == mixin(fieldCase))
                    result ~= fieldToProtobufText(oneofAccessorName!(mixin("T." ~ fieldName)),
                        mixin("value." ~ fieldName), indent);
            }
            else
            {
                if (mixin("value." ~ fieldName) != protoDefaultValue!(typeof(mixin("T." ~ fieldName))))
                    result ~= fieldToProtobufText(fieldName, mixin("value." ~ fieldName), indent);
            }
        }

        return result.data;
    }
}

unittest
{
    struct Foo
    {
        @Proto(1) int a;
        @Proto(3) string b;
        @Proto(4) bool c;
    }

    auto foo = Foo(10, "abc", false);

    assert(foo.toProtobufText == "a: 10\nb: \"abc\"\n");
}

unittest
{
    struct EmptyMessage
    {
    }

    EmptyMessage emptyMessage;

    assert(emptyMessage.toProtobufText == "");
}

unittest
{
    struct Foo
    {
        @Proto(1) int a;

        enum MeterOrInchCase
        {
            meterOrInchNotSet = 0,
            meter = 3,
            inch = 5,
        }
        MeterOrInchCase _meterOrInchCase = MeterOrInchCase.meterOrInchNotSet;
        @property MeterOrInchCase meterOrInchCase() { return _meterOrInchCase; }
        void clearMeterOrInchCase() { _meterOrInchCase = MeterOrInchCase.meterOrInchNotSet; }
        @Oneof("_meterOrInchCase") union
        {
            @Proto(3) int _meter = protoDefaultValue!int; mixin(oneofAccessors!_meter);
            @Proto(5) int _inch; mixin(oneofAccessors!_inch);
        }
    }

    auto foo = Foo(10);

    assert(foo.toProtobufText == "a: 10\n");

    foo.meter = 10;
    assert(foo.toProtobufText == "a: 10\nmeter: 10\n");

    foo.inch = 20;
    assert(foo.toProtobufText == "a: 10\ninch: 20\n");

    foo.meter = 0;
    assert(foo.toProtobufText == "a: 10\nmeter: 0\n");

    foo.a = 0;
    assert(foo.toProtobufText == "meter: 0\n");

    foo.clearMeterOrInchCase;
    assert(foo.toProtobufText == "");
}

private static string fieldToProtobufText(T)(string fieldName, T value, size_t indent = 0)
if (isBoolean!T || isIntegral!T || isFloatingPoint!T || is(T == string) || is(T == bytes))
{
    import std.format : format;

    return format!"%*s%s: %s\n"(indent, "", fieldName, value.toProtobufText);
}

private static string fieldToProtobufText(T)(string fieldName, T value, size_t indent = 0)
if (isArray!T && !is(T == string) && !is(T == bytes))
{
    import std.algorithm : map;
    import std.array : join;

    return value.map!(a => fieldToProtobufText(fieldName, a, indent)).join;
}

unittest
{
    assert(fieldToProtobufText("foo", [1, 2, 3]) == "foo: 1\nfoo: 2\nfoo: 3\n");
}

private static string fieldToProtobufText(T)(string fieldName, T value, size_t indent = 0)
if (isAssociativeArray!T)
{
    import std.array : appender;
    import std.format : format;

    auto result = appender!string;

    foreach (k, v; value) {
        result ~= format!"%*s%s: {\n"(indent, "", fieldName);
        if (k != protoDefaultValue!(typeof(k)))
            result ~= fieldToProtobufText("key", k, indent + indentSize);
        if (v != protoDefaultValue!(typeof(v)))
            result ~= fieldToProtobufText("value", v, indent + indentSize);
        result ~= format!"%*s}\n"(indent, "");
    }

    return result.data;
}

unittest
{
    assert(fieldToProtobufText("foo", [1: "abc"]) == "foo: {\n  key: 1\n  value: \"abc\"\n}\n");
}

private static string fieldToProtobufText(T)(string fieldName, T value, size_t indent = 0)
if (is(T == class) || is(T == struct))
{
    import std.format : format;

    return format!"%*s%s: {\n%s%*s}\n"(indent, "", fieldName, toProtobufText(value, indent + indentSize), indent, "");
}
