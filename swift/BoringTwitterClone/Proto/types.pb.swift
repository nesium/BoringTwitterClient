// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: types.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Boring_Types_Post {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var userID: Int64 = 0

  var id: Int64 = 0

  var title: String = String()

  var body: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Boring_Types_Comment {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var postID: Int64 = 0

  var id: Int64 = 0

  var name: String = String()

  var email: String = String()

  var body: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Boring_Types_PostsResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var posts: [Boring_Types_Post] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Boring_Types_CommentsResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var comments: [Boring_Types_Comment] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "boring.types"

extension Boring_Types_Post: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Post"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "user_id"),
    2: .same(proto: "id"),
    3: .same(proto: "title"),
    4: .same(proto: "body"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt64Field(value: &self.userID)
      case 2: try decoder.decodeSingularInt64Field(value: &self.id)
      case 3: try decoder.decodeSingularStringField(value: &self.title)
      case 4: try decoder.decodeSingularStringField(value: &self.body)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.userID != 0 {
      try visitor.visitSingularInt64Field(value: self.userID, fieldNumber: 1)
    }
    if self.id != 0 {
      try visitor.visitSingularInt64Field(value: self.id, fieldNumber: 2)
    }
    if !self.title.isEmpty {
      try visitor.visitSingularStringField(value: self.title, fieldNumber: 3)
    }
    if !self.body.isEmpty {
      try visitor.visitSingularStringField(value: self.body, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Boring_Types_Post, rhs: Boring_Types_Post) -> Bool {
    if lhs.userID != rhs.userID {return false}
    if lhs.id != rhs.id {return false}
    if lhs.title != rhs.title {return false}
    if lhs.body != rhs.body {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Boring_Types_Comment: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Comment"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "post_id"),
    2: .same(proto: "id"),
    3: .same(proto: "name"),
    4: .same(proto: "email"),
    5: .same(proto: "body"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt64Field(value: &self.postID)
      case 2: try decoder.decodeSingularInt64Field(value: &self.id)
      case 3: try decoder.decodeSingularStringField(value: &self.name)
      case 4: try decoder.decodeSingularStringField(value: &self.email)
      case 5: try decoder.decodeSingularStringField(value: &self.body)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.postID != 0 {
      try visitor.visitSingularInt64Field(value: self.postID, fieldNumber: 1)
    }
    if self.id != 0 {
      try visitor.visitSingularInt64Field(value: self.id, fieldNumber: 2)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 3)
    }
    if !self.email.isEmpty {
      try visitor.visitSingularStringField(value: self.email, fieldNumber: 4)
    }
    if !self.body.isEmpty {
      try visitor.visitSingularStringField(value: self.body, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Boring_Types_Comment, rhs: Boring_Types_Comment) -> Bool {
    if lhs.postID != rhs.postID {return false}
    if lhs.id != rhs.id {return false}
    if lhs.name != rhs.name {return false}
    if lhs.email != rhs.email {return false}
    if lhs.body != rhs.body {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Boring_Types_PostsResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".PostsResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "posts"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.posts)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.posts.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.posts, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Boring_Types_PostsResponse, rhs: Boring_Types_PostsResponse) -> Bool {
    if lhs.posts != rhs.posts {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Boring_Types_CommentsResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".CommentsResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "comments"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.comments)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.comments.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.comments, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Boring_Types_CommentsResponse, rhs: Boring_Types_CommentsResponse) -> Bool {
    if lhs.comments != rhs.comments {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
