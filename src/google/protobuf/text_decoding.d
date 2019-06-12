module google.protobuf.text_decoding;

import std.traits : isArray, isAssociativeArray, isBoolean, isFloatingPoint, isIntegral, isSigned;
import google.protobuf.common;

T fromProtobufText(T)(ref string input)
if (isBoolean!T || isIntegral!T || isFloatingPoint!T)
{
    import std.format : formattedRead;
    import std.string : stripLeft;

    input = input.stripLeft;

    T result;
    if (input.formattedRead!"%s"(result))
    {
        return result;
    }
    else
    {
        static if (isFloatingPoint!T)
        {
            string floatLiteral;
            if (input.formattedRead!"%s"(floatLiteral))
            {
                switch (floatLiteral)
                {
                case "NaN":
                    return T.nan;
                case "inf":
                    return T.infinity;
                case "-inf":
                    return -T.infinity;
                default:
                    break;
                }
            }
        }
        throw new ProtobufException(T.stringof ~ " expected");
    }
}

T fromProtobufText(T)(ref string input)
if (is(T == string) || is(T == bytes))
{
    import std.array : appender;
    import std.exception : enforce;
    import std.range : empty;
    import std.string : stripLeft;

    char peekNext()
    {
        if (input.empty)
            return '\0';

        return input[0];
    }

    char getNext()
    {
        if (input.empty)
            return '\0';

        auto result = input[0];
        input = input[1 .. $];

        return result;
    }

    input = input.stripLeft;
    auto result = appender!T;

    enforce!ProtobufException(getNext == '"', "Unquoted " ~ T.stringof ~ " value");

    for (;;)
    {
        auto c = getNext;
        switch(c)
        {
        case '\0':
            throw new ProtobufException(T.stringof ~ " value has no ending quote");
        case '\\':
            {
                auto escapedC = getNext;
                switch (escapedC)
                {
                case 't':
                    result.put('\t');
                    break;
                case 'n':
                    result.put('\n');
                    break;
                case 'r':
                    result.put('\r');
                    break;
                case '"':
                    result.put('\"');
                    break;
                case '\'':
                    result.put('\'');
                    break;
                case '\\':
                    result.put('\\');
                    break;
                default:
                    static if (is(T == bytes))
                    {
                        if ('0' <= escapedC && escapedC < '8')
                        {
                            short newByte = escapedC - '0';
                            auto nextDigit = peekNext;
                            if ('0' <= nextDigit && nextDigit < '8')
                            {
                                getNext;
                                newByte <<= 3;
                                newByte += nextDigit - '0';

                                nextDigit = peekNext;
                                if ('0' <= nextDigit && nextDigit < '8')
                                {
                                    getNext;
                                    newByte <<= 3;
                                    newByte += nextDigit - '0';
                                }
                            }
                            if (0 <= newByte && newByte < 256)
                                result.put(cast(ubyte) newByte);
                            else
                                throw new ProtobufException("Invalid octal encoding");
                        }
                        else
                        {
                            throw new ProtobufException("Invalid escape sequence \\" ~ escapedC);
                        }
                    }
                    else
                    {
                        throw new ProtobufException("Invalid escape sequence \\" ~ escapedC);
                    }
                }
                break;
            }
        case '"':
            return result.data;
        default:
            result.put(c);
            break;
        }
    }

    assert(0, "Internal error");
}

unittest
{
    import std.math : isNaN;
    import google.protobuf.text_encoding : toProtobufText;

    auto buffer = true.toProtobufText;
    assert(fromProtobufText!bool(buffer) == true);
    buffer = false.toProtobufText;
    assert(fromProtobufText!bool(buffer) == false);
    buffer = 1.toProtobufText;
    assert(fromProtobufText!int(buffer) == 1);
    buffer = 1.toProtobufText;
    assert(fromProtobufText!uint(buffer) == 1U);
    buffer = 1.toProtobufText;
    assert(fromProtobufText!long(buffer) == 1L);
    buffer = 1.toProtobufText;
    assert(fromProtobufText!ulong(buffer) == 1UL);

    buffer = (1.1).toProtobufText;
    assert(fromProtobufText!float(buffer) == 1.1f);
    buffer = (1.1).toProtobufText;
    assert(fromProtobufText!double(buffer) == 1.1);
    buffer = (double.nan).toProtobufText;
    assert(fromProtobufText!double(buffer).isNaN);
    buffer = (float.infinity).toProtobufText;
    assert(fromProtobufText!float(buffer) == float.infinity);
    buffer = (-double.infinity).toProtobufText;
    assert(fromProtobufText!double(buffer) == -double.infinity);

    buffer = `abc"def`.toProtobufText;
    assert(fromProtobufText!string(buffer) == `abc"def`);

    buffer = (cast(bytes) "foo\xba").toProtobufText;
    assert(fromProtobufText!bytes(buffer) == ['f', 'o', 'o', '\xba']);
}

