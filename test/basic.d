
import google.protobuf;

// ------------- generated code --------------

class Foo
{
    @Proto(1) Bar bar = protoDefaultValue!Bar;
    @Proto(2) Baz baz = protoDefaultValue!Baz;
}

class Bar
{
    @Proto(1) string msg = protoDefaultValue!string;
}

class Baz
{
    @Proto(1) string msg = protoDefaultValue!string;
}

class TestMessage
{
    @Proto(1) int optionalInt32 = protoDefaultValue!int;
    @Proto(2) long optionalInt64 = protoDefaultValue!long;
    @Proto(3) uint optionalUint32 = protoDefaultValue!uint;
    @Proto(4) ulong optionalUint64 = protoDefaultValue!ulong;
    @Proto(5) bool optionalBool = protoDefaultValue!bool;
    @Proto(6) float optionalFloat = protoDefaultValue!float;
    @Proto(7) double optionalDouble = protoDefaultValue!double;
    @Proto(8) string optionalString = protoDefaultValue!string;
    @Proto(9) bytes optionalBytes = protoDefaultValue!bytes;
    @Proto(10) TestMessage2 optionalMsg = protoDefaultValue!TestMessage2;
    @Proto(11) TestEnum optionalEnum = protoDefaultValue!TestEnum;

    @Proto(12) int[] repeatedInt32 = protoDefaultValue!(int[]);
    @Proto(13) long[] repeatedInt64 = protoDefaultValue!(long[]);
    @Proto(14) uint[] repeatedUint32 = protoDefaultValue!(uint[]);
    @Proto(15) ulong[] repeatedUint64 = protoDefaultValue!(ulong[]);
    @Proto(16) bool[] repeatedBool = protoDefaultValue!(bool[]);
    @Proto(17) float[] repeatedFloat = protoDefaultValue!(float[]);
    @Proto(18) double[] repeatedDouble = protoDefaultValue!(double[]);
    @Proto(19) string[] repeatedString = protoDefaultValue!(string[]);
    @Proto(20) bytes[] repeatedBytes = protoDefaultValue!(bytes[]);
    @Proto(21) TestMessage2[] repeatedMsg = protoDefaultValue!(TestMessage2[]);
    @Proto(22) TestEnum[] repeatedEnum = protoDefaultValue!(TestEnum[]);
}
class TestMessage2
{
    @Proto(1) int foo = protoDefaultValue!int;
}

class Recursive1
{
    @Proto(1) Recursive2 foo = protoDefaultValue!Recursive2;
}
class Recursive2
{
    @Proto(1) Recursive1 foo = protoDefaultValue!Recursive1;
}

enum TestEnum
{
    Default = 0,
    A = 1,
    B = 2,
    C = 3,
}

class MapMessage
{
    @Proto(1) int[string] mapStringInt32 = protoDefaultValue!(int[string]);
    @Proto(2) TestMessage2[string] mapStringMsg = protoDefaultValue!(TestMessage2[string]);
}
class MapMessageWireEquiv
{
    @Proto(1) MapMessageWireEquivEntry1[] mapStringInt32 = protoDefaultValue!(MapMessageWireEquivEntry1[]);
    @Proto(2) MapMessageWireEquivEntry2[] mapStringMsg = protoDefaultValue!(MapMessageWireEquivEntry2[]);
}
class MapMessageWireEquivEntry1
{
    @Proto(1) string key = protoDefaultValue!string;
    @Proto(2) int value = protoDefaultValue!int;
}
class MapMessageWireEquivEntry2
{
    @Proto(1) string key = protoDefaultValue!string;
    @Proto(2) TestMessage2 value = protoDefaultValue!TestMessage2;
}

class OneofMessage
{
    enum MyOneofCase
    {
        myOneofNotSet = 0,
        a = 1,
        b = 2,
        c = 3,
        d = 4,
    }
    MyOneofCase _myOneofCase = MyOneofCase.myOneofNotSet;
    @property MyOneofCase myOneofCase() { return _myOneofCase; }
    void clearMyOneof() { _myOneofCase = MyOneofCase.myOneofNotSet; }
    @Oneof("_myOneofCase") union
    {
        @Proto(1) string _a = protoDefaultValue!string; mixin(oneofAccessors!_a);
        @Proto(2) int _b; mixin(oneofAccessors!_b);
        @Proto(3) TestMessage2 _c; mixin(oneofAccessors!_c);
        @Proto(4) TestEnum _d; mixin(oneofAccessors!_d);
    }
}


// ------------ test cases ---------------

