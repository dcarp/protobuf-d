#! /bin/sh

set -euo pipefail

if cd protobuf >/dev/null 2>&1; then
	git fetch
else
	git clone --depth 1 https://github.com/google/protobuf.git && cd protobuf
fi
git checkout tags/v30.2 --detach

git submodule update --init --recursive

cmake -S . -B .build -Dprotobuf_BUILD_CONFORMANCE=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -G Ninja 
cmake --build .build

cd ..

./protobuf/protoc --plugin=../build/protoc-gen-d --d_out=. -I. -Iprotobuf/src protobuf/conformance/conformance.proto protobuf/src/google/protobuf/test_messages_proto3.proto
./protobuf/conformance_test_runner --failure_list failure_list_d.txt ./conformance-d
