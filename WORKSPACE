workspace(name = "protobuf")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "io_bazel_rules_d",
    urls = ["https://github.com/bazelbuild/rules_d/archive/bcf137e3c9381545ce54715632bc1d31c51ee4da.tar.gz"],
    sha256 = "a32847bf2ae634563dece49c4dc8353956b64ba5c2d01ce811ea243e1a21b5b7",
    strip_prefix = "rules_d-bcf137e3c9381545ce54715632bc1d31c51ee4da",
)

load("@io_bazel_rules_d//d:d.bzl", "d_repositories")
d_repositories()
