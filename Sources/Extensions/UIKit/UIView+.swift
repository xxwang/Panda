
import UIKit
import WebKit

public extension UIView {
    var xx_writeDirection: UIUserInterfaceLayoutDirection {
        if #available(iOS 10.0, macCatalyst 13.0, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection
        } else { return .leftToRight }
    }

    var xx_controller: UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil
        return nil
    }

    var xx_allSubViews: [UIView] {
        var subViews = [UIView]()
        for subView in subviews {
            subViews.append(subView)
            if !subView.subviews.isEmpty { subViews += subView.xx_allSubViews }
        }
        return subViews
    }
}

public extension UIView {
    enum AngleUnit {
        case degrees
        case radians
    }

    func xx_rotate(byAngle angle: CGFloat,
                   ofType type: AngleUnit,
                   animated: Bool = false,
                   duration: TimeInterval = 1,
                   completion: ((Bool) -> Void)? = nil)
    {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () in
            self.transform = self.transform.rotated(by: angleWithType)
        }, completion: completion)
    }

    func xx_rotate(toAngle angle: CGFloat,
                   ofType type: AngleUnit,
                   animated: Bool = false,
                   duration: TimeInterval = 1,
                   completion: ((Bool) -> Void)? = nil)
    {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, animations: {
            self.transform = self.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
        }, completion: completion)
    }

    func xx_scale(by offset: CGPoint,
                  animated: Bool = false,
                  duration: TimeInterval = 1,
                  completion: ((Bool) -> Void)? = nil)
    {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () in
                self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
            }, completion: completion)
        } else {
            transform = transform.scaledBy(x: offset.x, y: offset.y)
            completion?(true)
        }
    }

    func xx_setRotation(_ angle: CGFloat, isInverted: Bool = false) {
        transform = isInverted
            ? CGAffineTransform(rotationAngle: angle).inverted()
            : CGAffineTransform(rotationAngle: angle)
    }

    func xx_set3DRotationX(_ angle: CGFloat) {
        layer.transform = CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0)
    }

    func xx_set3DRotationY(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0)
        layer.transform = transform
    }

    func xx_set3DRotationZ(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 0.0, 1.0)
        layer.transform = transform
    }

    func xx_setRotation(xAngle: CGFloat, yAngle: CGFloat, zAngle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, xAngle, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, yAngle, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, zAngle, 0.0, 0.0, 1.0)
        layer.transform = transform
    }

    func xx_setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        layer.transform = transform
    }
}

public extension UIView {
    var xx_widthConstraint: NSLayoutConstraint? {
        xx_findConstraint(attribute: .width, for: self)
    }

    var xx_heightConstraint: NSLayoutConstraint? {
        xx_findConstraint(attribute: .height, for: self)
    }

    var xx_leadingConstraint: NSLayoutConstraint? {
        xx_findConstraint(attribute: .leading, for: self)
    }

    var xx_trailingConstraint: NSLayoutConstraint? {
        xx_findConstraint(attribute: .trailing, for: self)
    }

    var xx_topConstraint: NSLayoutConstraint? {
        xx_findConstraint(attribute: .top, for: self)
    }

    var xx_bottomConstraint: NSLayoutConstraint? {
        xx_findConstraint(attribute: .bottom, for: self)
    }

    func xx_findConstraint(attribute: NSLayoutConstraint.Attribute, for view: UIView) -> NSLayoutConstraint? {
        let constraint = constraints.first {
            ($0.firstAttribute == attribute && $0.firstItem as? UIView == view) ||
                ($0.secondAttribute == attribute && $0.secondItem as? UIView == view)
        }
        return constraint ?? superview?.xx_findConstraint(attribute: attribute, for: view)
    }

    func xx_addConstraints(withFormat: String, views: UIView...) {
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: withFormat,
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: viewsDictionary
        ))
    }

    func xx_fillToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor)
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor)
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }

    func xx_anchorCenterSuperview() {
        xx_anchorCenterXToSuperview()
        xx_anchorCenterYToSuperview()
    }

    func xx_anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    func xx_anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    @discardableResult
    func xx_anchor(top: NSLayoutYAxisAnchor? = nil,
                   left: NSLayoutXAxisAnchor? = nil,
                   bottom: NSLayoutYAxisAnchor? = nil,
                   right: NSLayoutXAxisAnchor? = nil,
                   topConstant: CGFloat = 0,
                   leftConstant: CGFloat = 0,
                   bottomConstant: CGFloat = 0,
                   rightConstant: CGFloat = 0,
                   widthConstant: CGFloat = 0,
                   heightConstant: CGFloat = 0) -> [NSLayoutConstraint]
    {
        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()

        if let top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }

        if let left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }

        if let bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }

        if let right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }

        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }

        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }

        anchors.forEach { $0.isActive = true }

        return anchors
    }
}

