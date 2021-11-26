import Combine
import SwiftUI

final class PostDetailViewModel: ObservableObject {
  @Published var post: Boring_Types_Post
  @Published var comments = [Boring_Types_Comment]()
  @Published var isLoading = true

  private let ffi: FFI
  private var cancellables = Set<AnyCancellable>()

  init(post: Boring_Types_Post, ffi: FFI) {
    self.post = post
    self.ffi = ffi
  }

  func loadComments() {
    self.ffi.getComments(postID: self.post.id)
      .receive(on: DispatchQueue.main)
      .replaceError(with: [])
      .sink(receiveValue: { [weak self] comments in
        self?.comments = comments
        self?.isLoading = false
      })
      .store(in: &self.cancellables)
  }
}

struct PostDetailView: View {
  @ObservedObject var viewModel: PostDetailViewModel

  var body: some View {
    List {
      VStack(alignment: .leading) {
        Text(viewModel.post.title).font(.title).padding(.bottom)
        Text(viewModel.post.body).padding(.bottom, 30)

        Text("Comments")
          .font(.subheadline)
          .padding(.bottom)

        if self.viewModel.isLoading {
          ProgressView()
        } else if self.viewModel.comments.isEmpty {
          Text("No comments")
        } else {
          ForEach(self.viewModel.comments, id: \.id) { comment in
            VStack(alignment: .leading) {
              Text(comment.name).bold()
              Text(comment.email).padding(.bottom)
              Text(comment.body)
            }
            .padding(.bottom)
            .font(.footnote)
          }
        }
      }
    }
    .navigationTitle("Detail")
    .onAppear {
      self.viewModel.loadComments()
    }
  }
}
