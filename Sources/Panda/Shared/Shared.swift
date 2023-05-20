//
//  Shared.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

// MARK: - 关联属性`协议`
internal protocol AssociatedAttributes {
    /// 关联类型
    associatedtype T

    /// 定义回调函数别名
    typealias TaskCallback = (T?) -> Void

    /// 定义`TaskCallback`类型的计算属性
    var taskCallback: TaskCallback? { get set }
}

// MARK: - 关联属性`操作方法`
public enum AssociatedObject {
    /// 设置关联属性
    static func associate(
        _ object: Any,
        _ key: UnsafeRawPointer,
        _ value: some Any,
        _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    ) {
        objc_setAssociatedObject(object, key, value, policy)
    }

    /// 获取关联属性
    static func object<T>(
        _ object: Any,
        _ key: UnsafeRawPointer
    ) -> T? {
        objc_getAssociatedObject(object, key) as? T
    }
}
