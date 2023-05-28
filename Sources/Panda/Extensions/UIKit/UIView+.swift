//
//  UIView+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit
import WebKit

// MARK: - 属性
public extension UIView {
    /// 当前视图布局的书写方向
    var writeDirection: UIUserInterfaceLayoutDirection {
        if #available(iOS 10.0, macCatalyst 13.0, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection
        } else { return .leftToRight }
    }

    /// view所在控制器
    var controller: UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil
        return nil
    }

    /// 查找一个视图的所有子视图
    var allSubViews: [UIView] {
        var subViews = [UIView]()
        for subView in subviews {
            subViews.append(subView)
            if !subView.subviews.isEmpty { subViews += subView.allSubViews }
        }
        return subViews
    }

    /// view的边框颜色；可以从故事板上查看
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // 修复React-Native冲突问题
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// view的边框宽度；可以从故事板上查看
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    /// view的角半径；可以从故事板上查看
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }

    /// view的阴影颜色；可以从故事板上查看
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }

    /// view的阴影偏移；可以从故事板上查看
    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    /// view的阴影不透明度；可以从故事板上查看
    @IBInspectable var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    /// view阴影的半径；可以从故事板上查看
    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    /// 是否使用蒙版(范围为view.bounds); 可以从故事板上查看
    @IBInspectable var masksToBounds: Bool {
        get { layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
}

// MARK: - transform
public extension UIView {
    enum AngleUnit {
        /// 度
        case degrees
        /// 弧度
        case radians
    }

    /// 按相对轴上的角度旋转视图
    /// - Parameters:
    ///   - angle:旋转视图的角度
    ///   - type:旋转角度的类型
    ///   - animated:设置为true以设置旋转动画(默认值为true)
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func rotate(byAngle angle: CGFloat,
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

    /// 将视图旋转到固定轴上的角度
    /// - Parameters:
    ///   - angle:旋转视图的角度
    ///   - type:旋转角度的类型
    ///   - animated:设置为true以设置旋转动画(默认值为false)
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func rotate(toAngle angle: CGFloat,
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

    /// 按偏移缩放视图
    /// - Parameters:
    ///   - offset:缩放偏移
    ///   - animated:设置为true以设置缩放动画(默认值为false)
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func scale(by offset: CGPoint,
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

    /// 平面旋转
    /// - Parameters:
    ///   - angle:旋转多少度
    ///   - isInverted:顺时针还是逆时针,默认是顺时针
    func setRotation(_ angle: CGFloat, isInverted: Bool = false) {
        transform = isInverted
            ? CGAffineTransform(rotationAngle: angle).inverted()
            : CGAffineTransform(rotationAngle: angle)
    }

    /// 沿X轴方向旋转多少度(3D旋转)
    /// - Parameter angle:旋转角度,angle参数是旋转的角度,为弧度制 0-2π
    func set3DRotationX(_ angle: CGFloat) {
        // 初始化3D变换,获取默认值
        // var transform = CATransform3DIdentity
        // 透视 1/ -D,D越小,透视效果越明显,必须在有旋转效果的前提下,才会看到透视效果
        // 当我们有垂直于z轴的旋转分量时,设置m34的值可以增加透视效果,也可以理解为景深效果
        // transform.m34 = 1.0 / -1000.0
        // 空间旋转,x,y,z决定了旋转围绕的中轴,取值为 (-1,1) 之间
        // transform = CATransform3DRotate(transform, angle, 1.0, 0.0, 0.0)
        // self.layer.transform = transform
        layer.transform = CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0)
    }

    /// 沿Y轴方向旋转多少度
    /// - Parameter angle:旋转角度,angle参数是旋转的角度,为弧度制 0-2π
    func set3DRotationY(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0)
        layer.transform = transform
    }

    /// 沿Z轴方向旋转多少度
    /// - Parameter angle:旋转角度,angle参数是旋转的角度,为弧度制 0-2π
    func set3DRotationZ(_ angle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, angle, 0.0, 0.0, 1.0)
        layer.transform = transform
    }

    /// 沿 X、Y、Z轴方向同时旋转多少度(3D旋转)
    /// - Parameters:
    ///   - xAngle:x 轴的角度,旋转的角度,为弧度制 0-2π
    ///   - yAngle:y 轴的角度,旋转的角度,为弧度制 0-2π
    ///   - zAngle:z 轴的角度,旋转的角度,为弧度制 0-2π
    func setRotation(xAngle: CGFloat, yAngle: CGFloat, zAngle: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, xAngle, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, yAngle, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, zAngle, 0.0, 0.0, 1.0)
        layer.transform = transform
    }

    /// 设置x,y缩放
    /// - Parameters:
    ///   - x:x 放大的倍数
    ///   - y:y 放大的倍数
    func setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        layer.transform = transform
    }
}

