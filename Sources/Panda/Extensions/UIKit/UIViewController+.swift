//
//  UIViewController+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

// MARK: - 属性
public extension UIViewController {
    /// 检查`UIViewController`是否加载完成且在`UIWindow`上
    var isVisible: Bool {
        isViewLoaded && view.window != nil
    }
}

// MARK: - 子控制器
public extension UIViewController {
    /// 将`UIViewController`添加为当前控制器`childViewController`
    /// - Parameters:
    ///   - child: 子控制器
    ///   - containerView: 子控制器`view`要添加到的父`view`
    func addChildViewController(_ child: UIViewController, to containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// 从其父级移除当前控制器及其view
    func removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

// MARK: - 页面跳转
public extension UIViewController {
    /// 以`Modal`形式显示控制器
    /// - Parameters:
    ///   - viewController:要显示的控制器
    ///   - animated:是否动画
    ///   - completion:完成回调
    func present(viewController: UIViewController, fullScreen: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        if fullScreen {
            viewController.modalPresentationStyle = .fullScreen
        }
        present(viewController, animated: animated, completion: completion)
    }

    /// 把指定控制器push到导航栈中
    /// - Parameters:
    ///   - viewController:要压入栈的控制器
    ///   - animated:是否动画
    func push(viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    /// `pop`最后一个控制器然后`push`指定控制器
    /// - Parameters:
    ///   - viewController:要压入栈的控制器
    ///   - animated:是否要动画
    func popLast(thenPush viewController: UIViewController, animated: Bool = true) {
        guard let navigationController else { return }
        // 栈中的控制器数组
        var viewControllers = navigationController.viewControllers
        guard viewControllers.count >= 1 else {
            return
        }

        viewControllers.removeLast()
        viewControllers.append(viewController)
        navigationController.setViewControllers(viewControllers, animated: animated)
    }

    /// 往前返回(POP)几个控制器 后`push`进某个控制器
    /// - Parameters:
    ///   - count:返回(POP)几个控制器
    ///   - vc:被push的控制器
    ///   - animated:是否要动画
    func pop(count: Int, thenPush viewController: UIViewController, animated: Bool = true) {
        guard let navigationController else { return }
        if count < 1 { return }

        let navViewControllers = navigationController.viewControllers

        // 如果要pop掉的数量大于或等于栈中的数量
        if count >= navViewControllers.count {
            // 保留栈底控制器 + 要push的控制器
            if let firstViewController = navViewControllers.first {
                navigationController.setViewControllers([firstViewController, viewController], animated: animated)
            }
            return
        }

        // 保留需要的控制器
        var vcs = navViewControllers[0 ... (navViewControllers.count - count - 1)]
        // 添加要Push的控制器
        vcs.append(viewController)

        // 如果栈中控制器数量大于0就隐藏tabBar
        viewController.hidesBottomBarWhenPushed = vcs.count > 0

        navigationController.setViewControllers(Array(vcs), animated: animated)
    }

    /// pop回上一个界面
    func popToPreviousVC() {
        guard let nav = navigationController else { return }
        if let index = nav.viewControllers.firstIndex(of: self), index > 0 {
            let vc = nav.viewControllers[index - 1]
            nav.popToViewController(vc, animated: true)
        }
    }

    /// 获取`push`进来的`UIViewController`
    /// - Returns:`UIViewController`
    func previousPushVc() -> UIViewController? {
        guard let nav = navigationController else { return nil }
        if nav.viewControllers.count <= 1 {
            return nil
        }
        if let index = nav.viewControllers.firstIndex(of: self), index > 0 {
            let vc = nav.viewControllers[index - 1]
            return vc
        }
        return nil
    }
}

// MARK: - 退出控制器
public extension UIViewController {
    /// POP到`navigationController`的根控制器
    /// - Parameters:
    ///   - animated:是否动画
    func popToRootViewController(_ animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }

    /// POP到上级控制器
    /// - Parameters:
    ///   - animated:是否动画
    func popViewController(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    /// POP到指定控制器
    /// - Parameters:
    ///   - viewController:指定的控制器
    ///   - animated:是否动画
    func popTo(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(viewController, animated: animated)
    }

    /// `POP`到指定类型控制器, 从栈顶开始逐个遍历
    /// - Parameters:
    ///   - aClass:要`POP`到的控制器类型
    ///   - animated:是否动画
    /// - Returns:是否成功
    @discardableResult
    func popTo(aClass: AnyClass, animated: Bool = false) -> Bool {
        guard let navigationController else {
            return false
        }

        for viewController in navigationController.viewControllers.reversed() {
            if viewController.isMember(of: aClass) {
                navigationController.popToViewController(viewController, animated: animated)
                return true
            }
        }
        return false
    }

    /// POP指定数量的控制器(释放指定数量控制器)
    /// - Parameters:
    ///   - count:返回(POP)几个控制器
    ///   - animated:是否有动画
    func pop(count: Int, animated: Bool = false) {
        guard let navigationController else { return }
        guard count >= 1 else { return }

        // 导航栈中的控制器数组
        let navViewControllers = navigationController.viewControllers

        // 如果要pop掉的控制器数量大于现有的数量,返回到根控制器
        if count >= navViewControllers.count {
            navigationController.popToRootViewController(animated: animated)
            return
        }

        // 回到指定控制器
        let viewController = navViewControllers[navViewControllers.count - count - 1]
        navigationController.popToViewController(viewController, animated: animated)
    }

    /// 释放`Modal`出来的当前控制器
    /// - Parameters:
    ///   - animated:是否动画
    ///   - completion:完成回调
    func dismissViewController(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: animated, completion: completion)
    }

    /// 关闭当前显示的控制器
    /// - Parameter animated:是否动画
    func closeViewController(_ animated: Bool = true) {
        guard let nav = navigationController else {
            dismiss(animated: animated, completion: nil)
            return
        }

        if nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
        } else if let _ = nav.presentingViewController {
            nav.dismiss(animated: animated, completion: nil)
        }
    }
}

// MARK: - 方法
public extension UIViewController {
    /// 将`UIViewController`显示为弹出框(`Popover`样式显示)
    /// - Parameters:
    ///   - contentVC:要展示的内容控制器
    ///   - sourcePoint:箭头位置(从哪里显示出来)
    ///   - contentSize:内容大小
    ///   - delegate:代理
    ///   - animated:是否动画
    ///   - completion:完成回调
    func presentPopover(
        _ contentVC: UIViewController,
        sourcePoint: CGPoint,
        contentSize: CGSize? = nil,
        delegate: UIPopoverPresentationControllerDelegate? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        // 设置`modal`样式为`popover`
        contentVC.modalPresentationStyle = .popover
        if let contentSize {
            contentVC.preferredContentSize = contentSize
        }

        // 设置`popoverPresentationController`
        if let popoverPresentationController = contentVC.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(origin: sourcePoint, size: .zero)
            popoverPresentationController.delegate = delegate
        }
        present(contentVC, animated: animated, completion: completion)
    }
}

// MARK: - Defaultable
extension UIViewController: Defaultable {}
public extension UIViewController {
    typealias Associatedtype = UIViewController

    @objc class func `default`() -> Associatedtype {
        let vc = UIViewController()
        return vc
    }
}

// MARK: - 链式语法
public extension UIViewController {}
