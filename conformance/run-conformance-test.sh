#! /bin/sh

if cd protobuf >/dev/null 2>&1; then
	git fetch
else
	git clone https://github.com/google/protobuf.git && cd protobuf
fi
git checkout tags/v3.12.2 --detach

git submodule update --init --recursive

# due to a bug run autogen.sh twice
./autogen.sh || ./autogen.sh && ./configure && make

cd conformance
make

cd ../..

./protobuf/src/protoc --plugin=../build/protoc-gen-d --d_out=. -I. -Iprotobuf/src protobuf/conformance/conformance.proto protobuf/src/google/protobuf/test_messages_proto3.proto
./protobuf/conformance/conformance-test-runner --failure_list failure_list_d.txt ./conformance-d