public extension UIView {

    func xx_roundCorners(radius: CGFloat, corners: UIRectCorner) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

public extension UIView {

    func xx_addShadow(
        ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    func xx_addCornerAndShadow(superview: UIView,
                               corners: UIRectCorner,
                               radius: CGFloat = 3,
                               shadowColor: UIColor,
                               shadowOffset: CGSize,
                               shadowOpacity: Float,
                               shadowRadius: CGFloat = 3)
    {
        xx_roundCorners(radius: radius, corners: corners)
        let subLayer = CALayer()
        let fixframe = frame
        subLayer.frame = fixframe
        subLayer.cornerRadius = shadowRadius
        subLayer.backgroundColor = shadowColor.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor
        subLayer.shadowOffset = shadowOffset
        subLayer.shadowOpacity = shadowOpacity
        subLayer.shadowRadius = shadowRadius
        superview.layer.insertSublayer(subLayer, below: layer)
    }

    func xx_addInnerShadowLayer(shadowColor: UIColor,
                                shadowOffset: CGSize = CGSize(width: 0, height: 0),
                                shadowOpacity: Float = 0.5, shadowRadius: CGFloat = 3,
                                insetBySize: CGSize = CGSize(width: -42, height: -42))
    {
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.fillRule = .evenOdd
        let path = CGMutablePath()
        path.addRect(bounds.insetBy(dx: insetBySize.width, dy: insetBySize.height))

        let someInnerPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowRadius).cgPath
        path.addPath(someInnerPath)
        path.closeSubpath()
        shadowLayer.path = path
        let maskLayer = CAShapeLayer()
        maskLayer.path = someInnerPath
        shadowLayer.mask = maskLayer
        layer.addSublayer(shadowLayer)
    }
}


public extension UIView {

    func xx_addBorder(borderWidth: CGFloat, borderColor: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }

    func xx_addBorderTop(borderWidth: CGFloat, borderColor: UIColor) {
        xx_addBorderUtility(x: 0, y: 0, width: frame.width, height: borderWidth, color: borderColor)
    }

    func xx_addBorderBottom(borderWidth: CGFloat, borderColor: UIColor) {
        xx_addBorderUtility(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth, color: borderColor)
    }

    func xx_addBorderLeft(borderWidth: CGFloat, borderColor: UIColor) {
        xx_addBorderUtility(x: 0, y: 0, width: borderWidth, height: frame.height, color: borderColor)
    }

    func xx_addBorderRight(borderWidth: CGFloat, borderColor: UIColor) {
        xx_addBorderUtility(x: frame.width - borderWidth, y: 0, width: borderWidth, height: frame.height, color: borderColor)
    }

    private func xx_addBorderUtility(x: CGFloat,
                                     y: CGFloat,
                                     width: CGFloat,
                                     height: CGFloat,
                                     color: UIColor)
    {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }

    func xx_drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
        let ciecleRadius = bounds.width > bounds.height
            ? bounds.height
            : bounds.width
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: ciecleRadius, height: ciecleRadius), cornerRadius: ciecleRadius / 2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        layer.addSublayer(shapeLayer)
    }

    func xx_drawDashLine(strokeColor: UIColor, lineLength: Int = 4, lineSpacing: Int = 4, isHorizontal: Bool = true) {

        let lineWidth = isHorizontal ? bounds.height : bounds.width

        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor

        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0

        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]

        let path = CGMutablePath()
        if isHorizontal {
            path.move(to: CGPoint(x: 0, y: lineWidth / 2))

            path.addLine(to: CGPoint(x: bounds.width, y: lineWidth / 2))
        } else {
            path.move(to: CGPoint(x: lineWidth / 2, y: 0))

            path.addLine(to: CGPoint(x: lineWidth / 2, y: bounds.height))
        }
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }

    @discardableResult
    func xx_drawDashLineBorder(lineWidth: CGFloat, lineColor: UIColor, lineLen: CGFloat, lineSpacing: CGFloat, radius: CGFloat) -> Self {
        let frame = self.bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)

        let borderPath = UIBezierPath(roundedRect: frame, cornerRadius: radius).cgPath
        let borderLayer = CAShapeLayer.default()
            .xx_frame(frame)
            .xx_lineWidth(lineWidth)
            .xx_strokeColor(lineColor)
            .xx_fillColor(.clear)
            .xx_lineDashPattern([lineLen.xx_nsNumber(), lineSpacing.xx_nsNumber()])
            .xx_path(borderPath)
            .xx_cornerRadius(10)
        self.layer.addSublayer(borderLayer)
        return self
    }
}