/*
T fromJSONValue(T)(JSONValue value, T result = null)
if (isAssociativeArray!T)
{
    import std.conv : ConvException, to;
    import std.exception : enforce;
    import std.traits : KeyType, ValueType;

    if (value.isNull)
        return protoDefaultValue!T;

    enforce!ProtobufException(value.type == JSON_TYPE.OBJECT, "JSON object expected");
    foreach (k, v; value.object)
    {
        try
        {
            result[k.to!(KeyType!T)] = v.fromJSONValue!(ValueType!T);
        }
        catch (ConvException exception)
        {
            throw new ProtobufException(exception.msg);
        }
    }

    return result;
}

unittest
{
    import std.exception : assertThrown;
    import std.json : parseJSON;
    import std.math : isInfinity, isNaN;

    assert(fromJSONValue!bool(JSONValue(false)) == false);
    assert(fromJSONValue!bool(JSONValue(true)) == true);
    assertThrown!ProtobufException(fromJSONValue!bool(JSONValue(1)));

    assert(fromJSONValue!int(JSONValue(1)) == 1);
    assert(fromJSONValue!uint(JSONValue(1U)) == 1U);
    assert(fromJSONValue!long(JSONValue(1L)) == 1);
    assert(fromJSONValue!ulong(JSONValue(1UL)) == 1U);
    assertThrown!ProtobufException(fromJSONValue!int(JSONValue(false)));
    assertThrown!ProtobufException(fromJSONValue!ulong(JSONValue("foo")));

    assert(fromJSONValue!float(JSONValue(1.0f)) == 1.0);
    assert(fromJSONValue!double(JSONValue(1.0)) == 1.0);
    assert(fromJSONValue!float(JSONValue("NaN")).isNaN);
    assert(fromJSONValue!double(JSONValue("Infinity")).isInfinity);
    assert(fromJSONValue!double(JSONValue("-Infinity")).isInfinity);
    assertThrown!ProtobufException(fromJSONValue!float(JSONValue(false)));
    assertThrown!ProtobufException(fromJSONValue!double(JSONValue("foo")));

    assert(fromJSONValue!bytes(JSONValue("Zm9v")) == cast(bytes) "foo");
    assertThrown!ProtobufException(fromJSONValue!bytes(JSONValue(1)));

    assert(fromJSONValue!(int[])(parseJSON(`[1, 2, 3]`)) == [1, 2, 3]);
    assertThrown!ProtobufException(fromJSONValue!(int[])(JSONValue(`[1, 2, 3]`)));

    assert(fromJSONValue!(bool[int])(parseJSON(`{"1": false, "2": true}`)) == [1 : false, 2 : true]);
    assertThrown!ProtobufException(fromJSONValue!(bool[int])(JSONValue(`{"1": false, "2": true}`)));
    assertThrown!ProtobufException(fromJSONValue!(bool[int])(parseJSON(`{"foo": false, "2": true}`)));
}
*/

T fromProtobufText(T)(ref string input, T result = protoDefaultValue!T)
if (is(T == class) || is(T == struct))
{
    import std.algorithm : findAmong;
    import std.exception : enforce;
    import std.meta : staticMap;
    import std.range : empty;
    import std.traits : hasMember;

    static if (is(T == class))
    {
        if (result is null)
            result = new T;
    }

    static if (hasMember!(T, "fromProtobufText"))
    {
        return result.fromProtobufText(input);
    }
    else
    {
        enum textFieldName(string fieldName) = {
            import std.algorithm : skipOver;

            string result = fieldName;

            if (fieldName[$ - 1] == '_')
                result = fieldName[0 .. $ - 1];

            static if (isOneof!(mixin("T." ~ fieldName)))
                result.skipOver("_");

            return result;
        }();

        if (input.empty)
            return result;

        bool expectingClosingBrace = false;
        bool firstToken = true;

        for (;;)
        {
            auto token = getNextToken(input);
            switch (token)
            {
            case ":":
                throw new ProtobufException("Unexpected ':' character");
            case "{":
                enforce!ProtobufException(firstToken, "Unexpected '{' character");
                expectingClosingBrace = true;
                break;
            case "}":
                enforce!ProtobufException(expectingClosingBrace, "Unexpected '}' character");
                return result;
            case "":
                enforce!ProtobufException(!expectingClosingBrace, "Expected '}' character");
                return result;
            default:
                enforce!ProtobufException(getNextToken(input) == ":", "Expected ':' after field identifier");
            }
            firstToken = false;
        }

        assert(0, "Internal error");
/*
        JSONValue[string] members = value.object;

        foreach (fieldName; Message!T.fieldNames)
        {
            enum jsonFieldName = jsonName!fieldName;

            auto fieldValue = (jsonFieldName in members);
            if (fieldValue !is null)
            {
                static if (isOneof!(mixin("T." ~ fieldName)))
                {
                    alias otherFields = staticMap!(jsonName, otherOneofFieldNames!(T, mixin("T." ~ fieldName)));
                    enforce!ProtobufException(members.keys.findAmong([otherFields]).empty,
                            "More than one oneof field in JSON Message");
                }

                mixin("result." ~ fieldName) = fromJSONValue!(typeof(mixin("T." ~ fieldName)))(*fieldValue);
            }
        }
        */
    }
}

