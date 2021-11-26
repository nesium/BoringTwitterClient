import SwiftUI

@main
struct BoringApp: App {
  private let ffi: FFI = {
    let dbURL = FileManager.default.urls(
      for: .documentDirectory, in: .userDomainMask
    ).first!.appendingPathComponent("cache.sqlite")
    return try! FFI(dbURL: dbURL)
  }()

  var body: some Scene {
    WindowGroup {
      NavigationView {
        PostListView(viewModel: PostListViewModel(ffi: self.ffi))
      }
    }
  }
}
