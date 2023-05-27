//
//  UITabBarController+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 静态属性
public extension UITabBarController {
    /// `UITabBarController`选中索引
    static var selectIndex: Int {
        get { findTabBarController()?.selectedIndex ?? 0 }
        set { findTabBarController()?.selectedIndex = newValue }
    }
}

// MARK: - 静态方法
public extension UITabBarController {
    /// 查找项目中的`UITabBarController`
    static func findTabBarController() -> UITabBarController? {
        guard let currentTabBarController = UIWindow.main?.rootViewController as? UITabBarController else {
            return nil
        }
        return currentTabBarController
    }
}

// MARK: - Defaultable
public extension UITabBarController {
    typealias Associatedtype = UITabBarController

    override class func `default`() -> Associatedtype {
        let tabBarController = UITabBarController()
        return tabBarController
    }
}

// MARK: - 链式语法
public extension UITabBarController {}
