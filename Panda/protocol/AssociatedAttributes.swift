//
//  AssociatedAttributes.swift
//
//
//  Created by xxwang on 2023/5/29.
//

import UIKit

// MARK: - 关联属性(增加callback属性)`协议`
public protocol AssociatedAttributes {
    associatedtype T
    typealias Callback = (T?) -> Void
    var callback: Callback? { get set }
}
