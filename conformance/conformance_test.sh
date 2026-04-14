#!/usr/bin/env bash

set -euo pipefail

testee="$1"
failure_list="$2"
protobuf_protoc="$3"

work_root="${TEST_TMPDIR:-/tmp}/protobuf-d-conformance"

if [[ -n "${PROTOBUF_DIR:-}" ]]; then
  protobuf_src="$PROTOBUF_DIR"
else
  protoc_realpath="$(readlink -f "$protobuf_protoc")"
  protobuf_src="${protoc_realpath%%/bazel-out/*}/external/protobuf+"
fi

rm -rf "$work_root"
mkdir -p "$work_root"

export HOME="$work_root/home"
export XDG_CACHE_HOME="$work_root/cache"
mkdir -p "$HOME" "$XDG_CACHE_HOME"

cd "$protobuf_src"

bazel --output_user_root="$work_root/bazel-root" \
  build //conformance:conformance_test_runner \
  --color=no \
  --curses=no \
  --enable_bzlmod

"$protobuf_src/bazel-bin/conformance/conformance_test_runner" \
  --failure_list "$failure_list" \
  "$testee"
