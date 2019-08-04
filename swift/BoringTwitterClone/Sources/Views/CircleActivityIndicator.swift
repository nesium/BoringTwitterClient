import UIKit
import NSMUIKit

struct CircleActivityIndicatorStyle {
  var size: CGFloat
  var lineWidth: CGFloat
  var backgroundColor: UIColor
  var foregroundColor: UIColor
}

class CircleActivityIndicatorView: UIView, CAAnimationDelegate {
  private let style: CircleActivityIndicatorStyle
  private let backgroundLayer: CAShapeLayer
  private let animatedLayer: CAShapeLayer

  private static let strokeMinLength: CGFloat = 0.005
  private static let strokeMaxLength: CGFloat = 0.13

  private var stopAnimationCompletionHandler: (() -> ())?

  // MARK: - Initialization -

  init(style: CircleActivityIndicatorStyle) {
    self.style = style
    self.backgroundLayer = CAShapeLayer()
    self.animatedLayer = CAShapeLayer()

    super.init(frame: .zero)

    let layerActions = [
      "bounds": NSNull(),
      "position": NSNull()
    ]

    self.backgroundLayer.actions = layerActions
    self.animatedLayer.actions = layerActions

    self.layer.addSublayer(self.backgroundLayer)
    self.layer.addSublayer(self.animatedLayer)

    setupLayers()

    self.flex.style {
      $0.enabled = true
      $0.width = .point(style.size)
      $0.height = .point(style.size)
    }
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods -

  public func startAnimating() {
    guard !self.isAnimating else {
      return
    }

    self.isAnimating = true

    self.animatedLayer.strokeStart = 0.75 - CircleActivityIndicatorView.strokeMinLength
    self.animatedLayer.strokeEnd = 0.75 + CircleActivityIndicatorView.strokeMinLength
    self.animatedLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)

    let strokeEndAnimation: CABasicAnimation = CABasicAnimation()
    strokeEndAnimation.keyPath = "strokeEnd"
    strokeEndAnimation.toValue = CircleActivityIndicatorView.strokeMinLength * 2

    let rotationAnimation: CABasicAnimation = CABasicAnimation()
    rotationAnimation.keyPath = "transform.rotation.z"
    rotationAnimation.byValue = CGFloat.pi * 2

    let animationGroup: CAAnimationGroup = CAAnimationGroup()
    animationGroup.delegate = self
    animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    animationGroup.duration = 0.3
    animationGroup.animations = [strokeEndAnimation, rotationAnimation]
    animationGroup.isRemovedOnCompletion = false
    animationGroup.fillMode = CAMediaTimingFillMode.forwards

    self.animatedLayer.add(animationGroup, forKey: "IntroAnimation")
  }

  public func stopAnimating(completion: (() -> ())? = nil) {
    guard self.isAnimating else {
      completion?()
      return
    }

    self.isAnimating = false
    self.stopAnimationCompletionHandler = completion

    let strokeStartAnimation: CABasicAnimation = CABasicAnimation()
    strokeStartAnimation.keyPath = "strokeStart"
    strokeStartAnimation.toValue = 0

    let strokeEndAnimation: CABasicAnimation = CABasicAnimation()
    strokeEndAnimation.keyPath = "strokeEnd"
    strokeEndAnimation.toValue = 1

    let animationGroup: CAAnimationGroup = CAAnimationGroup()
    animationGroup.setValue("outro", forKey: "W2AnimationType")
    animationGroup.delegate = self
    animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    animationGroup.duration = 0.3
    animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
    animationGroup.isRemovedOnCompletion = false
    animationGroup.fillMode = CAMediaTimingFillMode.forwards

    self.animatedLayer.add(animationGroup, forKey: "OutroAnimation")
  }

  public private(set) var isAnimating: Bool = false

  // MARK: - UIView Methods -

