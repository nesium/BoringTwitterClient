import UIKit
import NSMUIKit

struct AuthorViewStyle {
  var initials: LabelStyle
  var size: CGFloat
  var margin: UIEdgeInsets
}

final class AuthorView: UIControl {
  let initialsLabel: Label
  var tapHandler: (() -> ())?

  override init(frame: CGRect) {
    self.initialsLabel = Label()
    super.init(frame: .zero)
    self.addSubview(self.initialsLabel)
    self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func applyValue(_ value: String, style: AuthorViewStyle) {
    self.initialsLabel.text = value
    self.initialsLabel.apply(style.initials)

    self.flex.style {
      $0.enabled = true
      $0.width = .point(style.size)
      $0.height = .point(style.size)
      $0.alignItems = .center
      $0.justifyContent = .center
    }
    self.flex.setPoint(margin: style.margin)
    self.flex.setIsDirty()

    self.backgroundColor = .red
    self.layer.cornerRadius = style.size / 2
  }

  @objc func handleTap() {
    self.tapHandler?()
  }
}
