module google.protobuf.descriptor;

import std.typecons : Yes;

import google.protobuf;

class FileDescriptorSet
{
    @Proto(1) FileDescriptorProto[] files = protoDefaultValue!(FileDescriptorProto[]);
}

class FileDescriptorProto
{
    @Proto(1) string name = protoDefaultValue!string;
    @Proto(2) string package_ = protoDefaultValue!string;
    @Proto(3) string[] dependencies = protoDefaultValue!(string[]);
    @Proto(4) DescriptorProto[] messageTypes = protoDefaultValue!(DescriptorProto[]);
    @Proto(5) EnumDescriptorProto[] enumTypes = protoDefaultValue!(EnumDescriptorProto[]);
    @Proto(6) ServiceDescriptorProto[] services = protoDefaultValue!(ServiceDescriptorProto[]);
    @Proto(7) FieldDescriptorProto[] extensions = protoDefaultValue!(FieldDescriptorProto[]);
    @Proto(8) FileOptions options = protoDefaultValue!FileOptions;
    @Proto(9) SourceCodeInfo sourceCodeInfo = protoDefaultValue!SourceCodeInfo;
    @Proto(10) int[] publicDependencies = protoDefaultValue!(int[]);
    @Proto(11) int[] weakDependencies = protoDefaultValue!(int[]);
    @Proto(12) string syntax = protoDefaultValue!string;
}

class DescriptorProto
{
    @Proto(1) string name = protoDefaultValue!string;
    @Proto(2) FieldDescriptorProto[] fields = protoDefaultValue!(FieldDescriptorProto[]);
    @Proto(3) DescriptorProto[] nestedTypes = protoDefaultValue!(DescriptorProto[]);
    @Proto(4) EnumDescriptorProto[] enumTypes = protoDefaultValue!(EnumDescriptorProto[]);
    @Proto(5) ExtensionRange[] extensionRanges = protoDefaultValue!(ExtensionRange[]);
    @Proto(6) FieldDescriptorProto[] extensions = protoDefaultValue!(FieldDescriptorProto[]);
    @Proto(7) MessageOptions options = protoDefaultValue!MessageOptions;
    @Proto(8) OneofDescriptorProto[] oneofDecls = protoDefaultValue!(OneofDescriptorProto[]);
    @Proto(9) ReservedRange[] reservedRanges = protoDefaultValue!(ReservedRange[]);
    @Proto(10) string[] reservedNames = protoDefaultValue!(string[]);

    static class ExtensionRange
    {
        @Proto(1) int start = protoDefaultValue!int;
        @Proto(2) int end = protoDefaultValue!int;
        @Proto(3) ExtensionRangeOptions options = protoDefaultValue!ExtensionRangeOptions;
    }

    static class ReservedRange
    {
        @Proto(1) int start = protoDefaultValue!int;
        @Proto(2) int end = protoDefaultValue!int;
    }
}

class ExtensionRangeOptions
{
    @Proto(999) UninterpretedOption[] uninterpretedOptions = protoDefaultValue!(UninterpretedOption[]);
}

class FieldDescriptorProto
{
    @Proto(1) string name = protoDefaultValue!string;
    @Proto(2) string extendee = protoDefaultValue!string;
    @Proto(3) int number = protoDefaultValue!int;
    @Proto(4) Label label = protoDefaultValue!Label;
    @Proto(5) Type type = protoDefaultValue!Type;
    @Proto(6) string typeName = protoDefaultValue!string;
    @Proto(7) string defaultValue = protoDefaultValue!string;
    @Proto(8) FieldOptions options = protoDefaultValue!FieldOptions;
    @Proto(9) int oneofIndex = -1;
    @Proto(10) string jsonName = protoDefaultValue!string;