  override func layoutSubviews() {
    let center: CGPoint = CGPoint(
      x: UIScreen.nsm_floor(self.bounds.width / 2),
      y: UIScreen.nsm_floor(self.bounds.height / 2))
    self.backgroundLayer.position = center
    self.animatedLayer.position = center
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: self.style.size, height: self.style.size)
  }

  // MARK: - Private Methods -

  private func setupLayers() {
    let halfLineWidth: CGFloat = UIScreen.nsm_floor(self.style.lineWidth / 2)
    let rect: CGRect = CGRect(
      x: halfLineWidth,
      y: halfLineWidth,
      width: self.style.size - self.style.lineWidth,
      height: self.style.size - self.style.lineWidth
    )
    let path: UIBezierPath = UIBezierPath(ovalIn: rect)

    self.backgroundLayer.path = path.cgPath
    self.animatedLayer.path = path.cgPath

    self.backgroundLayer.strokeColor = self.style.backgroundColor.cgColor
    self.backgroundLayer.fillColor = nil
    self.backgroundLayer.lineWidth = self.style.lineWidth
    self.backgroundLayer.lineCap = CAShapeLayerLineCap.round
    self.backgroundLayer.bounds = CGRect(x: 0, y: 0, width: self.style.size, height: self.style.size)

    self.animatedLayer.strokeColor = self.style.foregroundColor.cgColor
    self.animatedLayer.fillColor = nil
    self.animatedLayer.lineWidth = self.style.lineWidth
    self.animatedLayer.lineCap = CAShapeLayerLineCap.round
    self.animatedLayer.bounds = CGRect(x: 0, y: 0, width: self.style.size, height: self.style.size)
    self.animatedLayer.strokeStart = 0
    self.animatedLayer.strokeEnd = 1
  }

  private func beginRotationAnimation() {
    self.animatedLayer.transform = CATransform3DIdentity
    self.animatedLayer.strokeStart = 0.75 - CircleActivityIndicatorView.strokeMinLength
    self.animatedLayer.strokeEnd = 0.75 + CircleActivityIndicatorView.strokeMinLength

    self.animatedLayer.removeAllAnimations()

    let expandToLeftAnimation: CAKeyframeAnimation = CAKeyframeAnimation()
    expandToLeftAnimation.keyPath = "strokeStart"
    expandToLeftAnimation.values = [
      0.75 - CircleActivityIndicatorView.strokeMinLength,
      0.75 - CircleActivityIndicatorView.strokeMaxLength,
      0.75 - CircleActivityIndicatorView.strokeMinLength]
    expandToLeftAnimation.isCumulative = true

    let expandToRightAnimation: CAKeyframeAnimation = CAKeyframeAnimation()
    expandToRightAnimation.keyPath = "strokeEnd"
    expandToRightAnimation.values = [
      0.75 + CircleActivityIndicatorView.strokeMinLength,
      0.75 + CircleActivityIndicatorView.strokeMaxLength,
      0.75 + CircleActivityIndicatorView.strokeMinLength]
    expandToRightAnimation.isCumulative = true

    let rotationAnimation: CABasicAnimation = CABasicAnimation()
    rotationAnimation.keyPath = "transform.rotation.z"
    rotationAnimation.toValue = 2 * CGFloat.pi
    rotationAnimation.isCumulative = true

    let animationGroup: CAAnimationGroup = CAAnimationGroup()
    animationGroup.duration = 0.8
    animationGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0.2, 0.5, 0.8)
    animationGroup.repeatCount = Float.infinity
    animationGroup.animations = [expandToLeftAnimation, expandToRightAnimation, rotationAnimation]

    self.animatedLayer.add(animationGroup, forKey: "MyAnimation")
  }

  // MARK: - CAAnimationDelegate Methods -

  internal func animationDidStop(_ anim: CAAnimation, finished: Bool) {
    if let type = anim.value(forKey: "W2AnimationType") as? String, type == "outro" {
      if let completion = self.stopAnimationCompletionHandler {
        self.stopAnimationCompletionHandler = nil
        completion()
      }
    } else {
      self.beginRotationAnimation()
    }
  }
}
