#! /bin/bash

set -e

cd rust
cargo build --release
cd ..

flutter_rust_bridge_codegen generate