public extension UIView {

    func xx_setLinearGradientBorder(_ size: CGSize,
                                    colors: [UIColor],
                                    locations: [CGFloat] = [0, 1],
                                    start: CGPoint,
                                    end: CGPoint,
                                    borderWidth: CGFloat = 1.0,
                                    roundingCorners: UIRectCorner = .allCorners,
                                    cornerRadii: CGFloat = 0)
    {
        let gradientLayer = colors.xx_createLinearGradientLayer(size,
                                                                locations: locations,
                                                                start: start,
                                                                end: end)

        let maskLayer = CAShapeLayer.default()
            .xx_lineWidth(borderWidth)
            .xx_path(UIBezierPath(
                roundedRect: gradientLayer.bounds,
                byRoundingCorners: roundingCorners,
                cornerRadii: CGSize(width: cornerRadii, height: cornerRadii)
            ).cgPath)
            .xx_fillColor(.clear)
            .xx_strokeColor(.black)

        gradientLayer.mask = maskLayer
        layer.addSublayer(gradientLayer)
    }

    func xx_setLinearGradientBackgroundLayer(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             start: CGPoint,
                                             end: CGPoint)
    {
        let gradientLayer = colors.xx_createLinearGradientLayer(size,
                                                                locations: locations,
                                                                start: start,
                                                                end: end)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func xx_setLinearGradientBackgroundColor(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             start: CGPoint,
                                             end: CGPoint)
    {
        let gradientColor = colors.xx_createLinearGradientColor(size,
                                                                locations: locations,
                                                                start: start,
                                                                end: end)
        backgroundColor = gradientColor
    }

    func xx_linearGradientColorAnimation(_ size: CGSize,
                                         startColors: [UIColor],
                                         endColors: [UIColor],
                                         locations: [CGFloat],
                                         start: CGPoint,
                                         end: CGPoint,
                                         duration: CFTimeInterval = 1.0)
    {
        let gradientLayer = startColors.xx_createLinearGradientLayer(size,
                                                                     locations: locations,
                                                                     start: start,
                                                                     end: end)
        layer.insertSublayer(gradientLayer, at: 0)

        xx_startLinearGradientColorAnimation(
            gradientLayer,
            startColors: startColors,
            endColors: endColors,
            duration: duration
        )
    }

    private func xx_startLinearGradientColorAnimation(_ gradientLayer: CAGradientLayer,
                                                      startColors: [UIColor],
                                                      endColors: [UIColor],
                                                      duration: CFTimeInterval = 1.0)
    {
        let startColorArr = startColors.map(\.cgColor)
        let endColorArr = endColors.map(\.cgColor)

        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.duration = duration
        colorChangeAnimation.fromValue = startColorArr
        colorChangeAnimation.toValue = endColorArr
        colorChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
    }
}

public extension UIView {

    final func xx_startWaterWaveAnimation(colors: [UIColor],
                                          scale: CGFloat,
                                          duration: TimeInterval)
    {
        if superview?.viewWithTag(3257) != nil { return }

        let animationView = UIView(frame: frame)
        animationView.tag = 3257
        animationView.layer.cornerRadius = layer.cornerRadius
        superview?.insertSubview(animationView, belowSubview: self)

        let delay = Double(duration) / Double(colors.count)
        for (index, color) in colors.enumerated() {
            let delay = delay * Double(index)
            xx_setupAnimationView(animationView: animationView, color: color, scale: scale, delay: delay, duration: duration)
        }
    }

    private func xx_setupAnimationView(animationView: UIView,
                                       color: UIColor,
                                       scale: CGFloat,
                                       delay: CFTimeInterval,
                                       duration: TimeInterval)
    {
        let waveView = UIView(frame: animationView.bounds)
        waveView.backgroundColor = color
        waveView.layer.cornerRadius = animationView.layer.cornerRadius
        waveView.layer.masksToBounds = true
        animationView.addSubview(waveView)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = duration
            opacityAnimation.repeatCount = MAXFLOAT
            waveView.layer.add(opacityAnimation, forKey: "opacityAnimation")

            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = scale
            scaleAnimation.duration = duration
            scaleAnimation.repeatCount = MAXFLOAT
            waveView.layer.add(scaleAnimation, forKey: "scaleAnimation")
        }
    }