// MARK: - 圆角
public extension UIView {
    /// 设置圆角(⚠️前提:需要`frame`已确定)
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 要设置的角
    func roundCorners(radius: CGFloat, corners: UIRectCorner) {
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

// MARK: - 阴影
public extension UIView {
    /// 将`阴影`添加到view上
    ///
    /// - Note:此方法仅适用于不透明的背景色,或者如果视图设置了`shadowPath`请参见参数`opacity`
    /// - Parameters:
    ///   - color: 阴影颜色(默认值为#137992)
    ///   - radius: 阴影半径(默认值为3)
    ///   - offset: 阴影偏移(默认为.zero)
    ///   - opacity: 阴影不透明度(默认值为0.5),它还将受到`alpha`和`backgroundColor`的影响
    func addShadow(
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

    /// 同时将`阴影`和`圆角`添加到view上(⚠️前提:需要`frame`已确定)
    ///
    /// - Note:提示:如果在异步布局(如:SnapKit布局)中使用,要在布局后先调用 layoutIfNeeded,再使用该方法
    /// - Parameters:
    ///   - superview: 父视图
    ///   - conrners: 具体哪个圆角
    ///   - radius: 圆角半径
    ///   - shadowColor: 阴影的颜色
    ///   - shadowOffset: 阴影的偏移度:CGSizeMake(X[正的右偏移,负的左偏移], Y[正的下偏移,负的上偏移])
    ///   - shadowOpacity: 阴影的透明度
    ///   - shadowRadius: 阴影半径,默认 3
    func addCornerAndShadow(superview: UIView,
                            conrners: UIRectCorner,
                            radius: CGFloat = 3,
                            shadowColor: UIColor,
                            shadowOffset: CGSize,
                            shadowOpacity: Float,
                            shadowRadius: CGFloat = 3)
    {
        // 添加圆角
        roundCorners(conrners, radius: radius)

        // 设置阴影
        let subLayer = CALayer()
        let fixframe = frame
        subLayer.frame = fixframe
        subLayer.cornerRadius = shadowRadius
        subLayer.backgroundColor = shadowColor.cgColor
        subLayer.masksToBounds = false
        // shadowColor阴影颜色
        subLayer.shadowColor = shadowColor.cgColor
        // shadowOffset阴影偏移,x向右偏移3,y向下偏移2,默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOffset = shadowOffset
        // 阴影透明度,默认0
        subLayer.shadowOpacity = shadowOpacity
        // 阴影半径,默认3
        subLayer.shadowRadius = shadowRadius
        superview.layer.insertSublayer(subLayer, below: layer)
    }

    /// 添加内阴影图层
    /// - Parameters:
    ///   - shadowColor: 阴影的颜色
    ///   - shadowOffset: 阴影的偏移度:CGSizeMake(X[正的右偏移,负的左偏移], Y[正的下偏移,负的上偏移])
    ///   - shadowOpacity: 阴影的不透明度
    ///   - shadowRadius: 阴影半径,默认3
    ///   - insetBySize: 内阴影偏移大小
    func addInnerShadowLayer(shadowColor: UIColor,
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

        // let someInnerPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:innerPathRadius).cgPath
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

// MARK: - 边框
public extension UIView {
    /// 添加边框
    /// - Parameters:
    ///   - width:边框宽度
    ///   - color:边框颜色
    func addBorder(borderWidth: CGFloat, borderColor: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }

    /// 添加顶部的 边框
    /// - Parameters:
    ///   - borderWidth:边框宽度
    ///   - borderColor:边框颜色
    func addBorderTop(borderWidth: CGFloat, borderColor: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: borderWidth, color: borderColor)
    }

    /// 添加底部的 边框
    /// - Parameters:
    ///   - borderWidth:边框宽度
    ///   - borderColor:边框颜色
    func addBorderBottom(borderWidth: CGFloat, borderColor: UIColor) {
        addBorderUtility(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth, color: borderColor)
    }

    /// 添加左边的 边框
    /// - Parameters:
    ///   - borderWidth:边框宽度
    ///   - borderColor:边框颜色
    func addBorderLeft(borderWidth: CGFloat, borderColor: UIColor) {
        addBorderUtility(x: 0, y: 0, width: borderWidth, height: frame.height, color: borderColor)
    }

    /// 添加右边的 边框
    /// - Parameters:
    ///   - borderWidth:边框宽度
    ///   - borderColor:边框颜色
    func addBorderRight(borderWidth: CGFloat, borderColor: UIColor) {
        addBorderUtility(x: frame.width - borderWidth, y: 0, width: borderWidth, height: frame.height, color: borderColor)
    }

    /// 为`UIView`添加边框
    /// - Parameters:
    ///   - x: 边框`X`坐标
    ///   - y: 边框`Y`坐标
    ///   - width: 边框宽度
    ///   - height: 边框高度
    ///   - color: 边框颜色
    private func addBorderUtility(x: CGFloat,
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

    /// 绘制圆环
    /// - Parameters:
    ///   - fillColor:内环的颜色
    ///   - strokeColor:外环的颜色
    ///   - strokeWidth:外环的宽度
    func drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
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

    /// 绘制虚线
    /// - Parameters:
    ///   - strokeColor:虚线颜色
    ///   - lineLength:每段虚线的长度
    ///   - lineSpacing:每段虚线的间隔
    ///   - isHorizontal:是否水平方向
    func drawDashLine(strokeColor: UIColor, lineLength: Int = 4, lineSpacing: Int = 4, isHorizontal: Bool = true) {
        // 线粗
        let lineWidth = isHorizontal ? bounds.height : bounds.width

        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor

        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        // 每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        // 起点
        let path = CGMutablePath()
        if isHorizontal {
            path.move(to: CGPoint(x: 0, y: lineWidth / 2))
            // 终点
            // 横向 y = lineWidth / 2
            path.addLine(to: CGPoint(x: bounds.width, y: lineWidth / 2))
        } else {
            path.move(to: CGPoint(x: lineWidth / 2, y: 0))
            // 终点
            // 纵向 Y = view 的height
            path.addLine(to: CGPoint(x: lineWidth / 2, y: bounds.height))
        }
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

// MARK: - 颜色渐变
public extension UIView {
    /// 设置线性渐变边框
    /// - Parameters:
    ///   - size: 大小
    ///   - colors: 颜色数组
    ///   - locations: 位置数组
    ///   - start: 开始位置
    ///   - end: 结束位置
    ///   - borderWidth: 边框宽度
    ///   - roundingCorners: 圆角方向
    ///   - cornerRadii: 圆角半径
    func setLinearGradientBorder(_ size: CGSize,
                                 colors: [UIColor],
                                 locations: [CGFloat] = [0, 1],
                                 start: CGPoint,
                                 end: CGPoint,
                                 borderWidth: CGFloat = 1.0,
                                 roundingCorners: UIRectCorner = .allCorners,
                                 cornerRadii: CGFloat = 0)
    {
        let gradientLayer = colors.createLinearGradientLayer(size,
                                                             locations: locations,
                                                             start: start,
                                                             end: end)

        let maskLayer = CAShapeLayer.default()
            .pd_lineWidth(borderWidth)
            .pd_path(UIBezierPath(
                roundedRect: gradientLayer.bounds,
                byRoundingCorners: roundingCorners,
                cornerRadii: CGSize(width: cornerRadii, height: cornerRadii)
            ).cgPath)
            .pd_fillColor(.clear)
            .pd_strokeColor(.black)

        gradientLayer.mask = maskLayer
        layer.addSublayer(gradientLayer)
    }

    /// 添加线性渐变背景图层
    /// - Parameters:
    ///   - size:渐变大小
    ///   - colors:渐变的颜色数组
    ///   - locations:颜色位置
    ///   - start: 开始位置
    ///   - end: 结束位置
    func setLinearGradientBackgroundLayer(_ size: CGSize,
                                          colors: [UIColor],
                                          locations: [CGFloat] = [0, 1],
                                          start: CGPoint,
                                          end: CGPoint)
    {
        let gradientLayer = colors.createLinearGradientLayer(size,
                                                             locations: locations,
                                                             start: start,
                                                             end: end)
        layer.insertSublayer(layer, at: 0)
    }

    /// 添加线性渐变背景颜色
    /// - Parameters:
    ///   - size:渐变大小
    ///   - direction:渐变方向
    ///   - locations:颜色位置
    ///   - colors:渐变的颜色数组
    func setLinearGradientBackgroundColor(_ size: CGSize,
                                          colors: [UIColor],
                                          locations: [CGFloat] = [0, 1],
                                          start: CGPoint,
                                          end: CGPoint)
    {
        let gradientColor = colors.createLinearGradientColor(size,
                                                             locations: locations,
                                                             start: start,
                                                             end: end)
        backgroundColor = gradientColor
    }

    /// 线性渐变动画
    /// - Parameters:
    ///   - size: 渐变大小
    ///   - startColors: 开始颜色数组
    ///   - endColors: 结束颜色数组
    ///   - locations: 渐变位置
    ///   - start: 开始位置
    ///   - end: 结束位置
    ///   - duration: 动画时长
    func linearGradientColorAnimation(_ size: CGSize,
                                      startColors: [UIColor],
                                      endColors: [UIColor],
                                      locations: [CGFloat],
                                      start: CGPoint,
                                      end: CGPoint,
                                      duration: CFTimeInterval = 1.0)
    {
        let gradientLayer = startColors.createLinearGradientLayer(size,
                                                                  locations: locations,
                                                                  start: start,
                                                                  end: end)
        layer.insertSublayer(gradientLayer, at: 0)

        // 执行动画
        startLinearGradientColorAnimation(
            gradientLayer,
            startColors: startColors,
            endColors: endColors,
            duration: duration
        )
    }

    ///  开始线性渐变动画
    /// - Parameters:
    ///   - gradientLayer:要执行动画的图层
    ///   - startColors:开始颜色数组
    ///   - endColors:结束颜色数组
    ///   - duration:动画时长
    private func startLinearGradientColorAnimation(_ gradientLayer: CAGradientLayer,
                                                   startColors: [UIColor],
                                                   endColors: [UIColor],
                                                   duration: CFTimeInterval = 1.0)
    {
        let startColorArr = startColors.map(\.cgColor)
        let endColorArr = endColors.map(\.cgColor)

        // 添加渐变动画
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        // colorChangeAnimation.delegate = self
        colorChangeAnimation.duration = duration
        colorChangeAnimation.fromValue = startColorArr
        colorChangeAnimation.toValue = endColorArr
        colorChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        // 动画结束后保持最终的效果
        colorChangeAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorChangeAnimation, forKey: "colorChange")
    }
}

// MARK: - 水印
public extension UIView {
    /// 为`UIView`添加文字水印
    /// - Parameters:
    ///   - text: 水印文字
    ///   - textColor: 水印文字颜色
    ///   - font: 水印文字大小
    func addWatermark(
        _ text: String,
        textColor: UIColor = UIColor.black,
        font: UIFont = UIFont.systemFont(ofSize: 12)
    ) {
        // 水印文字
        let waterMark = text.toNSString()
        // 水印文字大小
        let textSize = waterMark.size(withAttributes: [NSAttributedString.Key.font: font])

        // 多少行
        let rowNum = NSInteger(bounds.height * 3.5 / 80)
        // 多少列:自己的宽度 / (每个水印的宽度+间隔)
        let colNum = NSInteger(bounds.width / text.strSize(bounds.width, font: font).width)

        for i in 0 ..< rowNum {
            for j in 0 ..< colNum {
                let textLayer: CATextLayer = .init()
                // textLayer.backgroundColor = UIColor.randomColor().cgColor
                // 按当前屏幕分辨显示,否则会模糊
                textLayer.contentsScale = UIScreen.main.scale
                textLayer.font = font
                textLayer.fontSize = font.pointSize
                textLayer.foregroundColor = textColor.cgColor
                textLayer.string = waterMark
                textLayer.frame = CGRect(x: CGFloat(j) * (textSize.width + 30), y: CGFloat(i) * 60, width: textSize.width, height: textSize.height)
                // 旋转文字
                textLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi * 0.2), 0, 0, 3)
                layer.addSublayer(textLayer)
            }
        }
    }
}

// MARK: - 抖动效果
public extension UIView {
    enum ShakeDirection {
        /// 左右抖动
        case horizontal
        /// 上下抖动
        case vertical
    }

    enum ShakeAnimation {
        /// 线性动画
        case linear
        /// easeIn动画
        case easeIn
        /// easeOut动画
        case easeOut
        ///  easeInOut动画
        case easeInOut
    }

    /// 让`UIView`抖动
    /// - Parameters:
    ///   - shakeDirection: 抖动方向(水平或垂直)(默认为水平)
    ///   - shakeAnimation: shake动画类型(默认为.easeOut)
    ///   - duration: 以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion: 完成回调,用于在动画完成时运行(默认为nil)
    func shake(shakeDirection: ShakeDirection = .horizontal,
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

// MARK: 手势
public extension UIView {
    /// 将数组中的手势添加到`UIView`
    /// - Parameter gestureRecognizers: 手势数组
    func addGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        isUserInteractionEnabled = true
        for recognizer in gestureRecognizers {
            addGestureRecognizer(recognizer)
        }
    }

    /// 将数组中的手势从`UIView`中移除
    /// - Parameter gestureRecognizers: 手势数组
    func removeGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            removeGestureRecognizer(recognizer)
        }
    }

    /// 删除所有手势识别器
    func removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }

    /// 添加`UITapGestureRecognizer`(点击)
    /// - Parameter action:事件处理
    /// - Returns:`UITapGestureRecognizer`
    @discardableResult
    func addTapGestureRecognizer(
        _ action: @escaping (_ gesture: UITapGestureRecognizer) -> Void
    ) -> UITapGestureRecognizer {
        let obj = UITapGestureRecognizer(target: nil, action: nil)
        // 轻点次数
        obj.numberOfTapsRequired = 1
        // 手指个数
        obj.numberOfTouchesRequired = 1
        addCommonGestureRecognizer(obj)

        obj.addCallback { recognizer in
            action(recognizer)
        }

        return obj
    }

    /// 添加`UILongPressGestureRecognizer`(长按)
    /// - Parameters:
    ///   - action:事件处理
    ///   - minimumPressDuration:最小长按时间
    /// - Returns:`UILongPressGestureRecognizer`
    @discardableResult
    func addLongPressGestureRecognizer(
        _ action: @escaping (_ gesture: UILongPressGestureRecognizer) -> Void,
        for minimumPressDuration: TimeInterval
    ) -> UILongPressGestureRecognizer {
        let obj = UILongPressGestureRecognizer(target: nil, action: nil)
        obj.minimumPressDuration = minimumPressDuration
        addCommonGestureRecognizer(obj)

        obj.addCallback { recognizer in
            action(recognizer)
        }
        return obj
    }

    /// 添加`UIPanGestureRecognizer`(拖拽)
    /// - Parameter action:事件处理
    /// - Returns:`UIPanGestureRecognizer`
    @discardableResult
    func addPanGestureRecognizer(
        _ action: @escaping (_ gesture: UIPanGestureRecognizer) -> Void
    ) -> UIPanGestureRecognizer {
        let obj = UIPanGestureRecognizer(target: nil, action: nil)
        obj.minimumNumberOfTouches = 1
        obj.maximumNumberOfTouches = 3
        addCommonGestureRecognizer(obj)

        obj.addCallback { recognizer in
            if let sender = recognizer as? UIPanGestureRecognizer, let senderView = sender.view {
                let translate: CGPoint = sender.translation(in: senderView.superview)
                senderView.center = CGPoint(x: senderView.center.x + translate.x, y: senderView.center.y + translate.y)
                sender.setTranslation(.zero, in: senderView.superview)
                action(recognizer)
            }
        }
        return obj
    }

    /// 添加`UIScreenEdgePanGestureRecognizer`(屏幕边缘拖拽)
    /// - Parameters:
    ///   - target:监听对象
    ///   - action:事件处理
    ///   - edgs:边缘
    /// - Returns:`UIScreenEdgePanGestureRecognizer`
    @discardableResult
    func addScreenEdgePanGestureRecognizer(
        _ target: Any?,
        action: Selector?,
        for edgs: UIRectEdge
    ) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: target, action: action)
        obj.edges = edgs
        addCommonGestureRecognizer(obj)
        return obj
    }

