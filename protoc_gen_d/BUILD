load("@io_bazel_rules_d//d:d.bzl", "d_binary")

d_binary(
    name = "protoc_gen_d",
    srcs = [
        "google/protobuf/compiler/plugin.d",
        "google/protobuf/descriptor.d",
        "protoc-gen-d.d",
    ],
    deps = ["//src:protobuf"],
)