    enum Type
    {
        TYPE_ERROR = 0,
        TYPE_DOUBLE = 1,
        TYPE_FLOAT = 2,
        TYPE_INT64 = 3,
        TYPE_UINT64 = 4,
        TYPE_INT32 = 5,
        TYPE_FIXED64 = 6,
        TYPE_FIXED32 = 7,
        TYPE_BOOL = 8,
        TYPE_STRING = 9,
        TYPE_GROUP = 10,
        TYPE_MESSAGE = 11,
        TYPE_BYTES = 12,
        TYPE_UINT32 = 13,
        TYPE_ENUM = 14,
        TYPE_SFIXED32 = 15,
        TYPE_SFIXED64 = 16,
        TYPE_SINT32 = 17,
        TYPE_SINT64 = 18,
    }

    enum Label
    {
        LABEL_ERROR = 0,
        LABEL_OPTIONAL = 1,
        LABEL_REQUIRED = 2,
        LABEL_REPEATED = 3,
    }
}

class OneofDescriptorProto
{
    @Proto(1) string name = protoDefaultValue!string;
    @Proto(2) OneofOptions options = protoDefaultValue!OneofOptions;
}

class EnumDescriptorProto
{
    @Proto(1) string name = protoDefaultValue!string;
    @Proto(2) EnumValueDescriptorProto[] values = protoDefaultValue!(EnumValueDescriptorProto[]);
    @Proto(3) EnumOptions options = protoDefaultValue!EnumOptions;
    @Proto(4) EnumReservedRange[] reservedRanges = protoDefaultValue!(EnumReservedRange[]);
    @Proto(5) string[] reservedNames = protoDefaultValue!(string[]);

    static class EnumReservedRange
    {
        @Proto(1) int start = protoDefaultValue!int;
        @Proto(2) int end = protoDefaultValue!int;
    }
}

class EnumValueDescriptorProto
{
    @Proto(1) string name = protoDefaultValue!string;
    @Proto(2) int number = protoDefaultValue!int;
    @Proto(3) EnumValueOptions options = protoDefaultValue!EnumValueOptions;
}

class ServiceDescriptorProto
{
    @Proto(1) string name = protoDefaultValue!string;
    @Proto(2) MethodDescriptorProto[] method = protoDefaultValue!(MethodDescriptorProto[]);
    @Proto(3) ServiceOptions options = protoDefaultValue!ServiceOptions;
}

class MethodDescriptorProto
{
    @Proto(1) string name = protoDefaultValue!string;
    @Proto(2) string inputType = protoDefaultValue!string;
    @Proto(3) string outputType = protoDefaultValue!string;
    @Proto(4) MethodOptions options = protoDefaultValue!MethodOptions;
    @Proto(5) bool clientStreaming = protoDefaultValue!bool;
    @Proto(6) bool serverStreaming = protoDefaultValue!bool;
}

class FileOptions
{
    @Proto(1) string javaPackage = protoDefaultValue!string;
    @Proto(8) string javaOuterClassname = protoDefaultValue!string;
    @Proto(9) OptimizeMode optimizeFor = protoDefaultValue!OptimizeMode;
    @Proto(10) bool javaMultipleFiles = protoDefaultValue!bool;
    @Proto(11) string goPackage = protoDefaultValue!string;
    @Proto(16) bool ccGenericServices = protoDefaultValue!bool;
    @Proto(17) bool javaGenericServices = protoDefaultValue!bool;
    @Proto(18) bool pyGenericServices = protoDefaultValue!bool;
    @Proto(20) bool javaGenerateEqualsAndHash = protoDefaultValue!bool;
    @Proto(23) bool deprecated_ = protoDefaultValue!bool;
    @Proto(27) bool javaStringCheckUtf8 = protoDefaultValue!bool;
    @Proto(31) bool ccEnableArenas = protoDefaultValue!bool;
    @Proto(36) string objcClassPrefix = protoDefaultValue!string;
    @Proto(37) string csharpNamespace = protoDefaultValue!string;
    @Proto(39) string swiftPrefix = protoDefaultValue!string;
    @Proto(40) string phpClassPrefix = protoDefaultValue!string;
    @Proto(41) string phpNamespace = protoDefaultValue!string;
    @Proto(42) bool phpGenericServices = protoDefaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = protoDefaultValue!(UninterpretedOption[]);

    enum OptimizeMode
    {
        UNKNOEN = 0,
        SPEED = 1,
        CODE_SIZE = 2,
        LITE_RUNTIME = 3,
    }
}

