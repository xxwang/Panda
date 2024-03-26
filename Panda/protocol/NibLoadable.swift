//
//  NibLoadable.swift
//  xcode15-demo
//
//  Created by 奥尔良小短腿 on 2023/9/21.
//

import UIKit

// MARK: - Xib加载
public protocol NibLoadable {}

public extension NibLoadable where Self: UIView {
    /// 加载与类同名的xib
    /// - Returns: 类的实例对象
    static func loadNib(_ nibName: String? = nil) -> Self {
        let nibName = nibName ?? "\(self)"
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! Self
    }
}
