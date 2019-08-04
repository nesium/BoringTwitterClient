import UIKit

// https://useyourloaf.com/blog/scaling-dynamic-type-with-font-descriptors/
extension UIFont {
  static func preferredFont(
    forTextStyle style: UIFont.TextStyle,
    scaledBy scaleFactor: CGFloat
  ) -> UIFont {
    let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
    let pointSize = floor(fontDescriptor.pointSize * scaleFactor)
    return UIFont(descriptor: fontDescriptor, size: pointSize)
  }
}