class MessageOptions
{
    @Proto(1) bool messageSetWireFormat = protoDefaultValue!bool;
    @Proto(2) bool noStandardDescriptorAccessor = protoDefaultValue!bool;
    @Proto(3) bool deprecated_ = protoDefaultValue!bool;
    @Proto(7) bool mapEntry = protoDefaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = protoDefaultValue!(UninterpretedOption[]);
}

class FieldOptions
{
    @Proto(1) CType ctype = protoDefaultValue!CType;
    @Proto(2) bool packed = protoDefaultValue!bool;
    @Proto(3) bool deprecated_ = protoDefaultValue!bool;
    @Proto(5) bool lazy_ = protoDefaultValue!bool;
    @Proto(6) JSType jstype = protoDefaultValue!JSType;
    @Proto(10) bool weak = protoDefaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = protoDefaultValue!(UninterpretedOption[]);

    enum CType
    {
        STRING = 0,
        CORD = 1,
        STRING_PIECE = 2,
    }

    enum JSType
    {
        JS_NORMAL = 0,
        JS_STRING = 1,
        JS_NUMBER = 2,
    }
}

class OneofOptions
{
    @Proto(999) UninterpretedOption[] uninterpretedOptions = protoDefaultValue!(UninterpretedOption[]);
}

class EnumOptions
{
    @Proto(2) bool allowAlias = protoDefaultValue!bool;
    @Proto(3) bool deprecated_ = protoDefaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = protoDefaultValue!(UninterpretedOption[]);
}

class EnumValueOptions
{
    @Proto(1) bool deprecated_ = protoDefaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = protoDefaultValue!(UninterpretedOption[]);
}

class ServiceOptions
{
    @Proto(33) bool deprecated_ = protoDefaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = protoDefaultValue!(UninterpretedOption[]);
}

class MethodOptions
{
    @Proto(33) bool deprecated_ = protoDefaultValue!bool;
    @Proto(34) IdempotencyLevel idempotencyLevel = protoDefaultValue!IdempotencyLevel;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = protoDefaultValue!(UninterpretedOption[]);

    enum IdempotencyLevel
    {
        IDEMPOTENCY_UNKNOWN = 0,
        NO_SIDE_EFFECTS = 1,
        IDEMPOTENT = 2,
    }
}

class UninterpretedOption
{
    @Proto(2) NamePart[] names = protoDefaultValue!(NamePart[]);
    @Proto(3) string identifierValue = protoDefaultValue!string;
    @Proto(4) ulong positiveIntValue = protoDefaultValue!ulong;
    @Proto(5) long negativeIntValue = protoDefaultValue!long;
    @Proto(6) double doubleValue = protoDefaultValue!double;
    @Proto(7) bytes stringValue = protoDefaultValue!bytes;
    @Proto(8) string aggregateValue = protoDefaultValue!string;

    static class NamePart
    {
        @Proto(1) string namePart = protoDefaultValue!string;
        @Proto(2) bool isExtension = protoDefaultValue!bool;
    }
}

class SourceCodeInfo
{
    @Proto(1) Location[] location = protoDefaultValue!(Location[]);

    static class Location
    {
        @Proto(1, Wire.none, Yes.packed) int[] path = protoDefaultValue!(int[]);
        @Proto(2, Wire.none, Yes.packed) int[] span = protoDefaultValue!(int[]);
        @Proto(3) string leadingComments = protoDefaultValue!string;
        @Proto(4) string trailingComments = protoDefaultValue!string;
        @Proto(6) string[] leadingDetachedComments = protoDefaultValue!(string[]);
    }
}

class GeneratedCodeInfo
{
    @Proto(1) Annotation[] annotations = protoDefaultValue!(Annotation[]);

    static class Annotation
    {
        @Proto(1, Wire.none, Yes.packed) int[] path = protoDefaultValue!(int[]);
        @Proto(2) string sourceFile = protoDefaultValue!string;
        @Proto(3) int begin = protoDefaultValue!int;
        @Proto(4) int end = protoDefaultValue!int;
    }
}
