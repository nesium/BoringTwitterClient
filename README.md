<a href="https://semaphoreci.com"><img src="https://img.shields.io/badge/Builds%20on-Semaphore%20CI-lightgrey"/></a>

# Boring "Twitter" Client

### What is it?

This is an excercise in using Rust in an iOS project to demonstrate the possibility of future cross-platform code sharing.

The project uses [Viaduct](https://github.com/mozilla/application-services/tree/master/components/viaduct) to perform requests from Rust and sends the results to Swift as ProtoBuffer objects, as described in [Crossing the Rust FFI frontier with Protocol Buffers](https://hacks.mozilla.org/2019/04/crossing-the-rust-ffi-frontier-with-protocol-buffers/).

The results are then displayed using SwiftUI.

It doesn't really work against the Twitter API, but simply against some [Mock Service](https://jsonplaceholder.typicode.com/posts/1/comments) instead. You get the idea.

### Prerequisites

To build this thing you'll need…

- Swift
- the protoc compiler and the Swift code generator, as described [here](https://github.com/apple/swift-protobuf#getting-started)
- [Rust](https://rustup.rs) (I'm using the 1.56.0 stable toolchain) and support for iOS relevant architectures (aarch64-apple-ios, aarch64-apple-ios-sim, x86_64-apple-ios)

### How to build

After you've installed the required prerequisites, run `make` in the root folder to build the Rust library and then you should be able to compile the Xcode project.
