import Flex

extension FlexLayout {
  func setPoint(margin: UIEdgeInsets) {
    self.marginTop = .point(margin.top)
    self.marginLeft = .point(margin.left)
    self.marginBottom = .point(margin.bottom)
    self.marginRight = .point(margin.right)
  }
}
