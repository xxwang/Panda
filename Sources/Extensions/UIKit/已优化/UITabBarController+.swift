//
//  UITabBarController+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import UIKit

// MARK: - 静态属性
public extension UITabBarController {
    /// `UITabBarController`选中索引
    static var pd_selectIndex: Int {
        get { return self.pd_findTabBarController()?.selectedIndex ?? 0 }
        set { self.pd_findTabBarController()?.selectedIndex = newValue }
    }
}

// MARK: - 静态方法
public extension UITabBarController {
    /// 查找项目中的`UITabBarController`
    static func pd_findTabBarController() -> UITabBarController? {
        guard let currentTabBarController = UIWindow.pd_main?.rootViewController as? UITabBarController else {
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
public extension UITabBarController {
    /// 设置`UITabBarController`代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    @discardableResult
    func pd_delegate(_ delegate: UITabBarControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置`UITabBarController`子控制器
    /// - Parameter viewControllers: 子控制器
    /// - Returns: `Self`
    @discardableResult
    func pd_viewControllers(_ viewControllers: [UIViewController]?) -> Self {
        self.viewControllers = viewControllers
        return self
    }

    /// 设置`UITabBarController`子控制器
    /// - Parameters:
    ///   - viewControllers: 子控制器
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func pd_setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool = false) -> Self {
        self.setViewControllers(viewControllers, animated: animated)
        return self
    }

    /// 设置选中指定标签
    /// - Parameter index: 标签索引
    /// - Returns: `Self`
    @discardableResult
    func pd_selectedIndex(_ index: Int) -> Self {
        self.selectedIndex = index
        return self
    }
}
