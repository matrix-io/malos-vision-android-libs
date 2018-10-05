#!/usr/bin/env bash

set -eu

# shellcheck source=/dev/null
. "$(dirname "$0")/config.sh"

pushd "${PROJECT_DIR}"

./scripts/build_boost.sh
./scripts/build_gflags.sh
./scripts/build_glog.sh
./scripts/build_lmdb.sh
./scripts/build_crossguid.sh
./scripts/build_protobuf_host.sh
./scripts/build_protobuf.sh
./scripts/build_matrixio_protos.sh
./scripts/build_libzmq_cmake.sh
./scripts/build_matrix_malos_lib.sh
./scripts/build_opencv.sh

popd

echo "DONE!!"
