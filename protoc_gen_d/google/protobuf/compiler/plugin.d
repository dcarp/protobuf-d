module google.protobuf.compiler.plugin;

import google.protobuf;
import google.protobuf.descriptor;

class Version
{
    @Proto(1) int major = protoDefaultValue!int;
    @Proto(2) int minor = protoDefaultValue!int;
    @Proto(3) int patch = protoDefaultValue!int;
    @Proto(4) string suffix = protoDefaultValue!string;
}

class CodeGeneratorRequest
{
    @Proto(1) string[] filesToGenerate = protoDefaultValue!(string[]);
    @Proto(2) string parameter = protoDefaultValue!string;
    @Proto(3) Version compilerVersion = protoDefaultValue!Version;
    @Proto(15) FileDescriptorProto[] protoFiles = protoDefaultValue!(FileDescriptorProto[]);
}

class CodeGeneratorResponse
{
    @Proto(1) string error = protoDefaultValue!string;
    @Proto(15) File[] files = protoDefaultValue!(File[]);

    static class File
    {
        @Proto(1) string name = protoDefaultValue!string;
        @Proto(2) string insertionPoint = protoDefaultValue!string;
        @Proto(15) string content = protoDefaultValue!string;
    }
}
