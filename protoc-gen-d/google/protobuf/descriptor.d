module google.protobuf.descriptor;

import std.typecons : Yes;

import google.protobuf;

class FileDescriptorSet
{
    @Proto(1) FileDescriptorProto[] files = defaultValue!(FileDescriptorProto[]);
}

class FileDescriptorProto
{
    @Proto(1) string name = defaultValue!string;
    @Proto(2) string package_ = defaultValue!string;
    @Proto(3) string[] dependencies = defaultValue!(string[]);
    @Proto(4) DescriptorProto[] messageTypes = defaultValue!(DescriptorProto[]);
    @Proto(5) EnumDescriptorProto[] enumTypes = defaultValue!(EnumDescriptorProto[]);
    @Proto(6) ServiceDescriptorProto[] services = defaultValue!(ServiceDescriptorProto[]);
    @Proto(7) FieldDescriptorProto[] extensions = defaultValue!(FieldDescriptorProto[]);
    @Proto(8) FileOptions options = defaultValue!FileOptions;
    @Proto(9) SourceCodeInfo sourceCodeInfo = defaultValue!SourceCodeInfo;
    @Proto(10) int[] publicDependencies = defaultValue!(int[]);
    @Proto(11) int[] weakDependencies = defaultValue!(int[]);
    @Proto(12) string syntax = defaultValue!string;
}

class DescriptorProto
{
    @Proto(1) string name = defaultValue!string;
    @Proto(2) FieldDescriptorProto[] fields = defaultValue!(FieldDescriptorProto[]);
    @Proto(3) DescriptorProto[] nestedTypes = defaultValue!(DescriptorProto[]);
    @Proto(4) EnumDescriptorProto[] enumTypes = defaultValue!(EnumDescriptorProto[]);
    @Proto(5) ExtensionRange[] extensionRanges = defaultValue!(ExtensionRange[]);
    @Proto(6) FieldDescriptorProto[] extensions = defaultValue!(FieldDescriptorProto[]);
    @Proto(7) MessageOptions options = defaultValue!MessageOptions;
    @Proto(8) OneofDescriptorProto[] oneofDecls = defaultValue!(OneofDescriptorProto[]);
    @Proto(9) ReservedRange[] reservedRanges = defaultValue!(ReservedRange[]);
    @Proto(10) string[] reservedNames = defaultValue!(string[]);

    static class ExtensionRange
    {
        @Proto(1) int start = defaultValue!int;
        @Proto(2) int end = defaultValue!int;
        @Proto(3) ExtensionRangeOptions options = defaultValue!ExtensionRangeOptions;
    }

    static class ReservedRange
    {
        @Proto(1) int start = defaultValue!int;
        @Proto(2) int end = defaultValue!int;
    }
}

class ExtensionRangeOptions
{
    @Proto(999) UninterpretedOption[] uninterpretedOptions = defaultValue!(UninterpretedOption[]);
}

class FieldDescriptorProto
{
    @Proto(1) string name = defaultValue!string;
    @Proto(2) string extendee = defaultValue!string;
    @Proto(3) int number = defaultValue!int;
    @Proto(4) Label label = defaultValue!Label;
    @Proto(5) Type type = defaultValue!Type;
    @Proto(6) string typeName = defaultValue!string;
    @Proto(7) string defaultValue_ = defaultValue!string;
    @Proto(8) FieldOptions options = defaultValue!FieldOptions;
    @Proto(9) int oneofIndex = -1;
    @Proto(10) string jsonName = defaultValue!string;

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
    @Proto(1) string name = defaultValue!string;
    @Proto(2) OneofOptions options = defaultValue!OneofOptions;
}

class EnumDescriptorProto
{
    @Proto(1) string name = defaultValue!string;
    @Proto(2) EnumValueDescriptorProto[] values = defaultValue!(EnumValueDescriptorProto[]);
    @Proto(3) EnumOptions options = defaultValue!EnumOptions;
    @Proto(4) EnumReservedRange[] reservedRanges = defaultValue!(EnumReservedRange[]);
    @Proto(5) string[] reservedNames = defaultValue!(string[]);

    static class EnumReservedRange
    {
        @Proto(1) int start = defaultValue!int;
        @Proto(2) int end = defaultValue!int;
    }
}

class EnumValueDescriptorProto
{
    @Proto(1) string name = defaultValue!string;
    @Proto(2) int number = defaultValue!int;
    @Proto(3) EnumValueOptions options = defaultValue!EnumValueOptions;
}

class ServiceDescriptorProto
{
    @Proto(1) string name = defaultValue!string;
    @Proto(2) MethodDescriptorProto[] method = defaultValue!(MethodDescriptorProto[]);
    @Proto(3) ServiceOptions options = defaultValue!ServiceOptions;
}

class MethodDescriptorProto
{
    @Proto(1) string name = defaultValue!string;
    @Proto(2) string inputType = defaultValue!string;
    @Proto(3) string outputType = defaultValue!string;
    @Proto(4) MethodOptions options = defaultValue!MethodOptions;
    @Proto(5) bool clientStreaming = defaultValue!bool;
    @Proto(6) bool serverStreaming = defaultValue!bool;
}

