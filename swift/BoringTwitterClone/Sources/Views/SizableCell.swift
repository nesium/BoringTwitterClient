import Flex
import Lists

class SizableCell: ListCell {
  private let backgroundView: UIView

  var didUpdateLayoutAttributes: ((UICollectionViewLayoutAttributes) -> ())?

  required init(frame: CGRect) {
    self.backgroundView = UIView()
    super.init(frame: .zero)
    self.addSubview(self.backgroundView)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.backgroundView.frame = self.bounds;
    self.flex.layoutSubviews()
  }

  override func layoutMarginsDidChange() {
    super.layoutMarginsDidChange()
    self.flex.style {
      $0.paddingLeft = .point(self.layoutMargins.left)
      $0.paddingRight = .point(self.layoutMargins.left)
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.didUpdateLayoutAttributes = nil
  }

  override func preferredLayoutAttributesFitting(
    _ layoutAttributes: UICollectionViewLayoutAttributes
  ) -> UICollectionViewLayoutAttributes {
    var frame = layoutAttributes.frame
    frame.size.height = self.flex.sizeThatFits(
      CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude)
    ).height
    layoutAttributes.frame = frame
    self.didUpdateLayoutAttributes?(layoutAttributes)
    return layoutAttributes
  }

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    let style = Current.theme.cellBackground
    let color = highlighted ? style.highlighted : style.normal

    guard highlighted == false else {
      self.backgroundView.backgroundColor = color
      return
    }

    UIView.animate(
      withDuration: 0.4,
      animations: { self.backgroundView.backgroundColor = color }
    )
  }
}
