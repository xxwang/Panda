//
//  UIControl+.swift
//  
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

//MARK: - Defaultable
public extension UIControl {
    typealias Associatedtype = UIControl

    override class func `default`() -> Associatedtype {
        let control = UIControl()
        return control
    }
}

// MARK: - 链式语法
public extension UIControl {
    /// 设置控件是否可用
    /// - Parameter isEnabled:是否可用
    /// - Returns:`Self`
    @discardableResult
    func pd_isEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }

    /// 设置是否可点击
    /// - Parameter isSelected:点击状态
    /// - Returns:`Self`
    @discardableResult
    func pd_isSelected(_ isSelected: Bool) -> Self {
        self.isSelected = isSelected
        return self
    }

    /// 设置是否高亮
    /// - Parameter isHighlighted:高亮状态
    /// - Returns:`Self`
    @discardableResult
    func pd_isHighlighted(_ isHighlighted: Bool) -> Self {
        self.isHighlighted = isHighlighted
        return self
    }

    /// 设置垂直方向对齐
    /// - Parameter contentVerticalAlignment:对齐方式
    /// - Returns:`Self`
    @discardableResult
    func pd_contentVerticalAlignment(_ contentVerticalAlignment: UIControl.ContentVerticalAlignment) -> Self {
        self.contentVerticalAlignment = contentVerticalAlignment
        return self
    }

    /// 设置水平方向对齐
    /// - Parameter contentHorizontalAlignment:对齐方式
    /// - Returns:`Self`
    @discardableResult
    func pd_contentHorizontalAlignment(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = contentHorizontalAlignment
        return self
    }

    /// 添加事件(默认点击事件:`touchUpInside`)
    /// - Parameters:
    ///   - target:被监听的对象
    ///   - action:事件
    ///   - events:事件的类型
    /// - Returns:`Self`
    @discardableResult
    func pd_addTarget(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        addTarget(target, action: action, for: event)
        return self
    }

    /// 移除事件(默认移除 点击事件:touchUpInside)
    /// - Parameters:
    ///   - target:被监听的对象
    ///   - action:事件
    ///   - events:事件的类型
    /// - Returns:`Self`
    @discardableResult
    func pd_removeTarget(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        removeTarget(target, action: action, for: event)
        return self
    }
}
