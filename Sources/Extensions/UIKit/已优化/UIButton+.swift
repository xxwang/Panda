//
//  UIButton+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import UIKit

// MARK: - 方法
public extension UIButton {
    /// 所有状态
    private var pd_states: [UIControl.State] {
        [.normal, .selected, .highlighted, .disabled]
    }

    /// 为按钮的所有状态设置同样的图片
    /// - Parameter image:要设置的图片
    func pd_setImageForAllStates(_ image: UIImage) {
        pd_states.forEach { setImage(image, for: $0) }
    }

    /// 为按钮的所有状态设置同样的标题颜色
    /// - Parameter color:要设置的颜色
    func pd_setTitleColorForAllStates(_ color: UIColor) {
        pd_states.forEach { setTitleColor(color, for: $0) }
    }

    /// 为按钮的所有状态设置同样的标题
    /// - Parameter title:标题文字
    func pd_setTitleForAllStates(_ title: String) {
        pd_states.forEach { setTitle(title, for: $0) }
    }
}

// MARK: - 按钮布局
public extension UIButton {
    enum LayoutStyle {
        case top
        case bottom
        case left
        case right
    }

    /// 按枚举将 btn 的 image 和 title 之间位置处理
    ///  ⚠️ frame 大小必须已确定
    /// - Parameters:
    ///   - spacing:间距
    ///   - style:布局样式
    func pd_changeLayout(_ spacing: CGFloat, style: LayoutStyle) {
        let imageRect: CGRect = imageView?.frame ?? .zero
        let titleRect: CGRect = titleLabel?.frame ?? .zero
        let buttonWidth: CGFloat = frame.size.width
        let buttonHeight: CGFloat = frame.size.height
        let totalHeight = titleRect.size.height + spacing + imageRect.size.height

        switch style {
        case .left:
            titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: spacing / 2,
                bottom: 0,
                right: -spacing / 2
            )
            imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -spacing / 2,
                bottom: 0,
                right: spacing / 2
            )
        case .right:
            titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -(imageRect.size.width + spacing / 2),
                bottom: 0,
                right: imageRect.size.width + spacing / 2
            )
            imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: titleRect.size.width + spacing / 2,
                bottom: 0,
                right: -(titleRect.size.width + spacing / 2)
            )
        case .top:
            titleEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 + imageRect.size.height + spacing - titleRect.origin.y,
                left: (buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2,
                bottom: -((buttonHeight - totalHeight) / 2 + imageRect.size.height + spacing - titleRect.origin.y),
                right: -(buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2
            )
            imageEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 - imageRect.origin.y,
                left: buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2,
                bottom: -((buttonHeight - totalHeight) / 2 - imageRect.origin.y),
                right: -(buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2)
            )
        case .bottom:
            titleEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 - titleRect.origin.y,
                left: (buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2,
                bottom: -((buttonHeight - totalHeight) / 2 - titleRect.origin.y),
                right: -(buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2
            )
            imageEdgeInsets = UIEdgeInsets(
                top: (buttonHeight - totalHeight) / 2 + titleRect.size.height + spacing - imageRect.origin.y,
                left: buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2,
                bottom: -((buttonHeight - totalHeight) / 2 + titleRect.size.height + spacing - imageRect.origin.y),
                right: -(buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2)
            )
        }
    }

    /// 将标题文本和图像居中对齐
    /// - Parameters:
    ///   - imageAboveText:设置为true可使图像位于标题文本上方,默认值为false,图像位于文本左侧
    ///   - spacing:标题文本和图像之间的间距
    func pd_centerTextAndImage(imageAboveText: Bool = false, spacing: CGFloat) {
        if imageAboveText {
            guard let imageSize = imageView?.image?.size else { return }
            guard let text = titleLabel?.text else { return }
            guard let font = titleLabel?.font else { return }

            let titleSize = text.size(withAttributes: [.font: font])

            let titleOffset = -(imageSize.height + spacing)
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: titleOffset, right: 0.0)

            let imageOffset = -(titleSize.height + spacing)
            imageEdgeInsets = UIEdgeInsets(top: imageOffset, left: 0.0, bottom: 0.0, right: -titleSize.width)

            let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
            contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
        } else {
            let insetAmount = spacing / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }

    /// 调整图标与文字的间距(必须左图右字)
    func pd_spacing(_ spacing: CGFloat) {
        let sp = spacing * 0.5
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -sp, bottom: 0, right: sp)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: sp, bottom: 0, right: -sp)
    }
}

// MARK: - 计算按钮尺寸
public extension UIButton {
    /// 获取指定宽度下字符串的Size
    /// - Parameter lineWidth: 最大行宽度
    /// - Returns: 文字尺寸
    func pd_titleSize(with lineWidth: CGFloat = sizer.screen.width) -> CGSize {
        if let currentAttributedTitle {
            return currentAttributedTitle.pd_attributedSize(lineWidth)
        }
        return titleLabel?.pd_textSize(lineWidth) ?? .zero
    }
}

// MARK: - 关联键
private class AssociateKeys {
    static var CallbackKey = UnsafeRawPointer(bitPattern: ("UIButton" + "CallbackKey").hashValue)
    static var ExpandSizeKey = UnsafeRawPointer(bitPattern: ("UIButton" + "ExpandSizeKey").hashValue)
}

