//
//  AssociatedAttributes.swift
//
//
//  Created by 王斌 on 2023/5/23.
//

import UIKit

// MARK: - 关联属性`协议`
public protocol AssociatedAttributes {
    associatedtype T
    typealias Callback = (T?) -> Void
    var callback: Callback? { get set }
}