    final func xx_stopWaterWaveAnimation() {
        if let view = superview?.viewWithTag(3257) {
            view.removeFromSuperview()
        }
    }
}

public extension UIView {

    func xx_setupBadge(_ number: String) {
        var badgeLabel: UILabel? = viewWithTag(6202) as? UILabel
        if number == "0" {
            xx_removeBadege()
            return
        }

        if badgeLabel == nil {
            badgeLabel = UILabel.default()
                .xx_text(number)
                .xx_textColor("#FFFFFF".xx_hexColor())
                .xx_backgroundColor("#EE0565".xx_hexColor())
                .xx_font(.system(.regular, size: 10))
                .xx_textAlignment(.center)
                .xx_tag(6202)
                .xx_add2(self)
        }

        badgeLabel?
            .xx_text((number.xx_int()) > 99 ? "99+" : number)
            .xx_cornerRadius(2.5)
            .xx_masksToBounds(true)

        badgeLabel?.translatesAutoresizingMaskIntoConstraints = false
        if number.isEmpty {
            let widthCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .width,
                multiplier: 1,
                constant: 5
            )

            let heightCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .height,
                multiplier: 1,
                constant: 5
            )

            let centerXCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .right,
                multiplier: 1,
                constant: 0
            )
            let centerYCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: 0
            )
            addConstraints([widthCons, heightCons, centerXCons, centerYCons])
        } else {
            var textWidth = (badgeLabel?.xx_textSize().width ?? 0) + 10
            textWidth = max(textWidth, 16)

            let widthCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .width,
                multiplier: 1,
                constant: textWidth
            )

            let heightCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .height,
                multiplier: 1,
                constant: 16
            )

            let centerXCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .right,
                multiplier: 1,
                constant: 0
            )

            let centerYCons = NSLayoutConstraint(
                item: badgeLabel!,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: 0
            )
            addConstraints([widthCons, heightCons, centerXCons, centerYCons])
        }
    }

    func xx_removeBadege() {
        DispatchQueue.xx_async_execute_on_main {
            let badge = self.viewWithTag(6202)
            badge?.removeFromSuperview()
        }
    }
}

public extension UIView {

    func xx_addWatermark(
        _ text: String,
        textColor: UIColor = UIColor.black,
        font: UIFont = UIFont.systemFont(ofSize: 12)
    ) {

        let waterMark = text.xx_nsString()
        let textSize = waterMark.size(withAttributes: [NSAttributedString.Key.font: font])
        let rowNum = NSInteger(bounds.height * 3.5 / 80)
        let colNum = NSInteger(bounds.width / text.xx_stringSize(bounds.width, font: font).width)

        for i in 0 ..< rowNum {
            for j in 0 ..< colNum {
                let textLayer: CATextLayer = .init()
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = font
                textLayer.fontSize = font.pointSize
                textLayer.foregroundColor = textColor.cgColor
                textLayer.string = waterMark
                textLayer.frame = CGRect(x: CGFloat(j) * (textSize.width + 30), y: CGFloat(i) * 60, width: textSize.width, height: textSize.height)
                textLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi * 0.2), 0, 0, 3)
                layer.addSublayer(textLayer)
            }
        }
    }
}

public extension UIView {
    enum ShakeDirection {
        case horizontal
        case vertical
    }

    enum ShakeAnimation {
        case linear
        case easeIn
        case easeOut
        case easeInOut
    }

