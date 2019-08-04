import Foundation
import RxSwift
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

  func getLatestPosts() -> Single<[Boring_Types_Post]> {
    return callFFI(Boring_Types_PostsResponse.self) { error in
      boring_core_get_latest_posts(self.handle, error)
    }.map { $0.posts }
  }

  func getAllPostsBy(author: Int64) -> Single<[Boring_Types_Post]> {
    return callFFI(Boring_Types_PostsResponse.self) { error in
      boring_core_get_all_posts_by_author(self.handle, author, error)
    }.map { $0.posts }
  }

  func getComments(postID: Int64) -> Single<[Boring_Types_Comment]> {
    return callFFI(Boring_Types_CommentsResponse.self) { error in
      boring_core_get_comments(self.handle, postID, error)
    }.map { $0.comments }
  }

  private func callFFI<T: Message>(
    _ type: T.Type,
    handler: @escaping (UnsafeMutablePointer<BoringCoreError>) throws -> (BoringBuffer)
  ) -> Single<T> {
    return Single.create { observer in
      self.queue.async {
        do {
          try BoringError.unwrap() { error in
            let buffer = try handler(error)
            let result = try T.init(serializedData: Data(buffer: buffer))
            observer(.success(result))
          }
        } catch {
          observer(.error(error))
        }
      }
      // Requests to the FFI cannot be cancelled for now.
      return Disposables.create()
    }
  }
}
