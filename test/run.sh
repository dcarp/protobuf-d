#!/bin/sh
# Test script for protoc-gen-d comparing generated/*.d with golden/*.d.
set -u

cd ..
dub build :protoc-gen-d
cd -

rm -rf generated
mkdir generated

dub test
if [ $? -ne 0 ]; then
    echo "ERROR: golden is invalid."
    exit 1
fi

check() {
    protoc ${PROTO_PATH:-} --plugin=../build/protoc-gen-d "${1}" --d_out=generated
    # Ignore `enum protocVersion = ...;" line because it depends on the env.
    diff -I '^enum protocVersion = .*;$' generated/${2} golden/${2}
    if [ $? -ne 0 ]; then
        echo "ERROR: generated/${2} is different from golden/${2}."
        exit 1
    fi
}

check a/b/c.proto a/c.d
check generated_code.proto generated_code.d

echo "SUCCESS: all test cases finished."