    func xx_shake(shakeDirection: ShakeDirection = .horizontal,
                  shakeAnimation: ShakeAnimation = .easeOut,
                  duration: TimeInterval = 1,
                  completion: (() -> Void)? = nil)
    {
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch shakeDirection {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }

        switch shakeAnimation {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
}

public extension UIView {

    func xx_addGestureRecognizers(_ recognizers: [UIGestureRecognizer]) {
        isUserInteractionEnabled = true
        for recognizer in recognizers {
            addGestureRecognizer(recognizer)
        }
    }

    func xx_removeGestureRecognizers(_ recognizers: [UIGestureRecognizer]) {
        for recognizer in recognizers {
            removeGestureRecognizer(recognizer)
        }
    }

    func xx_removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }

    @discardableResult
    func xx_addTapGestureRecognizer(
        _ action: @escaping (_ recognizer: UITapGestureRecognizer) -> Void
    ) -> UITapGestureRecognizer {
        let obj = UITapGestureRecognizer(target: nil, action: nil)
        obj.numberOfTapsRequired = 1
        obj.numberOfTouchesRequired = 1
        xx_addCommonGestureRecognizer(obj)

        obj.xx_callback { recognizer in
            if let recognizer = recognizer as? UITapGestureRecognizer {
                action(recognizer)
            }
        }

        return obj
    }

    @discardableResult
    func xx_addLongPressGestureRecognizer(
        _ action: @escaping (_ recognizer: UILongPressGestureRecognizer) -> Void,
        for minimumPressDuration: TimeInterval
    ) -> UILongPressGestureRecognizer {
        let obj = UILongPressGestureRecognizer(target: nil, action: nil)
        obj.minimumPressDuration = minimumPressDuration
        xx_addCommonGestureRecognizer(obj)

        obj.xx_callback { recognizer in
            if let recognizer = recognizer as? UILongPressGestureRecognizer {
                action(recognizer)
            }
        }
        return obj
    }

    @discardableResult
    func xx_addPanGestureRecognizer(
        _ action: @escaping (_ recognizer: UIPanGestureRecognizer) -> Void
    ) -> UIPanGestureRecognizer {
        let obj = UIPanGestureRecognizer(target: nil, action: nil)
        obj.minimumNumberOfTouches = 1
        obj.maximumNumberOfTouches = 3
        xx_addCommonGestureRecognizer(obj)

        obj.xx_callback { recognizer in
            if let recognizer = recognizer as? UIPanGestureRecognizer,
               let senderView = recognizer.view
            {
                let translate: CGPoint = recognizer.translation(in: senderView.superview)
                senderView.center = CGPoint(x: senderView.center.x + translate.x, y: senderView.center.y + translate.y)
                recognizer.setTranslation(.zero, in: senderView.superview)
                action(recognizer)
            }
        }
        return obj
    }

    @discardableResult
    func xx_addScreenEdgePanGestureRecognizer(
        _ target: Any?,
        action: Selector?,
        for edgs: UIRectEdge
    ) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: target, action: action)
        obj.edges = edgs
        xx_addCommonGestureRecognizer(obj)
        return obj
    }

    @discardableResult
    func xx_addScreenEdgePanGestureRecognizer(
        action: @escaping (_ recognizer: UIScreenEdgePanGestureRecognizer) -> Void,
        for edge: UIRectEdge
    ) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: nil, action: nil)
        obj.edges = edge
        xx_addCommonGestureRecognizer(obj)
        obj.xx_callback { recognizer in
            if let recognizer = recognizer as? UIScreenEdgePanGestureRecognizer {
                action(recognizer)
            }
        }
        return obj
    }

    @discardableResult
    func xx_addSwipeGestureRecognizer(
        _ target: Any?,
        action: Selector?,
        for direction: UISwipeGestureRecognizer.Direction
    ) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: target, action: action)
        obj.direction = direction
        xx_addCommonGestureRecognizer(obj)
        return obj
    }

    func xx_addSwipeGestureRecognizer(
        _ action: @escaping (_ recognizer: UISwipeGestureRecognizer) -> Void,
        for direction: UISwipeGestureRecognizer.Direction
    ) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: nil, action: nil)
        obj.direction = direction
        xx_addCommonGestureRecognizer(obj)
        obj.xx_callback { recognizer in
            if let recognizer = recognizer as? UISwipeGestureRecognizer {
                action(recognizer)
            }
        }
        return obj
    }

    func xx_addPinchGestureRecognizer(_ action: @escaping (_ recognizer: UIPinchGestureRecognizer) -> Void) -> UIPinchGestureRecognizer {
        let obj = UIPinchGestureRecognizer(target: nil, action: nil)
        xx_addCommonGestureRecognizer(obj)
        obj.xx_callback { recognizer in
            if let recognizer = recognizer as? UIPinchGestureRecognizer {
                let location = recognizer.location(in: recognizer.view!.superview)
                recognizer.view!.center = location
                recognizer.view!.transform = recognizer.view!.transform.scaledBy(
                    x: recognizer.scale,
                    y: recognizer.scale
                )
                recognizer.scale = 1.0
                action(recognizer)
            }
        }
        return obj
    }

    @discardableResult
    func xx_addRotationGestureRecognizer(
        _ action: @escaping (_ recognizer: UIRotationGestureRecognizer) -> Void
    ) -> UIRotationGestureRecognizer {
        let obj = UIRotationGestureRecognizer(target: nil, action: nil)
        xx_addCommonGestureRecognizer(obj)
        obj.xx_callback { recognizer in
            if let recognizer = recognizer as? UIRotationGestureRecognizer {
                recognizer.view!.transform = recognizer.view!.transform.rotated(by: recognizer.rotation)
                recognizer.rotation = 0.0
                action(recognizer)
            }
        }
        return obj
    }

    private func xx_addCommonGestureRecognizer(_ recognizer: UIGestureRecognizer) {
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(recognizer)
    }
}