    /// 添加`UIScreenEdgePanGestureRecognizer`(屏幕边缘拖拽)
    /// - Parameters:
    ///   - action:事件
    ///   - edgs:边缘
    /// - Returns:`UIScreenEdgePanGestureRecognizer`
    @discardableResult
    func addScreenEdgePanGestureRecognizer(
        action: @escaping (_ gesture: UIScreenEdgePanGestureRecognizer) -> Void,
        for edgs: UIRectEdge
    ) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: nil, action: nil)
        obj.edges = edgs
        addCommonGestureRecognizer(obj)
        obj.addCallback { recognizer in
            action(recognizer)
        }
        return obj
    }

    /// 添加`UISwipeGestureRecognizer`(轻扫)
    /// - Parameters:
    ///   - target:事件对象
    ///   - action:事件处理
    ///   - direction:轻扫方向
    /// - Returns:`UISwipeGestureRecognizer`
    @discardableResult
    func addSwipeGestureRecognizer(
        _ target: Any?,
        action: Selector?,
        for direction: UISwipeGestureRecognizer.Direction
    ) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: target, action: action)
        obj.direction = direction
        addCommonGestureRecognizer(obj)
        return obj
    }

    /// 添加`UISwipeGestureRecognizer`(轻扫)
    /// - Parameters:
    ///   - action:事件处理
    ///   - direction:轻扫方向
    /// - Returns:`UISwipeGestureRecognizer`
    func addSwipeGestureRecognizer(
        _ action: @escaping (_ gesture: UISwipeGestureRecognizer) -> Void,
        for direction: UISwipeGestureRecognizer.Direction
    ) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: nil, action: nil)
        obj.direction = direction
        addCommonGestureRecognizer(obj)
        obj.addCallback { recognizer in
            action(recognizer)
        }
        return obj
    }

    /// 添加`UIPinchGestureRecognizer`(捏合)
    /// - Parameter action:事件处理
    /// - Returns:`UIPinchGestureRecognizer`
    func addPinchGestureRecognizer(_ action: @escaping (_ gesture: UIPinchGestureRecognizer) -> Void) -> UIPinchGestureRecognizer {
        let obj = UIPinchGestureRecognizer(target: nil, action: nil)
        addCommonGestureRecognizer(obj)
        obj.addCallback { recognizer in
            if let sender = recognizer as? UIPinchGestureRecognizer {
                let location = recognizer.location(in: sender.view!.superview)
                sender.view!.center = location
                sender.view!.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
                sender.scale = 1.0
                action(recognizer)
            }
        }
        return obj
    }

    /// 添加`UIRotationGestureRecognizer`(旋转)
    /// - Parameter action:事件处理
    /// - Returns:`UIRotationGestureRecognizer`
    @discardableResult
    func addRotationGestureRecognizer(
        _ action: @escaping (_ gesture: UIRotationGestureRecognizer) -> Void
    ) -> UIRotationGestureRecognizer {
        let obj = UIRotationGestureRecognizer(target: nil, action: nil)
        addCommonGestureRecognizer(obj)
        obj.addCallback { recognizer in
            if let sender = recognizer as? UIRotationGestureRecognizer {
                sender.view!.transform = sender.view!.transform.rotated(by: sender.rotation)
                sender.rotation = 0.0
                action(recognizer)
            }
        }
        return obj
    }

    /// 添加手势到`UIView`上
    /// - Parameter gestureRecognizer: 要添加的手势
    private func addCommonGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(gestureRecognizer)
    }
}