class FileOptions
{
    @Proto(1) string javaPackage = defaultValue!string;
    @Proto(8) string javaOuterClassname = defaultValue!string;
    @Proto(9) OptimizeMode optimizeFor = defaultValue!OptimizeMode;
    @Proto(10) bool javaMultipleFiles = defaultValue!bool;
    @Proto(11) string goPackage = defaultValue!string;
    @Proto(16) bool ccGenericServices = defaultValue!bool;
    @Proto(17) bool javaGenericServices = defaultValue!bool;
    @Proto(18) bool pyGenericServices = defaultValue!bool;
    @Proto(20) bool javaGenerateEqualsAndHash = defaultValue!bool;
    @Proto(23) bool deprecated_ = defaultValue!bool;
    @Proto(27) bool javaStringCheckUtf8 = defaultValue!bool;
    @Proto(31) bool ccEnableArenas = defaultValue!bool;
    @Proto(36) string objcClassPrefix = defaultValue!string;
    @Proto(37) string csharpNamespace = defaultValue!string;
    @Proto(39) string swiftPrefix = defaultValue!string;
    @Proto(40) string phpClassPrefix = defaultValue!string;
    @Proto(41) string phpNamespace = defaultValue!string;
    @Proto(42) bool phpGenericServices = defaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = defaultValue!(UninterpretedOption[]);

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
    @Proto(1) bool messageSetWireFormat = defaultValue!bool;
    @Proto(2) bool noStandardDescriptorAccessor = defaultValue!bool;
    @Proto(3) bool deprecated_ = defaultValue!bool;
    @Proto(7) bool mapEntry = defaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = defaultValue!(UninterpretedOption[]);
}

class FieldOptions
{
    @Proto(1) CType ctype = defaultValue!CType;
    @Proto(2) bool packed = defaultValue!bool;
    @Proto(3) bool deprecated_ = defaultValue!bool;
    @Proto(5) bool lazy_ = defaultValue!bool;
    @Proto(6) JSType jstype = defaultValue!JSType;
    @Proto(10) bool weak = defaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = defaultValue!(UninterpretedOption[]);

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
    @Proto(999) UninterpretedOption[] uninterpretedOptions = defaultValue!(UninterpretedOption[]);
}

class EnumOptions
{
    @Proto(2) bool allowAlias = defaultValue!bool;
    @Proto(3) bool deprecated_ = defaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = defaultValue!(UninterpretedOption[]);
}

class EnumValueOptions
{
    @Proto(1) bool deprecated_ = defaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = defaultValue!(UninterpretedOption[]);
}

class ServiceOptions
{
    @Proto(33) bool deprecated_ = defaultValue!bool;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = defaultValue!(UninterpretedOption[]);
}

class MethodOptions
{
    @Proto(33) bool deprecated_ = defaultValue!bool;
    @Proto(34) IdempotencyLevel idempotencyLevel = defaultValue!IdempotencyLevel;
    @Proto(999) UninterpretedOption[] uninterpretedOptions = defaultValue!(UninterpretedOption[]);

    enum IdempotencyLevel
    {
        IDEMPOTENCY_UNKNOWN = 0,
        NO_SIDE_EFFECTS = 1,
        IDEMPOTENT = 2,
    }
}

class UninterpretedOption
{
    @Proto(2) NamePart[] names = defaultValue!(NamePart[]);
    @Proto(3) string identifierValue = defaultValue!string;
    @Proto(4) ulong positiveIntValue = defaultValue!ulong;
    @Proto(5) long negativeIntValue = defaultValue!long;
    @Proto(6) double doubleValue = defaultValue!double;
    @Proto(7) bytes stringValue = defaultValue!bytes;
    @Proto(8) string aggregateValue = defaultValue!string;

    static class NamePart
    {
        @Proto(1) string namePart = defaultValue!string;
        @Proto(2) bool isExtension = defaultValue!bool;
    }
}

class SourceCodeInfo
{
    @Proto(1) Location[] location = defaultValue!(Location[]);

    static class Location
    {
        @Proto(1, Wire.none, Yes.packed) int[] path = defaultValue!(int[]);
        @Proto(2, Wire.none, Yes.packed) int[] span = defaultValue!(int[]);
        @Proto(3) string leadingComments = defaultValue!string;
        @Proto(4) string trailingComments = defaultValue!string;
        @Proto(6) string[] leadingDetachedComments = defaultValue!(string[]);
    }
}

class GeneratedCodeInfo
{
    @Proto(1) Annotation[] annotations = defaultValue!(Annotation[]);

    static class Annotation
    {
        @Proto(1, Wire.none, Yes.packed) int[] path = defaultValue!(int[]);
        @Proto(2) string sourceFile = defaultValue!string;
        @Proto(3) int begin = defaultValue!int;
        @Proto(4) int end = defaultValue!int;
    }
}
