import Flex
import Lists
import UIKit

class LoadingCell: ListCell {
  private let activityIndicator: CircleActivityIndicatorView

  required init(frame: CGRect) {
    self.activityIndicator = CircleActivityIndicatorView(
      style: Current.theme.loadingCell.activityIndicator
    )
    super.init(frame: .zero)
    self.addSubview(self.activityIndicator)

    self.flex.style {
      $0.enabled = true
      $0.alignItems = .center
      $0.justifyContent = .center
    }
  }

  func startAnimating() {
    self.activityIndicator.startAnimating()
  }

  override func prepareForReuse() {
    self.activityIndicator.stopAnimating()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.flex.layoutSubviews()
  }
}