// MARK: - 方法
public extension UIView {
    /// 递归查找第一响应者
    func findFirstResponder() -> UIView? {
        if isFirstResponder { return self }
        for subView in subviews {
            if let firstResponder = subView.findFirstResponder() { return firstResponder }
        }
        return nil
    }

    /// `point`是否位置当前视图中
    /// - Parameter point:位置点
    /// - Returns:是否是视图内点击
    func contains(_ point: CGPoint) -> Bool {
        point.x > frame.minX && point.x < frame.maxX && point.y > frame.minY && point.y < frame.maxY
    }

    /// 判断当前视图是否包涵类型的子视图
    /// - Parameter name: 要查询的类型
    /// - Returns: 是否包涵
    func contains<T: UIView>(withClass name: T.Type) -> Bool {
        if isKind(of: T.self) { return true }
        for subView in subviews {
            if subView.contains(withClass: T.self) { return true }
        }
        return false
    }

    /// 查找`T`的父视图, 直到找到为止
    /// - Parameter name: 要查找的类型
    func findSuperview<T: UIView>(withClass name: T.Type) -> T? {
        findSuperview(where: { $0 is T }) as? T
    }

    /// 查找符合条件的父视图
    /// - Parameter predicate: 条件
    func findSuperview(where predicate: (UIView?) -> Bool) -> UIView? {
        if predicate(superview) { return superview }
        return superview?.findSuperview(where: predicate)
    }

