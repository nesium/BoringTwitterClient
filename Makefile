projpath = ./swift
proto_path = $(projpath)/Proto
ffi_path = $(projpath)/Rust
cargo = ~/.cargo/bin/cargo
framework_name = Boring
xcframework_root = $(ffi_path)/$(framework_name).xcframework
common = $(xcframework_root)/common/$(framework_name).framework
libname = libboring_core

all: protoc ios_lib

protoc:
	protoc --proto_path=proto --swift_out=$(proto_path) proto/types.proto

ios_lib:
	cd rust; $(cargo) build --target x86_64-apple-ios --release
	cd rust; $(cargo) build --target aarch64-apple-ios --release
	cd rust; $(cargo) build --target aarch64-apple-ios-sim --release

	rm -rf $(xcframework_root)
	mkdir -p $(common)/Modules
	cp rust/module.modulemap $(common)/Modules
	mkdir -p $(common)/Headers
	cp rust/include/ffi.h $(common)/Headers
	cp rust/Boring.h $(common)/Headers

	mkdir -p $(xcframework_root)/ios-arm64
	cp -r $(common) $(xcframework_root)/ios-arm64/$(framework_name).framework
	cp rust/target/aarch64-apple-ios/release/$(libname).a $(xcframework_root)/ios-arm64/$(framework_name).framework/$(framework_name)

	mkdir -p $(xcframework_root)/ios-arm64_x86_64-simulator
	cp -r $(common) $(xcframework_root)/ios-arm64_x86_64-simulator/$(framework_name).framework
	lipo -create \
		-output $(xcframework_root)/ios-arm64_x86_64-simulator/$(framework_name).framework/$(framework_name) \
		rust/target/aarch64-apple-ios-sim/release/$(libname).a \
		rust/target/x86_64-apple-ios/release/$(libname).a

	cp rust/Info.plist $(xcframework_root)/Info.plist

	rm -rf $(xcframework_root)/common