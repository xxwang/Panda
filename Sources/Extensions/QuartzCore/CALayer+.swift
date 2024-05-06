
import QuartzCore
import UIKit

public extension CALayer {
    func pd_image() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func pd_image(scale: CGFloat = 0.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, scale)
        defer { UIGraphicsEndImageContext() }
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        render(in: ctx)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func pd_uiColor() -> UIColor? {
        if let image = self.pd_image() {
            return UIColor(patternImage: image)
        }
        return nil
    }
}

public extension CALayer {
    func pd_basicAnimationMovePoint(_ point: CGPoint,
                                    duration: TimeInterval,
                                    delay: TimeInterval = 0,
                                    repeatCount: Float = 1,
                                    removedOnCompletion: Bool = false,
                                    option: CAMediaTimingFunctionName = .default)
    {
        self.pd_baseBasicAnimation(
            keyPath: "position",
            startValue: position,
            endValue: point,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    func pd_basicAnimationMoveX(_ moveValue: Any?,
                                duration: TimeInterval = 2.0,
                                delay: TimeInterval = 0,
                                repeatCount: Float = 1,
                                removedOnCompletion: Bool = false,
                                option: CAMediaTimingFunctionName = .default)
    {
        self.pd_baseBasicAnimation(
            keyPath: "transform.translation.x",
            startValue: position,
            endValue: moveValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    func pd_basicAnimationMoveY(_ moveValue: Any?,
                                duration: TimeInterval = 2.0,
                                delay: TimeInterval = 0,
                                repeatCount: Float = 1,
                                removedOnCompletion: Bool = false,
                                option: CAMediaTimingFunctionName = .default)
    {
        self.pd_baseBasicAnimation(
            keyPath: "transform.translation.y",
            startValue: position,
            endValue: moveValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    func pd_animationCornerRadius(_ cornerRadius: Any?,
                                  duration: TimeInterval = 2.0,
                                  delay: TimeInterval = 0,
                                  repeatCount: Float = 1,
                                  removedOnCompletion: Bool = false,
                                  option: CAMediaTimingFunctionName = .default)
    {
        self.pd_baseBasicAnimation(
            keyPath: "cornerRadius",
            startValue: position,
            endValue: cornerRadius,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    func pd_animationScale(_ scaleValue: Any?,
                           duration: TimeInterval = 2.0,
                           delay: TimeInterval = 0,
                           repeatCount: Float = 1,
                           removedOnCompletion: Bool = true,
                           option: CAMediaTimingFunctionName = .default)
    {
        self.pd_baseBasicAnimation(
            keyPath: "transform.scale",
            startValue: 1,
            endValue: scaleValue,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    func pd_animationRotation(_ rotation: Any?,
                              duration: TimeInterval = 2.0,
                              delay: TimeInterval = 0,
                              repeatCount: Float = 1,
                              removedOnCompletion: Bool = true,
                              option: CAMediaTimingFunctionName = .default)
    {
        self.pd_baseBasicAnimation(
            keyPath: "transform.rotation",
            startValue: nil,
            endValue: rotation,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    func pd_baseBasicAnimation(keyPath: String,
                               startValue: Any?,
                               endValue: Any?,
                               duration: TimeInterval = 2.0,
                               delay: TimeInterval = 0,
                               repeatCount: Float = 1,
                               removedOnCompletion: Bool = false,
                               option: CAMediaTimingFunctionName = .default)
    {
        let basicAnimation = CABasicAnimation()

        basicAnimation.beginTime = CACurrentMediaTime() + delay

        basicAnimation.keyPath = keyPath

        basicAnimation.fromValue = startValue

        basicAnimation.toValue = endValue

        basicAnimation.repeatCount = repeatCount

        basicAnimation.duration = duration

        basicAnimation.isRemovedOnCompletion = removedOnCompletion

        basicAnimation.fillMode = .forwards

        basicAnimation.timingFunction = CAMediaTimingFunction(name: option)

        add(basicAnimation, forKey: nil)
    }
}

public extension CALayer {
    func pd_addKeyframeAnimationPosition(_ values: [Any],
                                         keyTimes: [NSNumber]?,
                                         duration: TimeInterval = 2.0,
                                         delay: TimeInterval = 0,
                                         repeatCount: Float = 1,
                                         removedOnCompletion: Bool = false,
                                         option: CAMediaTimingFunctionName = .default)
    {
        self.pd_baseKeyframeAnimation(
            keyPath: "position",
            values: values,
            keyTimes: keyTimes,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: nil,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    func pd_addKeyframeAnimationRotation(_ values: [Any] = [
        -5.pd_cgFloat().pd_radians(),
        5.pd_cgFloat().pd_radians(),
        -5.pd_cgFloat().pd_radians(),
    ],
    keyTimes: [NSNumber]?,
    duration: TimeInterval = 1.0,
    delay: TimeInterval = 0,
    repeatCount: Float = 1,
    removedOnCompletion: Bool = true,
    option: CAMediaTimingFunctionName = .default) {
        self.pd_baseKeyframeAnimation(
            keyPath: "transform.rotation",
            values: values,
            keyTimes: keyTimes,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: nil,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    func pd_addKeyframeAnimationPositionBezierPath(_ path: CGPath? = nil,
                                                   duration: TimeInterval = 2.0,
                                                   delay: TimeInterval = 0,
                                                   repeatCount: Float = 1,
                                                   removedOnCompletion: Bool = false,
                                                   option: CAMediaTimingFunctionName = .default)
    {
        self.pd_baseKeyframeAnimation(
            keyPath: "position",
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: path,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    func pd_baseKeyframeAnimation(keyPath: String,
                                  values: [Any]? = nil,
                                  keyTimes: [NSNumber]? = nil,
                                  duration: TimeInterval = 2.0,
                                  delay: TimeInterval = 0,
                                  repeatCount: Float = 1,
                                  path: CGPath? = nil,
                                  removedOnCompletion: Bool = false,
                                  option: CAMediaTimingFunctionName = .default)
    {
        let keyframeAnimation = CAKeyframeAnimation(keyPath: keyPath)

        keyframeAnimation.duration = duration

        keyframeAnimation.beginTime = CACurrentMediaTime() + delay

        keyframeAnimation.isRemovedOnCompletion = removedOnCompletion

        keyframeAnimation.fillMode = .forwards

        keyframeAnimation.repeatCount = repeatCount

        keyframeAnimation.rotationMode = .rotateAuto

        keyframeAnimation.timingFunction = CAMediaTimingFunction(name: option)

        if let values {
            keyframeAnimation.values = values
        }

        if let keyTimes {
            keyframeAnimation.keyTimes = keyTimes
        }

        if let path {
            keyframeAnimation.path = path
            keyframeAnimation.calculationMode = .cubicPaced
        }

        add(keyframeAnimation, forKey: nil)
    }
}

public extension CALayer {
    func pd_addSpringAnimationBounds(_ toValue: Any?,
                                     delay: TimeInterval = 0,
                                     mass: CGFloat = 10.0,
                                     stiffness: CGFloat = 5000,
                                     damping: CGFloat = 100.0,
                                     initialVelocity: CGFloat = 5,
                                     repeatCount: Float = 1,
                                     removedOnCompletion: Bool = false,
                                     option: CAMediaTimingFunctionName = .default)
    {
        self.pd_baseSpringAnimation(
            path: "bounds",
            toValue: toValue,
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            option: option
        )
    }

    func pd_baseSpringAnimation(path: String?,
                                toValue: Any? = nil,
                                delay: TimeInterval = 0,
                                mass: CGFloat = 10.0,
                                stiffness: CGFloat = 5000,
                                damping: CGFloat = 100.0,
                                initialVelocity: CGFloat = 5,
                                repeatCount: Float = 1,
                                removedOnCompletion: Bool = false,
                                option: CAMediaTimingFunctionName = .default)
    {
        let springAnimation = CASpringAnimation(keyPath: path)
        springAnimation.beginTime = CACurrentMediaTime() + delay
        springAnimation.mass = mass
        springAnimation.stiffness = stiffness
        springAnimation.damping = damping
        springAnimation.initialVelocity = initialVelocity
        springAnimation.duration = springAnimation.settlingDuration
        springAnimation.toValue = toValue
        springAnimation.isRemovedOnCompletion = removedOnCompletion
        springAnimation.fillMode = CAMediaTimingFillMode.forwards
        springAnimation.timingFunction = CAMediaTimingFunction(name: option)
        add(springAnimation, forKey: nil)
    }
}

public extension CALayer {
    func pd_baseAnimationGroup(animations: [CAAnimation]? = nil,
                               duration: TimeInterval = 2.0,
                               delay: TimeInterval = 0,
                               repeatCount: Float = 1,
                               removedOnCompletion: Bool = false,
                               option: CAMediaTimingFunctionName = .default)
    {
        let animationGroup = CAAnimationGroup()
        animationGroup.beginTime = CACurrentMediaTime() + delay
        animationGroup.animations = animations
        animationGroup.duration = duration
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = removedOnCompletion
        animationGroup.timingFunction = CAMediaTimingFunction(name: option)
        add(animationGroup, forKey: nil)
    }
}

public extension CALayer {
    func pd_addTransition(_ type: CATransitionType,
                          subtype: CATransitionSubtype?,
                          duration: CFTimeInterval = 2.0,
                          delay: TimeInterval = 0)
    {
        let transition = CATransition()
        transition.beginTime = CACurrentMediaTime() + delay
        transition.type = type
        transition.subtype = subtype
        transition.duration = duration
        self.add(transition, forKey: nil)
    }
}

extension CALayer: Defaultable {}
extension CALayer {
    public typealias Associatedtype = CALayer

    @objc open class func `default`() -> Associatedtype {
        let layer = CALayer()
        return layer
    }
}

public extension CALayer {
    @discardableResult
    func pd_add2(_ superView: UIView) -> Self {
        superView.layer.addSublayer(self)
        return self
    }

    @discardableResult
    func pd_add2(_ superLayer: CALayer) -> Self {
        superLayer.addSublayer(self)
        return self
    }

    @discardableResult
    func pd_frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    @discardableResult
    func pd_backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color.cgColor
        return self
    }

    @discardableResult
    func pd_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    @discardableResult
    func pd_borderWidth(_ width: CGFloat) -> Self {
        borderWidth = width
        return self
    }

    @discardableResult
    func pd_borderColor(_ color: UIColor) -> Self {
        borderColor = color.cgColor
        return self
    }

    @discardableResult
    func pd_shouldRasterize(_ rasterize: Bool) -> Self {
        shouldRasterize = rasterize
        return self
    }

    @discardableResult
    func pd_rasterizationScale(_ scale: CGFloat) -> Self {
        rasterizationScale = scale
        return self
    }

    @discardableResult
    func pd_shadowColor(_ color: UIColor) -> Self {
        shadowColor = color.cgColor
        return self
    }

    @discardableResult
    func pd_shadowOpacity(_ opacity: Float) -> Self {
        shadowOpacity = opacity
        return self
    }

    @discardableResult
    func pd_shadowOffset(_ offset: CGSize) -> Self {
        shadowOffset = offset
        return self
    }

    @discardableResult
    func pd_shadowRadius(_ radius: CGFloat) -> Self {
        shadowRadius = radius
        return self
    }

    @discardableResult
    func pd_shadowPath(_ path: CGPath) -> Self {
        shadowPath = path
        return self
    }

    @discardableResult
    func pd_masksToBounds(_ masksToBounds: Bool = true) -> Self {
        self.masksToBounds = masksToBounds
        return self
    }

    @discardableResult
    func pd_cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        return self
    }

    @discardableResult
    func pd_corner(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> Self {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        mask = maskLayer

        return self
    }
}
