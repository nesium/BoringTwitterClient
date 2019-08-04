import RxSwift
import UIKit

final class Coordinator {
  let window: UIWindow
  let navigationController: UINavigationController
  let disposeBag = DisposeBag()

  init(window: UIWindow) {
    self.window = window
    self.navigationController = UINavigationController()
    self.window.rootViewController = self.navigationController
  }

  func start() {
    let ctrl = PostsViewController(
      posts: Current.ffi.getLatestPosts().asObservable(),
      title: NSLocalizedString("Posts", comment: "")
    )
    ctrl.entitySelected
      .subscribe(onNext: self.runEntitySelectedFlow)
      .disposed(by: ctrl.disposeBag)

    self.navigationController.viewControllers = [ctrl]
    window.makeKeyAndVisible()
  }

  func runEntitySelectedFlow(entity: SelectableEntity) {
    switch entity {
      case let .post(post):
        let ctrl = PostDetailViewController(selectedPost: post)
        ctrl.entitySelected
          .subscribe(onNext: self.runEntitySelectedFlow)
          .disposed(by: ctrl.disposeBag)
        self.navigationController.pushViewController(ctrl, animated: true)

      case let .author(authorID):
        let ctrl = PostsViewController(
          posts: Current.ffi.getAllPostsBy(author: authorID).asObservable(),
          title: String.localizedStringWithFormat(
            NSLocalizedString("%@'s Posts", comment: ""),
            String(authorID)
          )
        )
        ctrl.entitySelected
          .subscribe(onNext: self.runEntitySelectedFlow)
          .disposed(by: ctrl.disposeBag)
        self.navigationController.pushViewController(ctrl, animated: true)

      case let .email(email):
        UIApplication.shared.open(URL(string: "mailto:\(email)")!, options: [:])
        print("Send mail to \(email)")
    }
  }
}
