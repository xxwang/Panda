//
//  UIView+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

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

// MARK: - 属性`CGRect`
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
    func pd_backgroundColor(_ backgroundColor: UIColor) -> Self {
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
    func pd_tintColor(_ tintColor: UIColor) -> Self {
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

// MARK: - 链式语法(frame相关设置)
public extension UIView {
    /// 设置 frame
    /// - Parameter frame:frame
    /// - Returns:`Self`
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
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