    /// 查找与`T`一样的子视图, 直到找到为止
    /// - Parameter name: 要查找的类型
    func findSubview<T: UIView>(withClass name: T.Type) -> T? {
        findSubview(where: { $0 is T }) as? T
    }

    /// 查找符合条件的子视图
    /// - Parameter predicate: 条件
    func findSubview(where predicate: (UIView?) -> Bool) -> UIView? {
        guard subviews.count > 0 else { return nil }
        for subView in subviews {
            if predicate(subView) { return subView }
            return subView.findSubview(where: predicate)
        }
        return nil
    }

    /// 查找所有与`T`一样的子视图
    /// - Parameter name: 要查找的类型
    func findSubviews<T: UIView>(withClass name: T.Type) -> [T] {
        findSubviews(where: { $0 is T }).map { view in view as! T }
    }

    /// 查找所有符合条件的子视图
    /// - Parameter predicate: 条件
    func findSubviews(where predicate: (UIView?) -> Bool) -> [UIView] {
        guard subviews.count > 0 else { return [] }

        var result: [UIView] = []
        for subView in subviews {
            if predicate(subView) { result.append(subView) }
            result += subView.findSubviews(where: predicate)
        }
        return result
    }

    /// 添加子视图数组到self
    /// - Parameter subviews:子视图数组
    func addSubviews(_ subviews: [UIView]) { subviews.forEach { addSubview($0) }}

