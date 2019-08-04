import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var coordinator: Coordinator?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let coordinator = Coordinator(window: UIWindow())
    coordinator.start()
    self.coordinator = coordinator
    return true
  }
}
