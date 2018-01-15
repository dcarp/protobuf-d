module google.protobuf.compiler.plugin;

import google.protobuf;
import google.protobuf.descriptor;

class Version
{
    @Proto(1) int major = defaultValue!int;
    @Proto(2) int minor = defaultValue!int;
    @Proto(3) int patch = defaultValue!int;
    @Proto(4) string suffix = defaultValue!string;
}

class CodeGeneratorRequest
{
    @Proto(1) string[] filesToGenerate = defaultValue!(string[]);
    @Proto(2) string parameter = defaultValue!string;
    @Proto(3) Version compilerVersion = defaultValue!Version;
    @Proto(15) FileDescriptorProto[] protoFiles = defaultValue!(FileDescriptorProto[]);
}

class CodeGeneratorResponse
{
    @Proto(1) string error = defaultValue!string;
    @Proto(15) File[] files = defaultValue!(File[]);

    static class File
    {
        @Proto(1) string name = defaultValue!string;
        @Proto(2) string insertionPoint = defaultValue!string;
        @Proto(15) string content = defaultValue!string;
    }
}
