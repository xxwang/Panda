//
//  PDNavigationController.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import UIKit

class PDNavigationController: UINavigationController {
    override func viewDidLoad() {
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
    override var shouldAutorotate: Bool {
        self.topViewController?.shouldAutorotate ?? false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }

    // MARK: - 状态栏
    override var childForStatusBarStyle: UIViewController? {
        self.topViewController
    }

    override var childForStatusBarHidden: UIViewController? {
        self.topViewController
    }

    override var prefersStatusBarHidden: Bool {
        self.topViewController?.prefersStatusBarHidden ?? false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        self.topViewController?.preferredStatusBarStyle ?? .default
    }

    // MARK: - 子控制器隐藏tabBar
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
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
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setupNavigationBar(viewController: viewController)
    }
    /// 栈顶控制器已经显示
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        setupNavigationBar(viewController: viewController)
    }

    /// 设置导航条
    /// - Parameter viewController: 导航中当前栈顶子控制器
    @objc func setupNavigationBar(viewController: UIViewController) {
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
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
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
