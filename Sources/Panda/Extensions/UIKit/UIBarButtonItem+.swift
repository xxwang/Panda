//
//  UIBarButtonItem+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 构造方法
public extension UIBarButtonItem {
    /// 创建固定宽度的弹簧
    /// - Parameter spacing: 宽度
    convenience init(flexible spacing: CGFloat) {
        self.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        width = spacing
    }

    /// 创建自定义`UIBarButtonItem`
    /// - Parameters:
    ///   - image: 默认图片
    ///   - highlightedImage:高亮图片
    ///   - title:标题
    ///   - font:字体
    ///   - titleColor:标题颜色
    ///   - highlightedTitleColor:高亮标题颜色
    ///   - target:事件响应方
    ///   - action:事件处理方法
    convenience init(image: UIImage? = nil,
                     highlightedImage: UIImage? = nil,
                     title: String? = nil,
                     font: UIFont? = nil,
                     titleColor: UIColor? = nil,
                     highlightedTitleColor: UIColor? = nil,
                     target: Any? = nil,
                     action: Selector?)
    {
        let button = UIButton(type: .custom)
        // 设置默认图片
        if let image { button.setImage(image, for: .normal) }
        // 设置高亮图片
        if let highlightedImage { button.setImage(highlightedImage, for: .highlighted) }
        // 设置标题文字
        if let title { button.setTitle(title, for: .normal) }
        // 设置标题字体
        if let font { button.titleLabel?.font = font }
        // 设置标题颜色
        if let titleColor { button.setTitleColor(titleColor, for: .normal) }
        // 设置高亮标题颜色
        if let highlightedTitleColor { button.setTitleColor(highlightedTitleColor, for: .highlighted) }
        // 设置响应方法
        if let target, let action { button.addTarget(target, action: action, for: .touchUpInside) }
        // 设置图标与标题之间的间距
        button.spacing(3)

        self.init(customView: button)
    }
}

// MARK: - 关联键
private enum AssociateKeys {
    static var CallbackKey = "UIBarButtonItem" + "CallbackKey"
}

// MARK: - AssociatedAttributes
extension UIBarButtonItem: AssociatedAttributes {
    internal typealias T = UIBarButtonItem
    internal var callback: Callback? {
        get { AssociatedObject.object(self, &AssociateKeys.CallbackKey) }
        set { AssociatedObject.associate(self, &AssociateKeys.CallbackKey, newValue) }
    }

    /// 事件处理
    /// - Parameter event:事件发生者
    @objc internal func eventHandler(_ event: UIBarButtonItem) {
        callback?(event)
    }
}

// MARK: - Defaultable
extension UIBarButtonItem: Defaultable {}
public extension UIBarButtonItem {
    typealias Associatedtype = UIBarButtonItem

    class func `default`() -> Associatedtype {
        let item = UIBarButtonItem()
        return item
    }
}

// MARK: - 链式方法
public extension UIBarButtonItem {
    /// 设置图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func pd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置标题
    /// - Parameter title: 标题
    /// - Returns: `Self`
    @discardableResult
    func pd_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置宽度
    /// - Parameter width: 宽度
    /// - Returns: `Self`
    @discardableResult
    func pd_width(_ width: CGFloat) -> Self {
        self.width = width
        return self
    }

    /// 将事件响应者及事件响应方法添加到`UIBarButtonItem`
    /// - Parameters:
    ///   - target:事件响应者
    ///   - action:事件响应方法
    @discardableResult
    func pd_addTarget(_ target: AnyObject, action: Selector) -> Self {
        self.target = target
        self.action = action
        return self
    }

    /// 添加事件响应者
    /// - Parameter action: 事件响应者
    /// - Returns: `Self`
    @discardableResult
    func pd_target(_ target: AnyObject) -> Self {
        self.target = target
        return self
    }

    /// 添加事件响应方法
    /// - Parameter action: 事件响应方法
    /// - Returns: `Self`
    @discardableResult
    func pd_action(_ action: Selector) -> Self {
        self.action = action
        return self
    }

    /// 添加事件处理回调
    /// - Parameters:
    ///   - callback:事件处理回调
    /// - Returns:`Self`
    @discardableResult
    func pd_callback(_ callback: ((UIBarButtonItem?) -> Void)?) -> Self {
        self.callback = callback
        pd_addTarget(self, action: #selector(eventHandler(_:)))
        return self
    }
}
