//
//  AssociatedObject.swift
//
//
//  Created by 王斌 on 2023/5/23.
//

import UIKit

// MARK: - 关联属性(增加callback属性)`协议`
public protocol AssociatedAttributes {
    associatedtype T
    typealias Callback = (T?) -> Void
    var callback: Callback? { get set }
}

// MARK: - 关联属性`操作方法`
public class AssociatedObject {
    /// 设置关联属性
    static func set(
        _ object: Any,
        _ key: UnsafeRawPointer,
        _ value: some Any,
        _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    ) {
        objc_setAssociatedObject(object, key, value, policy)
    }

    /// 获取关联属性
    static func get(_ object: Any, _ key: UnsafeRawPointer) -> Any? {
        objc_getAssociatedObject(object, key)
    }

    /// 删除关联属性
    static func remove(_ object: Any) {
        objc_removeAssociatedObjects(object)
    }
}
