import Flex
import Lists
import NSMUIKit

struct CommentCellStyle {
  var name: LabelStyle
  var body: LabelStyle
  var padding: UIEdgeInsets
}

class CommentCell: SizableCell {
  private let nameLabel: Label
  private let bodyLabel: Label

  var nameTapped: (() -> ())?

  required init(frame: CGRect) {
    self.nameLabel = Label()
    self.bodyLabel = Label()

    super.init(frame: .zero)

    self.addSubview(self.nameLabel)
    self.addSubview(self.bodyLabel)

    self.flex.style {
      $0.enabled = true
      $0.direction = .column
    }

    self.nameLabel.flex.grow = 1
    self.bodyLabel.flex.grow = 1

    self.isUserInteractionEnabled = true
  }

  func applyValue(_ value: Boring_Types_Comment, style: CommentCellStyle) {
    self.nameLabel.text = value.name
    self.bodyLabel.text = value.body

    self.nameLabel.apply(style.name)
    self.bodyLabel.apply(style.body)
    self.flex.style {
      $0.paddingTop = .point(style.padding.top)
      $0.paddingBottom = .point(style.padding.bottom)
    }

    self.flex.setIsDirty()
    self.setNeedsLayout()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.nameTapped = nil
  }

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)

    // This is somewhat of a hack, but good enough for our purpose.
    // `lastTouchLocation` is set by the CollectionViewContainerCell in touchesBegan.
    guard
      highlighted,
      let lastTouchLocation = self.lastTouchLocation,
      let tapHandler = self.nameTapped
    else {
      return
    }

    // Increase the chance that the name is hit.
    let nameLabelFrame = self.nameLabel.frame.inset(by: UIEdgeInsets(all: -10))
    if nameLabelFrame.contains(lastTouchLocation) {
      tapHandler()
    }
  }
}