// MARK: - AssociatedAttributes
extension UIButton: AssociatedAttributes {
    public typealias T = UIButton

    public var callback: Callback? {
        get { AssociatedObject.get(self, &AssociateKeys.CallbackKey) as? Callback }
        set { AssociatedObject.set(self, &AssociateKeys.CallbackKey, newValue) }
    }

    @objc func tapAction(_ button: UIButton) {
        callback?(button)
    }
}

// MARK: - Button扩大点击事件
public extension UIButton {
    /// 扩大UIButton的点击区域,向四周扩展10像素的点击范围
    /// - Parameter size:向四周扩展像素的点击范围
    func pd_expandSize(size: CGFloat = 10) {
        AssociatedObject.set(self,
                             &AssociateKeys.ExpandSizeKey,
                             size,
                             objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }

    private func expandRect() -> CGRect {
        let expandSize = AssociatedObject.get(self, &AssociateKeys.ExpandSizeKey)
        if expandSize != nil {
            return CGRect(
                x: bounds.origin.x - (expandSize as! CGFloat),
                y: bounds.origin.y - (expandSize as! CGFloat),
                width: bounds.size.width + 2 * (expandSize as! CGFloat),
                height: bounds.size.height + 2 * (expandSize as! CGFloat)
            )
        } else {
            return bounds
        }
    }
}

// MARK: - 触摸范围
public extension UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect = expandRect()
        if buttonRect.equalTo(bounds) {
            return super.point(inside: point, with: event)
        } else {
            return buttonRect.contains(point)
        }
    }
}

// MARK: - Defaultable
extension UIButton {
    public typealias Associatedtype = UIButton

    @objc override open class func `default`() -> Associatedtype {
        return UIButton(type: .custom)
    }
}

// MARK: - 链式语法
public extension UIButton {
    /// 设置`title`
    /// - Parameters:
    ///   - text:文字
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_title(_ text: String, for state: UIControl.State = .normal) -> Self {
        setTitle(text, for: state)
        return self
    }

    /// 设置属性文本标题
    /// - Parameters:
    ///   - title:属性文本标题
    ///   - state:状态
    /// - Returns:`Self`
    func pd_attributedTitle(_ title: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        setAttributedTitle(title, for: state)
        return self
    }

    /// 设置文字颜色
    /// - Parameters:
    ///   - color:文字颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }

    /// 设置字体
    /// - Parameter font:字体
    /// - Returns:`Self`
    @discardableResult
    func pd_font(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }

    /// 设置图片
    /// - Parameters:
    ///   - image:图片
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }

    /// 设置图片(通过Bundle加载)
    /// - Parameters:
    ///   - imageName:图片名字
    ///   - bundle:Bundle
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_image(_ imageName: String, in bundle: Bundle? = nil, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        setImage(image, for: state)
        return self
    }

    /// 设置图片(通过`Bundle`加载)
    /// - Parameters:
    ///   - imageName:图片的名字
    ///   - bundleName:`bundle` 的名字
    ///   - aClass:`className` `bundle`所在的类的类名
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_image(_ imageName: String, in bundleName: String, from aClass: AnyClass, for state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        setImage(image, for: state)
        return self
    }

    /// 设置图片(纯颜色的图片)
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    ///   - state: 状态
    /// - Returns: `Self`
    @discardableResult
    func pd_image(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0), for state: UIControl.State = .normal) -> Self {
        let image = UIImage(with: color, size: size)
        setImage(image, for: state)
        return self
    }

    /// 设置背景图片
    /// - Parameters:
    ///   - image:图片
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }

    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - imageName:图片的名字
    ///   - bundleName:bundle 的名字
    ///   - aClass:className bundle所在的类的类名
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_backgroundImage(_ imageName: String, in bundleName: String, from aClass: AnyClass, for state: UIControl.State = .normal) -> Self {
        guard let path = Bundle(for: aClass).path(forResource: bundleName, ofType: "bundle") else {
            return self
        }
        let image = UIImage(named: imageName, in: Bundle(path: path), compatibleWith: nil)
        setBackgroundImage(image, for: state)
        return self
    }

    /// 设置背景图片(通过Bundle加载)
    /// - Parameters:
    ///   - imageName:图片的名字
    ///   - bundle:Bundle
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_backgroundImage(_ imageName: String, in bundle: Bundle? = nil, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        setBackgroundImage(image, for: state)
        return self
    }

    /// 设置背景图片(纯颜色的图片)
    /// - Parameters:
    ///   - color:背景色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_backgroundImage(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(with: color)
        setBackgroundImage(image, for: state)
        return self
    }

    /// 按钮点击回调
    /// - Parameter callback: 按钮点击回调
    /// - Returns: `Self`
    @discardableResult
    func pd_callback(_ callback: ((_ button: UIButton?) -> Void)?) -> Self {
        self.callback = callback
        addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        return self
    }

    /// 扩大按钮的点击区域
    /// - Parameter size: 向四周扩展的像素大小
    /// - Returns: `Self`
    @discardableResult
    func pd_expandClickArea(_ size: CGFloat = 10) -> Self {
        self.pd_expandSize(size: size)
        return self
    }
}
