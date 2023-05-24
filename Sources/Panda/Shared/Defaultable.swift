//
//  Defaultable.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

import Foundation

// public protocol Defaultable: NSObjectProtocol where Self: NSObject {
public protocol Defaultable {
    /// 关联类型
    associatedtype Associatedtype

    /// 生成默认对象
    /// - Returns: 对象
    static func `default`() -> Associatedtype
}
