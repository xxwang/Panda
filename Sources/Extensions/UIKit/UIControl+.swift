//
//  UIControl+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import UIKit

// MARK: - 关联键
private class AssociateKeys {
    static var CallbackKey = UnsafeRawPointer(bitPattern: ("UIControl" + "CallbackKey").hashValue)
    static var HitTimerKey = UnsafeRawPointer(bitPattern: ("UIControl" + "HitTimerKey").hashValue)
}

// MARK: - 方法
public extension UIControl {}

// MARK: - 限制连续点击时间间隔
private extension UIControl {
    /// 重复点击限制时间
    var pd_hitTime: Double? {
        get { AssociatedObject.get(self, &AssociateKeys.HitTimerKey) as? Double }
        set { AssociatedObject.set(self, &AssociateKeys.HitTimerKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }

    /// 点击回调
    var pd_callback: ((_ control: UIControl) -> Void)? {
        get { AssociatedObject.get(self, &AssociateKeys.CallbackKey) as? ((_ control: UIControl) -> Void) }
        set { AssociatedObject.set(self, &AssociateKeys.CallbackKey, newValue) }
    }

    /// 设置指定时长(单位:秒)内不可重复点击
    /// - Parameter hitTime:时长
    func pd_doubleHit(hitTime: Double = 1) {
        self.pd_hitTime = hitTime
        self.addTarget(self, action: #selector(preventDoubleHit), for: .touchUpInside)
    }

    /// 防止重复点击实现
    /// - Parameter sender:被点击的`UIControl`
    @objc func preventDoubleHit(_ sender: UIControl) {
        self.isUserInteractionEnabled = false
        DispatchQueue.pd_delay_execute(delay: self.pd_hitTime ?? 1.0) { [weak self] in
            guard let self else { return }
            self.isUserInteractionEnabled = true
        }
    }

    /// 事件处理方法
    /// - Parameter sender:事件发起者
    @objc func controlEventHandler(_ sender: UIControl) {
        if let block = self.pd_callback { block(sender) }
    }
}

// MARK: - Defaultable
extension UIControl {
    public typealias Associatedtype = UIControl

    override open class func `default`() -> Associatedtype {
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
        self.addTarget(target, action: action, for: event)
        return self
    }

    /// 移除事件(默认移除 点击事件:touchUpInside)
    /// - Parameters:
    ///   - target:被监听的对象
    ///   - action:事件
    ///   - events:事件的类型
    /// - Returns:`Self`
    @discardableResult
    func pd_removeAction(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        removeTarget(target, action: action, for: event)
        return self
    }

    /// 设置在指定时间内禁用多次点击
    /// - Parameter hitTime:禁用时长
    /// - Returns:`Self`
    @discardableResult
    func pd_disableMultiTouch(_ hitTime: Double = 1) -> Self {
        self.pd_doubleHit(hitTime: hitTime)
        return self
    }

    /// 添加`UIControl`事件回调
    /// - Parameters:
    ///   - callback:事件回调
    ///   - controlEvent:事件类型
    /// - Returns:`Self`
    @discardableResult
    func pd_callback(_ callback: ((_ control: UIControl) -> Void)?, for controlEvent: UIControl.Event = .touchUpInside) -> Self {
        self.pd_callback = callback
        addTarget(self, action: #selector(controlEventHandler(_:)), for: controlEvent)
        return self
    }
}
