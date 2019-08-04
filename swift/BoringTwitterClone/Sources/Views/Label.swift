import Flex
import UIKit
import NSMUIKit

struct LabelStyle {
  var font: UIFont
  var color: UIColor
  var highlightedColor: UIColor?
  var alignment: NSTextAlignment
  var lineBreakMode: NSLineBreakMode
  var numberOfLines: Int
  var margin: UIEdgeInsets

  init(
    font: UIFont,
    color: UIColor = .black,
    highlightedColor: UIColor? = nil,
    alignment: NSTextAlignment = .left,
    lineBreakMode: NSLineBreakMode = .byTruncatingTail,
    numberOfLines: Int = 1,
    margin: UIEdgeInsets = .zero
  ) {
    self.font = font
    self.color = color
    self.highlightedColor = highlightedColor
    self.alignment = alignment
    self.lineBreakMode = lineBreakMode
    self.numberOfLines = numberOfLines
    self.margin = margin
  }
}

/// A label which can only be baseline-aligned (as it should).
final class Label: UILabel {
  override var text: String? {
    didSet {
      if self.text != oldValue {
        self.flex.setIsDirty()
      }
    }
  }

  init() {
    super.init(frame: .zero)
    self.adjustsFontForContentSizeCategory = true
    self.flex.enabled = true
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func apply(_ style: LabelStyle) {
    self.font = style.font
    self.textColor = style.color
    self.highlightedTextColor = style.highlightedColor
    self.textAlignment = style.alignment
    self.lineBreakMode = style.lineBreakMode
    self.numberOfLines = style.numberOfLines

    self.flex.setPoint(margin: style.margin)
  }

  override var alignmentRectInsets: UIEdgeInsets {
    return UIEdgeInsets(
      top: self.font.ascender - self.font.capHeight,
      left: 0,
      bottom: -self.font.descender,
      right: 0
    )
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if self.traitCollection.preferredContentSizeCategory !=
      previousTraitCollection?.preferredContentSizeCategory {
      self.flex.setIsDirty()
    }
    super.traitCollectionDidChange(previousTraitCollection)
  }
}
