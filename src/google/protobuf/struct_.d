module google.protobuf.struct_;

import std.json : JSONValue;
import google.protobuf;

class Struct
{
    @Proto(1) Value[string] fields = protoDefaultValue!(Value[string]);

    this()
    {
    }

    this(JSONValue value)
    {
        fromJSONValue(value);
    }

    JSONValue toJSONValue()()
    {
        import std.array : assocArray;
        import std.algorithm : map;
        import std.typecons : tuple;

        return JSONValue(fields.byKeyValue.map!(a => tuple(a.key, a.value.toJSONValue)).assocArray);
    }

    auto fromJSONValue()(JSONValue value)
    {
        import std.array : assocArray;
        import std.algorithm : map;
        import std.exception : enforce;
        import std.json : JSONType;
        import std.typecons : tuple;

        if (value.type == JSONType.null_)
        {
            fields = protoDefaultValue!(Value[string]);
            return this;
        }

        enforce!ProtobufException(value.type == JSONType.object, "JSON object expected");
        fields = value.object.byKeyValue.map!(a => tuple(a.key, new Value(a.value))).assocArray;

        return this;
    }
}

class Value
{
    enum KindCase
    {
        kindNotSet = 0,
        nullValue = 1,
        numberValue = 2,
        stringValue = 3,
        boolValue = 4,
        structValue = 5,
        listValue = 6,
    }
    KindCase _kindCase = KindCase.kindNotSet;
    @property KindCase kindCase() { return _kindCase; }
    void clearKind() { _kindCase = KindCase.kindNotSet; }
    @Oneof("_kindCase") union
    {
        @Proto(1) NullValue _nullValue = protoDefaultValue!NullValue; mixin(oneofAccessors!_nullValue);
        @Proto(2) double _numberValue; mixin(oneofAccessors!_numberValue);
        @Proto(3) string _stringValue; mixin(oneofAccessors!_stringValue);
        @Proto(4) bool _boolValue; mixin(oneofAccessors!_boolValue);
        @Proto(5) Struct _structValue; mixin(oneofAccessors!_structValue);
        @Proto(6) ListValue _listValue; mixin(oneofAccessors!_listValue);
    }

    this()
    {
    }

    this(JSONValue jsonValue)
    {
        fromJSONValue(jsonValue);
    }

    override bool opEquals(Object o)
    {
        auto other = cast(Value) o;
        if (other is null)
            return false;

        if (kindCase != other.kindCase)
            return false;

        final switch (kindCase)
        {
        case KindCase.kindNotSet:
            return true;
        case KindCase.nullValue:
            return nullValue == other.nullValue;
        case KindCase.numberValue:
            return numberValue == other.numberValue;
        case KindCase.stringValue:
            return stringValue == other.stringValue;
        case KindCase.boolValue:
            return boolValue == other.boolValue;
        case KindCase.structValue:
            return structValue == other.structValue;
        case KindCase.listValue:
            return listValue == other.listValue;
        }
    }

    JSONValue toJSONValue()()
    {
        import std.array : array, assocArray;
        import std.algorithm : map;
        import std.typecons : tuple;

        final switch (kindCase)
        {
        case KindCase.kindNotSet:
            return JSONValue(null);
        case KindCase.nullValue:
            return JSONValue(null);
        case KindCase.numberValue:
            return JSONValue(numberValue);
        case KindCase.stringValue:
            return JSONValue(stringValue);
        case KindCase.boolValue:
            return JSONValue(boolValue);
        case KindCase.structValue:
            return JSONValue(structValue.fields.byKeyValue.map!(a => tuple(a.key, a.value.toJSONValue)).assocArray);
        case KindCase.listValue:
            return JSONValue(listValue.values.map!(a => a.toJSONValue).array);
        }
    }

    auto fromJSONValue()(JSONValue jsonValue)
    {
        import std.array : array, assocArray;
        import std.algorithm : map;
        import std.json : JSONType;
        import std.typecons : tuple;

        switch (jsonValue.type)
        {
        case JSONType.null_:
            nullValue = NullValue.NULL_VALUE;
            break;
        case JSONType.string:
            stringValue = jsonValue.str;
            break;
        case JSONType.integer:
            numberValue = jsonValue.integer;
            break;
        case JSONType.uinteger:
            numberValue = jsonValue.uinteger;
            break;
        case JSONType.float_:
            numberValue = jsonValue.floating;
            break;
        case JSONType.object:
            if (structValue is null)
                structValue = new Struct;
            structValue.fields = jsonValue.object.byKeyValue.map!(a => tuple(a.key, new Value(a.value))).assocArray;
            break;
        case JSONType.array:
            if (listValue is null)
                listValue = new ListValue;
            listValue.values = jsonValue.array.map!(a => new Value(a)).array;
            break;
        case JSONType.true_:
            boolValue = true;
            break;
        case JSONType.false_:
            boolValue = false;
            break;
        default:
            throw new ProtobufException("Unexpected JSON type");
        }

        return this;
    }
}

enum NullValue
{
    NULL_VALUE = 0,
}

class ListValue
{
    @Proto(1) Value[] values = protoDefaultValue!(Value[]);

    this()
    {
    }

    this(JSONValue value)
    {
        fromJSONValue(value);
    }

    JSONValue toJSONValue()()
    {
        import std.array : array;
        import std.algorithm : map;

        return JSONValue(values.map!(a => a.toJSONValue).array);
    }

    auto fromJSONValue()(JSONValue value)
    {
        import std.array : array;
        import std.algorithm : map;
        import std.exception : enforce;
        import std.json : JSONType;

        if (value.type == JSONType.null_)
        {
            values = protoDefaultValue!(Value[]);
            return this;
        }

        enforce!ProtobufException(value.type == JSONType.array, "JSON array expected");
        values = value.array.map!(a => new Value(a)).array;

        return this;
    }
}
