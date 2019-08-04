import Flex
import Lists
import NSMUIKit

struct PostCellStyle {
  var author: AuthorViewStyle
  var title: LabelStyle
  var body: LabelStyle
  var padding: UIEdgeInsets
}

class PostCell: SizableCell {
  private let authorView: AuthorView
  private let titleLabel: Label
  private let bodyLabel: Label

  required init(frame: CGRect) {
    self.authorView = AuthorView()
    self.titleLabel = Label()
    self.bodyLabel = Label()

    super.init(frame: .zero)

    let columnView = UIView()

    self.addSubview(self.authorView)
    self.addSubview(columnView)
    columnView.addSubview(self.titleLabel)
    columnView.addSubview(self.bodyLabel)

    self.flex.style {
      $0.enabled = true
      $0.direction = .row
    }

    columnView.flex.style {
      $0.enabled = true
      $0.direction = .column
      $0.grow = 1
      $0.shrink = 1
    }

    self.titleLabel.flex.grow = 1
    self.bodyLabel.flex.grow = 1
  }

  func applyValue(_ value: Boring_Types_Post, style: PostCellStyle) {
    self.authorView.applyValue(String(value.userID), style: style.author)

    self.titleLabel.text = value.title
    self.bodyLabel.text = value.body

    self.titleLabel.apply(style.title)
    self.bodyLabel.apply(style.body)
    self.flex.style {
      $0.paddingTop = .point(style.padding.top)
      $0.paddingBottom = .point(style.padding.bottom)
    }

    self.flex.setIsDirty()
    self.setNeedsLayout()
  }

  func authorTapped(handler: @escaping () -> ()) {
    self.authorView.tapHandler = handler
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.authorView.tapHandler = nil
  }
}
