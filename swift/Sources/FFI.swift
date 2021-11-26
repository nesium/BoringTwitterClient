import Boring
import Combine
import Foundation
import SwiftProtobuf

final class FFI {
  let queue = DispatchQueue(
    label: "com.boringtwitter",
    qos: .userInitiated,
    attributes: .concurrent
  )
  let handle: UInt64

  init(dbURL: URL) throws {
    self.handle = try BoringError.unwrap { error in
      boring_core_create_context(dbURL.absoluteString, error)
    }
  }

  func getLatestPosts() -> AnyPublisher<[Boring_Types_Post], Error> {
    return self.callFFI(Boring_Types_PostsResponse.self) { error in
      boring_core_get_latest_posts(self.handle, error)
    }
    .map { $0.posts }
    .eraseToAnyPublisher()
  }

  func getAllPostsBy(author: Int64) -> AnyPublisher<[Boring_Types_Post], Error> {
    return self.callFFI(Boring_Types_PostsResponse.self) { error in
      boring_core_get_all_posts_by_author(self.handle, author, error)
    }
    .map { $0.posts }
    .eraseToAnyPublisher()
  }

  func getComments(postID: Int64) -> AnyPublisher<[Boring_Types_Comment], Error> {
    return self.callFFI(Boring_Types_CommentsResponse.self) { error in
      boring_core_get_comments(self.handle, postID, error)
    }
    .map { $0.comments }
    .eraseToAnyPublisher()
  }

  private func callFFI<T: Message>(
    _: T.Type,
    handler: @escaping (UnsafeMutablePointer<BoringCoreError>) throws -> (BoringBuffer)
  ) -> AnyPublisher<T, Error> {
    return Deferred {
      Future { promise in
        self.queue.async {
          do {
            try BoringError.unwrap { error in
              let buffer = try handler(error)
              let result = try T(serializedData: Data(buffer: buffer))
              promise(.success(result))
            }
          } catch {
            promise(.failure(error))
          }
        }
      }
    }.eraseToAnyPublisher()
  }
}
