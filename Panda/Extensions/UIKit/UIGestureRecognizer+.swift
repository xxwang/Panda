//
//  UIGestureRecognizer+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import UIKit

// MARK: - 关联键
private class AssociateKeys {
    static var FunctionNameKey = UnsafeRawPointer(bitPattern: ("UIGestureRecognizer" + "FunctionNameKey").hashValue)
    static var CallbackKey = UnsafeRawPointer(bitPattern: ("UIGestureRecognizer" + "CallbackKey").hashValue)
}

// MARK: - 属性
public extension UIGestureRecognizer {
    /// 功能名称(用于自定义`标识`)
    var functionName: String {
        get {
            if let obj = AssociatedObject.get(self, &AssociateKeys.FunctionNameKey) as? String {
                return obj
            }
            let string = String(describing: classForCoder)
            AssociatedObject.set(self, &AssociateKeys.FunctionNameKey, string, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return string
        }
        set {
            AssociatedObject.set(self, &AssociateKeys.FunctionNameKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - 方法
public extension UIGestureRecognizer {
    /// 移除手势
    func remove() { view?.removeGestureRecognizer(self) }
}

// MARK: - 私有方法
public extension UIGestureRecognizer {
    /// 手势响应方法
    @objc private func p_invoke() {
        if let callback = AssociatedObject.get(self, &AssociateKeys.CallbackKey) as? (_ recognizer: UIGestureRecognizer) -> Void {
            callback(self)
        }
    }
}

// MARK: - Defaultable
extension UIGestureRecognizer: Defaultable {}
extension UIGestureRecognizer {
    public typealias Associatedtype = UIGestureRecognizer

    @objc open class func `default`() -> Associatedtype {
        let gestureRecognizer = UIGestureRecognizer()
        return gestureRecognizer
    }
}

// MARK: - 链式语法
public extension UIGestureRecognizer {
    /// 添加手势响应回调
    /// - Parameter callback:响应回调
    /// - Returns: `Self`
    @discardableResult
    func pd_callback(_ callback: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> Self {
        addTarget(self, action: #selector(p_invoke))
        AssociatedObject.set(self, &AssociateKeys.CallbackKey, callback, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return self
    }

    /// 添加响应方法
    /// - Parameters:
    ///   - target: 目标
    ///   - action: 方法选择器
    /// - Returns: `Self`
    @discardableResult
    func pd_addTarget(_ target: Any, action: Selector) -> Self {
        addTarget(target, action: action)
        return self
    }
}