public extension UIView {
    class EmitterStyle: NSObject {
        public var preservesDepth: Bool = true
        public var emitterPosition: CGPoint = .init(x: UIScreen.main.bounds.width / 2.0, y: UIScreen.main.bounds.height - 30)
        public var emitterShape: CAEmitterLayerEmitterShape = .sphere

        public var cellScale: CGFloat = 0.7
        public var cellScaleRange: CGFloat = 0.3
        public var cellEmitterLifetime: Float = 3
        public var cellLifetimeRange: Float = 3
        public var cellEmitterBirthRate: Float = 10
        public var cellColor: UIColor = .white
        public var cellSpin: CGFloat = .init(Double.pi / 2)
        public var cellSpinRange: CGFloat = .init(Double.pi / 4)
        public var cellVelocity: CGFloat = 150
        public var cellVelocityRange: CGFloat = 100
        public var cellEmissionLongitude: CGFloat = .init(-Double.pi / 2)
        public var cellEmissionRange: CGFloat = .init(Double.pi / 5)
        public var cellFireOnce: Bool = false
    }

    @discardableResult
    func xx_startEmitter(emitterImageNames: [String], style: EmitterStyle = EmitterStyle()) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.backgroundColor = UIColor.brown.cgColor
        emitter.emitterPosition = style.emitterPosition
        emitter.preservesDepth = style.preservesDepth
        let cells = xx_createEmitterCell(emitterImageNames: emitterImageNames, style: style)
        emitter.emitterCells = cells
        layer.addSublayer(emitter)

        DispatchQueue.xx_delay_execute(delay: 1) {
            guard style.cellFireOnce else { return }
            emitter.birthRate = 0

            DispatchQueue.xx_delay_execute(delay: 1) {
                self.xx_stopEmitter()
            }
        }
        return emitter
    }

    func xx_stopEmitter() {
        _ = layer.sublayers?.filter {
            $0.isKind(of: CAEmitterLayer.self)
        }.map {
            $0.removeFromSuperlayer()
        }
    }

    private func xx_createEmitterCell(emitterImageNames: [String], style: EmitterStyle) -> [CAEmitterCell] {
        var cells: [CAEmitterCell] = []
        for emitterImageName in emitterImageNames {

            let cell = CAEmitterCell()
            cell.velocity = style.cellVelocity
            cell.velocityRange = style.cellVelocityRange
            cell.scale = style.cellScale
            cell.scaleRange = style.cellScaleRange
            cell.emissionLongitude = style.cellEmissionLongitude
            cell.emissionRange = style.cellEmissionRange
            cell.spin = style.cellSpin
            cell.spinRange = style.cellSpinRange
            cell.lifetime = style.cellEmitterLifetime
            cell.lifetimeRange = style.cellLifetimeRange
            cell.birthRate = style.cellEmitterBirthRate
            cell.contents = UIImage(named: emitterImageName)?.cgImage
            cell.color = style.cellColor.cgColor
            cells.append(cell)
        }
        return cells
    }
}

public extension UIView {

    func xx_findFirstResponder() -> UIView? {
        if isFirstResponder { return self }
        for subView in subviews {
            if let firstResponder = subView.xx_findFirstResponder() { return firstResponder }
        }
        return nil
    }

    func xx_contains(_ point: CGPoint) -> Bool {
        point.x > frame.minX && point.x < frame.maxX && point.y > frame.minY && point.y < frame.maxY
    }

    func xx_contains<T: UIView>(withClass name: T.Type) -> Bool {
        if isKind(of: T.self) { return true }
        for subView in subviews {
            if subView.xx_contains(withClass: T.self) { return true }
        }
        return false
    }

    func xx_findSuperview<T: UIView>(withClass name: T.Type) -> T? {
        xx_findSuperview(where: { $0 is T }) as? T
    }

    func xx_findSuperview(where predicate: (UIView?) -> Bool) -> UIView? {
        if predicate(superview) { return superview }
        return superview?.xx_findSuperview(where: predicate)
    }

    func xx_findSubview<T: UIView>(withClass name: T.Type) -> T? {
        xx_findSubview(where: { $0 is T }) as? T
    }

