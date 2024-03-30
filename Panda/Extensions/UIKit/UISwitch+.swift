//
//  UISwitch+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import UIKit

// MARK: - Defaultable
public extension UISwitch {
    typealias Associatedtype = UISwitch

    override class func `default`() -> Associatedtype {
        let switchButton = UISwitch()
        return switchButton
    }
}

// MARK: - 链式语法
public extension UISwitch {
    /// 切换开关状态
    /// - Parameter animated:是否动画
    @discardableResult
    func pd_toggle(animated: Bool = true) -> Self {
        setOn(!isOn, animated: animated)
        return self
    }
}