// test defaults
unittest
{
    auto m = new TestMessage;
    assert(m.optionalInt32 == 0);
    assert(m.optionalInt64 == 0);
    assert(m.optionalUint32 == 0);
    assert(m.optionalUint64 == 0);
    assert(m.optionalBool == false);
    assert(m.optionalFloat == 0.0);
    assert(m.optionalDouble == 0.0);
    assert(m.optionalString == "");
    assert(m.optionalBytes == "");
    assert(m.optionalMsg is null);
    assert(m.optionalEnum == TestEnum.Default);
}

// test setters
unittest
{
    auto m = new TestMessage;
    m.optionalInt32 = -42;
    assert(m.optionalInt32 == -42);
    m.optionalInt64 = -0x1_0000_0000;
    assert(m.optionalInt64 == -0x1_0000_0000);
    m.optionalUint32 = 0x9000_0000;
    assert(m.optionalUint32 == 0x9000_0000);
    m.optionalUint64 = 0x9000_0000_0000_0000;
    assert(m.optionalUint64 == 0x9000_0000_0000_0000);
    m.optionalBool = true;
    assert(m.optionalBool == true);
    m.optionalFloat = 0.5;
    assert(m.optionalFloat == 0.5);
    m.optionalDouble = 0.5;
    m.optionalString = "hello";
    assert(m.optionalString == "hello");
    m.optionalBytes = cast(bytes) "world";
    assert(m.optionalBytes == "world");
    m.optionalMsg = new TestMessage2;
    m.optionalMsg.foo = 42;
    assert(m.optionalMsg.foo == 42);
    m.optionalMsg = null;
    assert(m.optionalMsg is null);
}

// test parent repeated field
unittest
{
    // make sure we set the RepeatedField and can add to it
    auto m = new TestMessage;
    assert(m.repeatedString is null);
    m.repeatedString ~= "ok";
    m.repeatedString ~= "ok2";
    assert(m.repeatedString == ["ok", "ok2"]);
    m.repeatedString ~= ["ok3"];
    assert(m.repeatedString == ["ok", "ok2", "ok3"]);
}

// test map field
unittest
{
    import std.algorithm : sort;
    import std.array : array;

    auto m = new MapMessage;
    assert(m.mapStringInt32 is null);
    assert(m.mapStringMsg is null);
    m.mapStringInt32 = ["a": 1, "b": 2];
    auto a = new TestMessage2;
    a.foo = 1;
    auto b = new TestMessage2;
    b.foo = 2;
    m.mapStringMsg = ["a": a, "b": b];
    assert(m.mapStringInt32.keys.sort().array == ["a", "b"]);
    assert(m.mapStringInt32["a"] == 1);
    assert(m.mapStringMsg["b"].foo == 2);

    m.mapStringInt32["c"] = 3;
    assert(m.mapStringInt32["c"] == 3);
    auto c = new TestMessage2;
    c.foo = 3;
    m.mapStringMsg["c"] = c;
    m.mapStringMsg.remove("b");
    m.mapStringMsg.remove("c");
    assert(m.mapStringMsg.keys == ["a"]);
}

// test oneof
unittest
{
    auto d = new OneofMessage;
    assert(d.a == protoDefaultValue!(string));
    assert(d.b == protoDefaultValue!(int));
    assert(d.c == protoDefaultValue!(TestMessage2));
    assert(d.d == protoDefaultValue!(TestEnum));
    assert(d.myOneofCase == OneofMessage.MyOneofCase.myOneofNotSet);

    d.a = "foo";
    assert(d.a == "foo");
    assert(d.b == protoDefaultValue!(int));
    assert(d.c == protoDefaultValue!(TestMessage2));
    assert(d.d == protoDefaultValue!(TestEnum));
    assert(d.myOneofCase == OneofMessage.MyOneofCase.a);

    d.b = 42;
    assert(d.a == protoDefaultValue!(string));
    assert(d.b == 42);
    assert(d.c == protoDefaultValue!(TestMessage2));
    assert(d.d == protoDefaultValue!(TestEnum));
    assert(d.myOneofCase == OneofMessage.MyOneofCase.b);

    auto m = new TestMessage2;
    m.foo = 42;
    d.c = m;
    assert(d.a == protoDefaultValue!(string));
    assert(d.b == protoDefaultValue!(int));
    assert(d.c.foo == 42);
    assert(d.d == protoDefaultValue!(TestEnum));
    assert(d.myOneofCase == OneofMessage.MyOneofCase.c);

    d.d = TestEnum.B;
    assert(d.a == protoDefaultValue!(string));
    assert(d.b == protoDefaultValue!(int));
    assert(d.c == protoDefaultValue!(TestMessage2));
    assert(d.d == TestEnum.B);
    assert(d.myOneofCase == OneofMessage.MyOneofCase.d);
}