    /// 移除所有的子视图
    func removeSubviews() { subviews.forEach { $0.removeFromSuperview() }}

    /// 移除`layer`
    func removeLayer() {
        layer.mask = nil
        layer.borderWidth = 0
    }

    /// 隐藏键盘
    func hiddenKeyboard() { endEditing(true) }

    /// 强制更新布局(立即更新)
    func relayout() {
        // 标记视图,runloop的下一个周期调用layoutSubviews
        setNeedsLayout()
        // 如果这个视图有被setNeedsLayout方法标记的, 会立即执行layoutSubviews方法
        layoutIfNeeded()
    }
}

// MARK: debug
public extension UIView {
    /// 为当前视图的子视图添加边框及背景颜色(只在Debug环境生效)
    /// - Parameters:
    ///   - borderWidth:视图的边框宽度
    ///   - borderColor:视图的边框颜色
    ///   - backgroundColor:视图的背景色
    func stressView(_ borderWidth: CGFloat = 1, borderColor: UIColor = .random, backgroundColor: UIColor = .random) {
        guard Panda.dev.isDebug else { return }
        guard subviews.count > 0 else { return }

        for subview in subviews {
            subview.layer.borderWidth = borderWidth
            subview.layer.borderColor = borderColor.cgColor
            subview.backgroundColor = backgroundColor
            subview.stressView(borderWidth, borderColor: borderColor, backgroundColor: backgroundColor)
        }
    }
}

// MARK: - 截图
public extension UIView {
    /// 截取整个滚动视图的快照(截图)
    @objc func captureScreenshot() -> UIImage? {
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

// MARK: - Nib
public extension UIView {
    /// 从nib加载view
    /// - Parameters:
    ///   - name:nib名称
    ///   - bundle:nib的bundle(默认为nil)
    /// - Returns:从nib加载的view
    class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

    /// 从nib加载特定类型的视图
    /// - Parameters:
    ///   - withClass:UIView类型
    ///   - bundle:nib所在bundle
    /// - Returns:UIView
    class func loadFromNib<T: UIView>(withClass name: T.Type, bundle: Bundle? = nil) -> T {
        let named = String(describing: name)
        guard let view = UINib(nibName: named, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? T else {
            fatalError("First element in xib file \(named) is not of type \(named)")
        }
        return view
    }
}

// MARK: - 过渡动画效果
public extension UIView {
    /// view淡入效果(从透明到不透明)
    /// - Parameters:
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden { isHidden = false }
        UIView.animate(withDuration: duration, animations: { self.alpha = 1 }, completion: completion)
    }

    /// view淡出效果(从不透明到透明)
    /// - Parameters:
    ///   - duration:以秒为单位的动画持续时间(默认值为1秒)
    ///   - completion:完成回调,用于在动画完成时运行(默认为nil)
    func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden { isHidden = false }
        UIView.animate(withDuration: duration, animations: { self.alpha = 0 }, completion: completion)
    }
}

// MARK: - 适配
public extension UIView {
    // 全局适配
    @available(iOS 12.0, *)
    static func fitAllView(userInterfaceStyle: UIUserInterfaceStyle) {
        // 设置页面为高亮模式 不自动适应暗黑模式
        if #available(iOS 13.0, *) {
            UIView.appearance().overrideUserInterfaceStyle = .light
        }
    }
}

