module google.protobuf.empty;

import std.json : JSONValue;
import google.protobuf;

struct Empty
{
    auto toProtobuf()
    {
        return cast(ubyte[]) null;
    }

    Empty fromProtobuf(R)(ref R inputRange)
    {
        import std.range : drop;

        inputRange = inputRange.drop(inputRange.length);
        return this;
    }

    JSONValue toJSONValue()()
    {
        return JSONValue(cast(JSONValue[string]) null);
    }

    Empty fromJSONValue()(JSONValue value)
    {
        import std.exception : enforce;
        import std.json : JSONType;
        import std.range : empty;

        if (value.type == JSONType.null_)
        {
            return this;
        }

        enforce!ProtobufException(value.type == JSONType.object && value.object.empty,
            "Invalid google.protobuf.Empty JSON Encoding");

        return this;
    }
}

unittest
{
    import std.range : empty;

    assert(Empty().toProtobuf.empty);
    ubyte[] foo = [1, 2, 3];
    Empty().fromProtobuf(foo);
    assert(foo.empty);
}

unittest
{
    import std.json : JSONType;
    import std.range : empty;

    assert(Empty().toJSONValue.type == JSONType.object);
    assert(Empty().toJSONValue.object.empty);
}