unittest
{
    import std.exception : assertThrown;
    import google.protobuf.text_encoding : toProtobufText;

    static struct Foo
    {
        @Proto(1) int a;
        @Proto(3) string b;
        @Proto(4) bool c;
    }

    auto foo = Foo(10, "abc", false);

    auto buffer = foo.toProtobufText;
    //assert(fromProtobufText!Foo(buffer) == foo);

    //buffer = `a:10 b:"abc"`;
    //assert(fromProtobufText!Foo(buffer) == Foo(10, "abc", false));
    //buffer = `a: 10 b: "abc" c: false`;
    //assert(fromProtobufText!Foo(buffer) == Foo(10, "abc", false));
    //buffer = `a:10 b:100`;
    //assertThrown!ProtobufException(fromProtobufText!Foo(buffer));
}
/*
unittest
{
    import std.json : parseJSON;

    struct EmptyMessage
    {
    }

    assert(fromJSONValue!EmptyMessage(parseJSON(``)) == EmptyMessage());
    assert(fromJSONValue!EmptyMessage(parseJSON(`a:10 b:"abc"}`)) == EmptyMessage());
}*/
/*
private template oneofs(T)
{
    import std.meta : NoDuplicates, staticMap;
    import std.traits : getSymbolsByUDA;

    private alias oneofs = NoDuplicates!(staticMap!(oneofByField, getSymbolsByUDA!(T, Oneof)));
}

private template oneofByField(alias field)
{
    import std.traits : getUDAs;

    enum Oneof oneofByField = getUDAs!(field, Oneof)[0];
}

private template otherOneofFieldNames(T, alias field)
{
    import std.meta : Erase, Filter, staticMap;

    static assert(is(typeof(__traits(parent, field).init) == T));
    static assert(isOneof!field);

    static enum hasSameOneofCase(alias field2) = oneofCaseFieldName!field == oneofCaseFieldName!field2;
    static enum fieldName(alias field) = __traits(identifier, field);

    enum otherOneofFieldNames = staticMap!(fieldName, Erase!(field, Filter!(hasSameOneofCase, Filter!(isOneof,
            Message!T.fields))));
}

unittest
{
    import std.meta : AliasSeq, staticMap;

    static struct Test
    {
        @Oneof("foo")
        union
        {
            @Proto(1) int foo1;
            @Proto(2) int foo2;
        }
        @Oneof("bar")
        union
        {
            @Proto(11) int bar1;
            @Proto(12) int bar2;
            @Proto(13) int bar3;
        }

        @Proto(20) int baz;
    }

    static assert([otherOneofFieldNames!(Test, Test.foo1)] == ["foo2"]);
    static assert([otherOneofFieldNames!(Test, Test.bar2)] == ["bar1", "bar3"]);
}
*/

private string getNextToken(ref string input)
{
    import std.algorithm : findSkip, splitter;
    import std.ascii : isAlpha, isAlphaNum;
    import std.exception : enforce;
    import std.range : empty;
    import std.string : stripLeft;

    input = input.stripLeft;
    if (input.empty)
        return "";

    switch (input[0])
    {
    case ':':
    case '{':
    case '}':
        auto result = input[0 .. 1];
        input = input[1 .. $];
        return result;
    default:
        enforce!ProtobufException(input[0].isAlpha, "Invalid identifier: " ~ input.splitter.front);
    }

    auto result = input;
    auto index = input.findSkip!(a => a.isAlphaNum || a == '_');

    return result[0 .. index];
}

unittest
{
    auto foo = " abc_123 : { };";

    auto bar = getNextToken(foo);
    auto baz = getNextToken(foo);
    auto qux = getNextToken(foo);
    auto quux = getNextToken(foo);

    assert(bar == "abc_123");
    assert(baz == ":");
    assert(qux == "{");
    assert(quux == "}");
    assert(foo == ";");

    foo = "\n\t ";
    assert(getNextToken(foo) == "");
    assert(foo == "");
}
