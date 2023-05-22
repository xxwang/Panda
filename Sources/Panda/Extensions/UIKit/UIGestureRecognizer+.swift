//
//  UIGestureRecognizer+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 关联键
private enum AssociateKeys {
    static var FunctionNameKey = "UIGestureRecognizer" + "FunctionNameKey"
    static var CallbackKey = "UIGestureRecognizer" + "CallbackKey"
}

// MARK: - 属性
public extension UIGestureRecognizer {
    /// 功能名称(用于自定义`标识`)
    var functionName: String {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociateKeys.FunctionNameKey) as? String {
                return obj
            }
            let string = String(describing: classForCoder)
            objc_setAssociatedObject(self, &AssociateKeys.FunctionNameKey, string, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return string
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.FunctionNameKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
        if let callback = objc_getAssociatedObject(self, &AssociateKeys.CallbackKey) as? (_ gestureRecognizer: UIGestureRecognizer) -> Void {
            callback(self)
        }
    }
}

// MARK: - Defaultable
extension UIGestureRecognizer: Defaultable {}
public extension UIGestureRecognizer {
    typealias Associatedtype = UIGestureRecognizer

    class func `default`() -> Associatedtype {
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
    func pd_callback(_ callback: @escaping (_ gestureRecognizer: UIGestureRecognizer) -> Void) -> Self {
        addTarget(self, action: #selector(p_invoke))
        objc_setAssociatedObject(self, &AssociateKeys.CallbackKey, callback, .OBJC_ASSOCIATION_COPY_NONATOMIC)
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