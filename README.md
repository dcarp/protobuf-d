[![Build Status](https://travis-ci.org/dcarp/protobuf-d.png)](https://travis-ci.org/dcarp/protobuf-d)

D Support for Protocol Buffers
==============================

This D package implements the Protocol Buffers encoding and decoding
operations for both binary and JSON formats. The support library uses the
generated D code that defines the messages and enum types.

Together with this library D generation support was added to `protoc`. The
generated code is very simple and easy to read.

:warning: `protoc-gen-d` plugin generates D code for **proto3** `.proto`
files only.

Installation
------------

The Protocol Buffers D support library is distributed as
[DUB package](https://code.dlang.org/packages/protobuf). Use the instructions
there about how to integrate it in your project.

The DUB package contains the support library and the `protoc-gen-d` `protoc`
plugin. In order to have the D code generation available (`--d_out` option)
`protoc-gen-d` needs to be specified to `protoc` invocation via `--plugin`
option. Please see the Protocol Buffers README about installing `protoc` on
your system.

Examples
--------

Run following commands:
```shell
dub build :protoc-gen-d
cd examples
dub build :add_person
dub build :list_people
```
Prerequisites:
 - `protoc` version 3.0 or newer
 - Protobuf well known types `.proto` files installed or accessible for `protoc`