    func xx_findSubview(where predicate: (UIView?) -> Bool) -> UIView? {
        guard subviews.count > 0 else { return nil }
        for subView in subviews {
            if predicate(subView) { return subView }
            return subView.xx_findSubview(where: predicate)
        }
        return nil
    }

    func xx_findSubviews<T: UIView>(withClass name: T.Type) -> [T] {
        xx_findSubviews(where: { $0 is T }).map { view in view as! T }
    }

    func xx_findSubviews(where predicate: (UIView?) -> Bool) -> [UIView] {
        guard subviews.count > 0 else { return [] }

        var result: [UIView] = []
        for subView in subviews {
            if predicate(subView) { result.append(subView) }
            result += subView.xx_findSubviews(where: predicate)
        }
        return result
    }

    func xx_removeSubviews() { subviews.forEach { $0.removeFromSuperview() }}

    func xx_removeLayer() {
        layer.mask = nil
        layer.borderWidth = 0
    }

    func xx_hiddenKeyboard() { endEditing(true) }

    @discardableResult
    func xx_relayout() -> Self {
        setNeedsLayout()
        layoutIfNeeded()

        return self
    }
}

public extension UIView {

    func xx_stressView(_ borderWidth: CGFloat = 1, borderColor: UIColor = .xx_random, backgroundColor: UIColor = .xx_random) {
        guard environment.isDebug else { return }
        guard subviews.count > 0 else { return }

        for subview in subviews {
            subview.layer.borderWidth = borderWidth
            subview.layer.borderColor = borderColor.cgColor
            subview.backgroundColor = backgroundColor
            subview.xx_stressView(borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
        }
    }
}

public extension UIView {

    @objc func xx_captureScreenshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        layer.render(in: context)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return viewImage
    }
}

public extension UIView {

    class func xx_loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

    class func xx_loadFromNib<T: UIView>(withClass name: T.Type, bundle: Bundle? = nil) -> T {
        let named = String(describing: name)
        guard let view = UINib(nibName: named, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? T else {
            fatalError("First element in xib file \(named) is not of type \(named)")
        }
        return view
    }
}

public extension UIView {

    func xx_fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden { isHidden = false }
        UIView.animate(withDuration: duration, animations: { self.alpha = 1 }, completion: completion)
    }

    func xx_fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden { isHidden = false }
        UIView.animate(withDuration: duration, animations: { self.alpha = 0 }, completion: completion)
    }
}

public extension UIView {
    @available(iOS 12.0, *)
    static func xx_fitAllView(userInterfaceStyle: UIUserInterfaceStyle) {
        if #available(iOS 13.0, *) {
            UIView.appearance().overrideUserInterfaceStyle = .light
        }
    }
}

public extension UIView {

    var xx_frame: CGRect {
        get { frame }
        set { frame = newValue }
    }

    var xx_bounds: CGRect {
        get { bounds }
        set { frame = CGRect(origin: .zero, size: newValue.size) }
    }

    var xx_origin: CGPoint {
        get { frame.origin }
        set { frame = CGRect(origin: newValue, size: xx_size) }
    }

    var xx_x: CGFloat {
        get { frame.origin.x }
        set { frame = CGRect(origin: CGPoint(x: newValue, y: xx_origin.y), size: xx_size) }
    }

    var xx_y: CGFloat {
        get { frame.origin.y }
        set { frame = CGRect(origin: CGPoint(x: xx_origin.x, y: newValue), size: xx_size) }
    }

    var xx_maxX: CGFloat {
        get { frame.maxX }
        set { frame = CGRect(origin: CGPoint(x: newValue - xx_width, y: xx_y), size: xx_size) }
    }

    var xx_maxY: CGFloat {
        get { frame.maxY }
        set { frame = CGRect(origin: CGPoint(x: xx_x, y: newValue - xx_height), size: xx_size) }
    }

    var xx_size: CGSize {
        get { frame.size }
        set { frame = CGRect(origin: xx_origin, size: newValue) }
    }

    var xx_width: CGFloat {
        get { frame.width }
        set { frame = CGRect(origin: xx_origin, size: CGSize(width: newValue, height: xx_size.height)) }
    }

    var xx_height: CGFloat {
        get { frame.height }
        set { frame = CGRect(origin: xx_origin, size: CGSize(width: xx_size.width, height: newValue)) }
    }

    var xx_middle: CGPoint {
        CGPoint(x: xx_width / 2, y: xx_height / 2)
    }

    var xx_center: CGPoint {
        get { center }
        set { center = newValue }
    }

    var xx_centerX: CGFloat {
        get { xx_center.x }
        set { xx_center = CGPoint(x: newValue, y: xx_center.y) }
    }