// MARK: - `CGRect`
public extension UIView {
    /// 控件位置/尺寸相关信息(origin坐标参照父级)
    var pd_frame: CGRect {
        get { frame }
        set { frame = newValue }
    }

    /// 控件位置/尺寸相关信息(origin坐标参照自身)
    var pd_bounds: CGRect {
        get { bounds }
        set { frame = CGRect(origin: .zero, size: newValue.size) }
    }

    /// 控件的origin(控件的左上角)
    var pd_origin: CGPoint {
        get { frame.origin }
        set { frame = CGRect(origin: newValue, size: pd_size) }
    }

    /// 控件X(minX)
    var pd_x: CGFloat {
        get { frame.origin.x }
        set { frame = CGRect(origin: CGPoint(x: newValue, y: pd_origin.y), size: pd_size) }
    }

    /// 控件Y(minY)
    var pd_y: CGFloat {
        get { frame.origin.y }
        set { frame = CGRect(origin: CGPoint(x: pd_origin.x, y: newValue), size: pd_size) }
    }

    /// 控件右边(maxX)
    var pd_maxX: CGFloat {
        get { frame.maxX }
        set { frame = CGRect(origin: CGPoint(x: newValue - pd_width, y: pd_y), size: pd_size) }
    }

    /// 控件底部(maxY)
    var pd_maxY: CGFloat {
        get { frame.maxY }
        set { frame = CGRect(origin: CGPoint(x: pd_x, y: newValue - pd_height), size: pd_size) }
    }

    /// 控件的尺寸
    var pd_size: CGSize {
        get { frame.size }
        set { frame = CGRect(origin: pd_origin, size: newValue) }
    }

    /// 控件的宽度
    var pd_width: CGFloat {
        get { frame.width }
        set { frame = CGRect(origin: pd_origin, size: CGSize(width: newValue, height: pd_size.height)) }
    }

    /// 控件的高度
    var pd_height: CGFloat {
        get { frame.height }
        set { frame = CGRect(origin: pd_origin, size: CGSize(width: pd_size.width, height: newValue)) }
    }

    /// 以bounds为基准的中心点(只读)
    var pd_self_center: CGPoint {
        CGPoint(x: pd_width / 2, y: pd_height / 2)
    }

    /// 以frame为基准的中心点
    var pd_center: CGPoint {
        get { center }
        set { center = newValue }
    }

    /// 控件中心点X
    var pd_centerX: CGFloat {
        get { pd_center.x }
        set { pd_center = CGPoint(x: newValue, y: pd_center.y) }
    }

    /// 控件中心点Y
    var pd_centerY: CGFloat {
        get { pd_center.y }
        set { pd_center = CGPoint(x: pd_center.x, y: newValue) }
    }
}

// MARK: - Defaultable
extension UIView: Defaultable {}
public extension UIView {
    typealias Associatedtype = UIView

    @objc class func `default`() -> Associatedtype {
        let view = UIView()
        return view
    }
}

// MARK: - 链式语法(frame相关设置)
public extension UIView {
    /// 设置 frame
    /// - Parameter frame:frame
    /// - Returns:`Self`
    @discardableResult
    func pd_frame(_ frame: CGRect) -> Self {
        pd_frame = frame
        return self
    }

    /// 控件的origin
    /// - Parameters:
    ///   - origin:坐标
    /// - Returns:`Self`
    @discardableResult
    func pd_origin(_ origin: CGPoint) -> Self {
        pd_origin = origin
        return self
    }

    /// 控件左边(`minX`)
    /// - Parameters:
    ///   - x:左侧距离
    /// - Returns:`Self`
    @discardableResult
    func pd_x(_ x: CGFloat) -> Self {
        pd_x = x
        return self
    }

    /// 控件顶部(`minY`)
    /// - Parameters:
    ///   - y:顶部距离
    /// - Returns:`Self`
    @discardableResult
    func pd_y(_ y: CGFloat) -> Self {
        pd_y = y
        return self
    }

    /// 控件最大X(`maxX`)
    /// - Parameters:
    ///   - right:右侧距离
    /// - Returns:`Self`
    @discardableResult
    func pd_maxX(_ maxX: CGFloat) -> Self {
        pd_maxX = maxX
        return self
    }

    /// 控件最大Y(`maxY`)
    /// - Parameters:
    ///   - maxY:底部距离
    /// - Returns:`Self`
    @discardableResult
    func pd_maxY(_ maxY: CGFloat) -> Self {
        pd_maxY = maxY
        return self
    }

    /// 控件的尺寸
    /// - Parameters:
    ///   - size:尺寸
    /// - Returns:`Self`
    @discardableResult
    func pd_size(_ size: CGSize) -> Self {
        pd_size = size
        return self
    }

    /// 控件的宽度
    /// - Parameters:
    ///   - width:宽度
    /// - Returns:`Self`
    @discardableResult
    func pd_width(_ width: CGFloat) -> Self {
        pd_width = width
        return self
    }

    /// 控件的高度
    /// - Parameters:
    ///   - width:宽度
    /// - Returns:`Self`
    @discardableResult
    func pd_height(_ height: CGFloat) -> Self {
        pd_height = height
        return self
    }

