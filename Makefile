projpath = ./swift/BoringTwitterClone
proto_path = $(projpath)/Proto
ffi_path = $(projpath)/Rust

libname = libboring_core

all: protoc ios_lib

protoc:
	protoc --proto_path=proto --swift_out=$(proto_path) proto/types.proto

ios_lib:
	cd rust; cargo lipo --release

	mkdir -p $(ffi_path)/libs
	mkdir -p $(ffi_path)/include

	cp rust/include/ffi.h $(ffi_path)/include
	cp rust/target/universal/release/$(libname).a $(ffi_path)/libs