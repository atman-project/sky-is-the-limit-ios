set -e
# Location of rust project
RUST_PROJ="$PROJECT_DIR/Anvil"
# Location of the "Anvil" folder in the iOS project
IOS_ANVIL="$PROJECT_DIR/Anvil"
# Provide access to Rust utilities
PATH="$PATH:/Users/yjlee/.cargo/bin"

cd "$RUST_PROJ"
# Generate C bindings
cbindgen -l C -o target/anvil.h
# Build for iOS architectures
cargo build --target aarch64-apple-ios
cargo build --target x86_64-apple-ios
# Combine them into a universal library
lipo -create target/aarch64-apple-ios/debug/libanvil.a target/x86_64-apple-ios/debug/libanvil.a -output target/libanvil.a
# Copy resources to the iOS folder, overwriting old ones
cp target/anvil.h target/libanvil.a "$IOS_ANVIL"

