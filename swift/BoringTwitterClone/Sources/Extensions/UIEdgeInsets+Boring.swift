import UIKit

extension UIEdgeInsets {
  public init(all value: CGFloat) {
    self.init(top: value, left: value, bottom: value, right: value)
  }

  public init(vertical: CGFloat, horizontal: CGFloat) {
    self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
  }

  public init(top: CGFloat) {
    self.init(top: top, left: 0, bottom: 0, right: 0)
  }

  public init(left: CGFloat) {
    self.init(top: 0, left: left, bottom: 0, right: 0)
  }

  public init(bottom: CGFloat) {
    self.init(top: 0, left: 0, bottom: bottom, right: 0)
  }

  public init(right: CGFloat) {
    self.init(top: 0, left: 0, bottom: 0, right: right)
  }
}