    var xx_centerY: CGFloat {
        get { xx_center.y }
        set { xx_center = CGPoint(x: xx_center.x, y: newValue) }
    }
}

extension UIView: Defaultable {}
extension UIView {
    public typealias Associatedtype = UIView

    @objc open class func `default`() -> Associatedtype {
        let view = UIView()
        return view
    }
}

public extension UIView {

    @discardableResult
    func xx_frame(_ frame: CGRect) -> Self {
        xx_frame = frame
        return self
    }

    @discardableResult
    func xx_origin(_ origin: CGPoint) -> Self {
        xx_origin = origin
        return self
    }

    @discardableResult
    func xx_x(_ x: CGFloat) -> Self {
        xx_x = x
        return self
    }

    @discardableResult
    func xx_y(_ y: CGFloat) -> Self {
        xx_y = y
        return self
    }

    @discardableResult
    func xx_maxX(_ maxX: CGFloat) -> Self {
        xx_maxX = maxX
        return self
    }

    @discardableResult
    func xx_maxY(_ maxY: CGFloat) -> Self {
        xx_maxY = maxY
        return self
    }

    @discardableResult
    func xx_size(_ size: CGSize) -> Self {
        xx_size = size
        return self
    }

    @discardableResult
    func xx_width(_ width: CGFloat) -> Self {
        xx_width = width
        return self
    }

    @discardableResult
    func xx_height(_ height: CGFloat) -> Self {
        xx_height = height
        return self
    }

    @discardableResult
    func xx_center(_ center: CGPoint) -> Self {
        xx_center = center
        return self
    }

    @discardableResult
    func xx_centerX(_ centerX: CGFloat) -> Self {
        xx_centerX = centerX
        return self
    }

    @discardableResult
    func xx_centerY(_ centerY: CGFloat) -> Self {
        xx_centerY = centerY
        return self
    }
}

public extension UIView {
    @discardableResult
    func xx_add2(_ superview: UIView?) -> Self {
        if let superview {
            superview.addSubview(self)
        }
        return self
    }

    @discardableResult
    func xx_addSubviews(_ subviews: [UIView]) -> Self {
        subviews.forEach { addSubview($0) }
        return self
    }

    @discardableResult
    func xx_tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }

    @discardableResult
    func xx_cornerRadius(_ cornerRadius: CGFloat) -> Self {
        layer.cornerRadius = cornerRadius
        return self
    }

    @discardableResult
    func xx_masksToBounds(_ masksToBounds: Bool) -> Self {
        layer.masksToBounds = masksToBounds
        return self
    }

    @discardableResult
    func xx_clipsToBounds(_ clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }

    @discardableResult
    func xx_contentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }

    @discardableResult
    @objc func xx_backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }

    @discardableResult
    func xx_isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }

    @discardableResult
    func xx_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    @discardableResult
    func xx_alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    @discardableResult
    @objc func xx_tintColor(_ tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }

    @discardableResult
    func xx_borderColor(_ color: UIColor) -> Self {
        layer.borderColor = color.cgColor
        return self
    }

    @discardableResult
    func xx_borderWidth(_ width: CGFloat = 0.5) -> Self {
        layer.borderWidth = width
        return self
    }

    @discardableResult
    func xx_shouldRasterize(_ rasterize: Bool) -> Self {
        layer.shouldRasterize = rasterize
        return self
    }

    @discardableResult
    func xx_rasterizationScale(_ scale: CGFloat) -> Self {
        layer.rasterizationScale = scale
        return self
    }

    @discardableResult
    func xx_shadowColor(_ color: UIColor) -> Self {
        layer.shadowColor = color.cgColor
        return self
    }

    @discardableResult
    func xx_shadowOffset(_ offset: CGSize) -> Self {
        layer.shadowOffset = offset
        return self
    }

    @discardableResult
    func xx_shadowRadius(_ radius: CGFloat) -> Self {
        layer.shadowRadius = radius
        return self
    }

    @discardableResult
    func xx_shadowOpacity(_ opacity: Float) -> Self {
        layer.shadowOpacity = opacity
        return self
    }

    @discardableResult
    func xx_shadowPath(_ path: CGPath) -> Self {
        layer.shadowPath = path
        return self
    }

    @discardableResult
    func xx_addTapGesture(_ target: Any, _ selector: Selector) -> Self {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
        return self
    }

    @discardableResult
    func xx_rasterize() -> Self {
        layer.drawsAsynchronously = true
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        return self
    }
}
