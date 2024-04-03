//
//  PDNavigationController.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import UIKit

open class PDNavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        // 设置交互手势识别器代理
        self.interactivePopGestureRecognizer?.delegate = self

        self.pd_backgroundColor(.white)
            .pd_delegate(self)
            .pd_setNavigationBarHidden(true)
            .pd_overrideUserInterfaceStyle(.light)
            .pd_modalPresentationStyle(.fullScreen)
    }
}

// MARK: - 控制器设置
extension PDNavigationController {
    // MARK: - 屏幕旋转
    override open var shouldAutorotate: Bool {
        self.topViewController?.shouldAutorotate ?? false
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }

    // MARK: - 状态栏
    override open var childForStatusBarStyle: UIViewController? {
        self.topViewController
    }

    override open var childForStatusBarHidden: UIViewController? {
        self.topViewController
    }

    override open var prefersStatusBarHidden: Bool {
        self.topViewController?.prefersStatusBarHidden ?? false
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        self.topViewController?.preferredStatusBarStyle ?? .default
    }

    // MARK: - 子控制器隐藏tabBar
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 设置导航条
        setupNavigationBar(viewController: viewController)

        // 非栈顶控制器(要入栈的控制器不是栈顶控制器, 隐藏TabBar)
        if !children.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - UINavigationControllerDelegate
extension PDNavigationController: UINavigationControllerDelegate {
    /// 栈顶控制器即将显示
    open func navigationController(_: UINavigationController, willShow viewController: UIViewController, animated _: Bool) {
        setupNavigationBar(viewController: viewController)
    }

    /// 栈顶控制器已经显示
    open func navigationController(_: UINavigationController, didShow viewController: UIViewController, animated _: Bool) {
        setupNavigationBar(viewController: viewController)
    }

    /// 设置导航条
    /// - Parameter viewController: 导航中当前栈顶子控制器
    @objc open func setupNavigationBar(viewController: UIViewController) {
        // 设置导航返回按钮
        if let viewController = viewController as? PDViewController {
            viewController.navigationBar.hiddenBackButton(children.count <= 1)
        } else {
            viewController.navigationItem.hidesBackButton = children.count <= 1
        }
    }
}

// MARK: UIGestureRecognizerDelegate
extension PDNavigationController: UIGestureRecognizerDelegate {
    /// 是否可以侧滑返回
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 如果有遵守UIGestureRecognizerDelegate
        if let lastChildren = children.last as? UIGestureRecognizerDelegate {
            return lastChildren.gestureRecognizerShouldBegin?(gestureRecognizer) ?? false
        }

        // 如果是PDViewController类或子类
        if let lastChildren = children.last as? PDViewController {
            return lastChildren.canSideBack
        }

        if viewControllers.count <= 1 { return false }
        return true
    }
}
