#!/bin/bash

set -uexo pipefail

cd submodules/atman/atman
bash ./build_bindings.sh "$@"
cd -
\cp submodules/atman/target/atman.h submodules/atman/target/x86_64-apple-ios/debug/libatman.a ./atman/
ls -l ./atman
