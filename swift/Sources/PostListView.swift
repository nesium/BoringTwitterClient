import Combine
import SwiftUI

final class PostListViewModel: ObservableObject {
  @Published var posts = [Boring_Types_Post]()
  @Published var isLoading = true

  private let ffi: FFI
  private var cancellables = Set<AnyCancellable>()

  init(ffi: FFI) {
    self.ffi = ffi
    self.ffi.getLatestPosts()
      .receive(on: DispatchQueue.main)
      .replaceError(with: [])
      .sink(receiveValue: { [weak self] posts in
        self?.posts = posts
        self?.isLoading = false
      })
      .store(in: &self.cancellables)
  }

  func viewModel(at idx: Int) -> PostDetailViewModel {
    .init(post: self.posts[idx], ffi: self.ffi)
  }
}

struct PostListView: View {
  @ObservedObject var viewModel: PostListViewModel

  var body: some View {
    Group {
      if self.viewModel.isLoading {
        ProgressView()
      } else {
        List {
          ForEach(Array(self.viewModel.posts.enumerated()), id: \.element.id) { idx, post in
            NavigationLink(destination: PostDetailView(viewModel: self.viewModel
                .viewModel(at: idx))) {
              VStack(alignment: .leading) {
                Text(post.title).lineLimit(1).font(.headline)
                Text(post.body).lineLimit(3)
              }
            }
          }
        }
      }
    }
    .navigationTitle("Posts")
  }
}
