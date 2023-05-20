//
//  Shared.swift
//  
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

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