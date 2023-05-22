//
//  UIButton+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

// MARK: - 属性
public extension UIButton {
    /// 按钮正常状态的图像；也可以从故事板上查看
    @IBInspectable
    var imageForNormal: UIImage? {
        get { image(for: .normal) }
        set { setImage(newValue, for: .normal) }
    }

    /// 按钮所选状态的图像；也可以从故事板上查看
    @IBInspectable
    var imageForSelected: UIImage? {
        get { image(for: .selected) }
        set { setImage(newValue, for: .selected) }
    }

    /// 按钮高亮显示状态的图像；也可以从故事板上查看
    @IBInspectable
    var imageForHighlighted: UIImage? {
        get { image(for: .highlighted) }
        set { setImage(newValue, for: .highlighted) }
    }

    /// 按钮禁用状态的图像；也可以从故事板上查看
    @IBInspectable
    var imageForDisabled: UIImage? {
        get { image(for: .disabled) }
        set { setImage(newValue, for: .disabled) }
    }

    /// 按钮正常状态的标题颜色；也可以从故事板上查看
    @IBInspectable
    var titleColorForNormal: UIColor? {
        get { titleColor(for: .normal) }
        set { setTitleColor(newValue, for: .normal) }
    }

    /// 按钮所选状态的标题颜色；也可以从故事板上查看
    @IBInspectable
    var titleColorForSelected: UIColor? {
        get { titleColor(for: .selected) }
        set { setTitleColor(newValue, for: .selected) }
    }

    /// 按钮高亮显示状态的标题颜色；也可以从故事板上查看
    @IBInspectable
    var titleColorForHighlighted: UIColor? {
        get { titleColor(for: .highlighted) }
        set { setTitleColor(newValue, for: .highlighted) }
    }

    /// 按钮禁用状态的标题颜色；也可以从故事板上查看
    @IBInspectable
    var titleColorForDisabled: UIColor? {
        get { titleColor(for: .disabled) }
        set { setTitleColor(newValue, for: .disabled) }
    }

    /// 按钮的正常状态标题；也可以从故事板上查看
    @IBInspectable
    var titleForNormal: String? {
        get { title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }

    /// 按钮所选状态的标题；也可以从故事板上查看
    @IBInspectable
    var titleForSelected: String? {
        get { title(for: .selected) }
        set { setTitle(newValue, for: .selected) }
    }

    /// 按钮高亮显示状态的标题；也可以从故事板上查看
    @IBInspectable
    var titleForHighlighted: String? {
        get { title(for: .highlighted) }
        set { setTitle(newValue, for: .highlighted) }
    }

    /// 按钮的禁用状态标题；也可以从故事板上查看
    @IBInspectable
    var titleForDisabled: String? {
        get { title(for: .disabled) }
        set { setTitle(newValue, for: .disabled) }
    }
}

// MARK: - 计算按钮尺寸
public extension UIButton {
    /// 获取指定宽度下字符串的Size
    /// - Parameter maxLineWidth: 最大行宽度
    /// - Returns: 文字尺寸
    func titleSize(with maxLineWidth: CGFloat = SizeManager.screenWidth) -> CGSize {
        if let attText = currentAttributedTitle { // 使用属性文本计算
            return attText.strSize(maxLineWidth)
        } else { // 使用文本计算
            return titleLabel?.textSize(maxLineWidth) ?? .zero
        }
        return .zero
    }
}

// MARK: - Defaultable
public extension UIButton {
    typealias Associatedtype = UIButton

    override class func `default`() -> Associatedtype {
        let button = UIButton(type: .custom)
        return button
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
    func pd_setTitle(_ text: String, for state: UIControl.State = .normal) -> Self {
        setTitle(text, for: state)
        return self
    }

    /// 设置属性文本标题
    /// - Parameters:
    ///   - title:属性文本标题
    ///   - state:状态
    /// - Returns:`Self`
    func pd_setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        setAttributedTitle(title, for: state)
        return self
    }

    /// 设置文字颜色
    /// - Parameters:
    ///   - color:文字颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_setTitleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }

    /// 设置文字颜色
    /// - Parameters:
    ///   - hex:文字颜色
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_setTitleColor(_ hex: String, for state: UIControl.State = .normal) -> Self {
        setTitleColor(UIColor(hex: hex), for: state)
        return self
    }

    /// 设置字体
    /// - Parameter font:字体
    /// - Returns:`Self`
    @discardableResult
    func pd_setFont(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }

    /// 设置系统字体
    /// - Parameter fontSize:字体大小
    /// - Returns:`Self`
    @discardableResult
    func pd_setSystemFont(_ fontSize: CGFloat) -> Self {
        titleLabel?.font = .systemFont(ofSize: fontSize)
        return self
    }

    /// 设置系统粗体
    /// - Parameter fontSize:字体大小
    /// - Returns:`Self`
    @discardableResult
    func pd_setBoldSystemFont(_ fontSize: CGFloat) -> Self {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        return self
    }

    /// 设置图片
    /// - Parameters:
    ///   - image:图片
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_setImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
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
    func pd_setImage(
        _ imageName: String,
        in bundle: Bundle? = nil,
        for state: UIControl.State = .normal
    ) -> Self {
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
    func pd_setImage(
        _ imageName: String,
        in bundleName: String,
        from aClass: AnyClass,
        for state: UIControl.State = .normal
    ) -> Self {
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
    func pd_setImage(
        _ color: UIColor,
        size: CGSize = CGSize(width: 1.0, height: 1.0),
        for state: UIControl.State = .normal
    ) -> Self {
        let image = UIImage(color, size: size)
        setImage(image, for: state)
        return self
    }

    /// 设置背景图片
    /// - Parameters:
    ///   - image:图片
    ///   - state:状态
    /// - Returns:`Self`
    @discardableResult
    func pd_setBackgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
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
    func pd_setBackgroundImage(
        _ imageName: String,
        in bundleName: String,
        from aClass: AnyClass,
        for state: UIControl.State = .normal
    ) -> Self {
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
    func pd_setBackgroundImage(
        _ imageName: String,
        in bundle: Bundle? = nil,
        for state: UIControl.State = .normal
    ) -> Self {
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
    func pd_setBackgroundImage(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(color)
        setBackgroundImage(image, for: state)
        return self
    }
}