    /// 控件中心点
    /// - Parameters:
    ///   - center:中心位置
    /// - Returns:`Self`
    @discardableResult
    func pd_center(_ center: CGPoint) -> Self {
        pd_center = center
        return self
    }

    /// 控件中心点X
    /// - Parameters:
    ///   - centerX:中心位置X
    /// - Returns:`Self`
    @discardableResult
    func pd_centerX(_ centerX: CGFloat) -> Self {
        pd_centerX = centerX
        return self
    }

    /// 控件中心点Y
    /// - Parameters:
    ///   - centerY:中心位置Y
    /// - Returns:`Self`
    @discardableResult
    func pd_centerY(_ centerY: CGFloat) -> Self {
        pd_centerY = centerY
        return self
    }
}

// MARK: - 链式语法
public extension UIView {
    /// 设置 tag 值
    /// - Parameter tag:值
    /// - Returns:`Self`
    @discardableResult
    func pd_tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }

    /// 设置圆角
    /// - Parameter cornerRadius:圆角
    /// - Returns:`Self`
    @discardableResult
    func pd_cornerRadius(_ cornerRadius: CGFloat) -> Self {
        layer.cornerRadius = cornerRadius
        return self
    }

    /// 设置是否`masktoToBounds`
    /// - Parameter masksToBounds:是否设置
    /// - Returns:`Self`
    @discardableResult
    func pd_masksToBounds(_ masksToBounds: Bool) -> Self {
        layer.masksToBounds = masksToBounds
        return self
    }

    /// 设置裁剪
    /// - Parameter clipsToBounds:是否裁剪超出部分
    /// - Returns:`Self`
    @discardableResult
    func pd_clipsToBounds(_ clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }

    /// 内容填充模式
    /// - Parameter mode:模式
    /// - Returns:返回图片的模式
    @discardableResult
    func pd_contentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }

    /// 设置背景色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    @objc func pd_backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }

    /// 被添加到某个视图上
    /// - Parameter superView:父视图
    /// - Returns:`Self`
    @discardableResult
    func pd_add2(_ superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }

    /// 添加子控件数组到当前视图上
    /// - Parameter subviews: 子控件数组
    /// - Returns:`Self`
    @discardableResult
    func pd_addSubviews(_ subviews: [UIView]) -> Self {
        addSubviews(subviews)
        return self
    }

    /// 设置是否允许交互
    /// - Parameter isUserInteractionEnabled:是否支持触摸
    /// - Returns:`Self`
    @discardableResult
    func pd_isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }

    /// 设置是否隐藏
    /// - Parameter isHidden:是否隐藏
    /// - Returns:`Self`
    @discardableResult
    func pd_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置透明度
    /// - Parameter alpha:透明度
    /// - Returns:`Self`
    @discardableResult
    func pd_alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    /// 设置`tintColor`
    /// - Parameter tintColor:tintColor description
    /// - Returns:`Self`
    @discardableResult
    @objc func pd_tintColor(_ tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }

    /// 设置边框颜色
    /// - Parameters:
    ///   - color:边框颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_borderColor(_ color: UIColor) -> Self {
        layer.borderColor = color.cgColor
        return self
    }

    /// 设置边框宽度
    /// - Parameters:
    ///   - width:边框宽度
    /// - Returns:`Self`
    @discardableResult
    func pd_borderWidth(_ width: CGFloat = 0.5) -> Self {
        layer.borderWidth = width
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize:是否开启光栅化
    /// - Returns:`Self`
    @discardableResult
    func pd_shouldRasterize(_ rasterize: Bool) -> Self {
        layer.shouldRasterize = rasterize
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale:光栅化比例
    /// - Returns:`Self`
    @discardableResult
    func pd_rasterizationScale(_ scale: CGFloat) -> Self {
        layer.rasterizationScale = scale
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowColor(_ color: UIColor) -> Self {
        layer.shadowColor = color.cgColor
        return self
    }

    /// 设置阴影偏移
    /// - Parameter offset:偏移
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowOffset(_ offset: CGSize) -> Self {
        layer.shadowOffset = offset
        return self
    }

    /// 设置阴影圆角
    /// - Parameter radius:圆角
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowRadius(_ radius: CGFloat) -> Self {
        layer.shadowRadius = radius
        return self
    }

    /// 设置不透明度
    /// - Parameter opacity:不透明度
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowOpacity(_ opacity: Float) -> Self {
        layer.shadowOpacity = opacity
        return self
    }

    /// 设置阴影路径
    /// - Parameter path:路径
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowPath(_ path: CGPath) -> Self {
        layer.shadowPath = path
        return self
    }

    /// 添加点击事件
    /// - Parameters:
    ///   - target:监听对象
    ///   - selector:方法
    /// - Returns:`Self`
    @discardableResult
    func addTapAction(_ target: Any, _ selector: Selector) -> Self {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
        return self
    }

    /// 离屏渲染 + 栅格化 - 异步绘制之后,会生成一张独立的图像,停止滚动之后,可以监听
    @discardableResult
    func pd_rasterize() -> Self {
        layer.drawsAsynchronously = true
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        return self
    }
}
