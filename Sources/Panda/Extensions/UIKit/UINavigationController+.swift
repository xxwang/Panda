//
//  UINavigationController+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 方法
public extension UINavigationController {
    /// `Push`方法(把控制器压入导航栈中)
    /// - Parameters:
    ///   - viewController: 要入栈的控制器
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func push(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    /// `pop`方法(把控制器从栈中移除)
    /// - Parameters:
    ///   - animated:是否动画
    ///   - completion:完成回调
    func pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }

    /// 设置导航条为透明
    /// - Parameter tintColor:导航条`tintColor`
    func transparent(with tintColor: UIColor = .white) {
        navigationBar.pd_isTranslucent(true)
            .pd_backgroundImage(UIImage())
            .pd_backgroundColor(.clear)
            .pd_shadowImage(UIImage())
            .pd_tintColor(tintColor)
            .pd_barTintColor(.clear)
            .pd_titleTextAttributes([.foregroundColor: tintColor])
    }
}

// MARK: - Defaultable
public extension UINavigationController {
    typealias Associatedtype = UINavigationController

    override class func `default`() -> UINavigationController {
        let item = UINavigationController()
        return item
    }
}
