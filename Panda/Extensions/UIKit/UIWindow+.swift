//
//  UIWindow+.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

import UIKit

// MARK: - 应用Window
public extension UIWindow {
    /// 获取一个有效的`UIWindow`
    static var main: UIWindow? {
        var targetWindow: UIWindow?
        if let window = delegateWindow { targetWindow = window }
        if let window = keyWindow { targetWindow = window }
        if let window = windows.last { targetWindow = window }
        if targetWindow?.windowLevel == .normal { return targetWindow }
        windows.forEach { if $0.windowLevel == .normal { targetWindow = $0 }}

        return targetWindow
    }

    /// 应用当前的`keyWindow`
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return windows.filter(\.isKeyWindow).last
        } else {
            if let window = UIApplication.shared.keyWindow { return window }
        }
        return nil
    }

    /// 获取`AppDelegate`的`window`(`iOS13`之后`非自定义项目框架`, 该属性为`nil`)
    static var delegateWindow: UIWindow? {
        guard let delegateWindow = UIApplication.shared.delegate?.window else { return nil }
        guard let window = delegateWindow else { return nil }
        return window
    }

    /// 所有`connectedScenes`的`UIWindow`
    static var windows: [UIWindow] {
        var windows: [UIWindow] = []
        if #available(iOS 13.0, *) {
            for connectedScene in UIApplication.shared.connectedScenes {
                guard let windowScene = connectedScene as? UIWindowScene else { continue }
                guard let windowSceneDelegate = windowScene.delegate as? UIWindowSceneDelegate else { continue }
                guard let sceneWindow = windowSceneDelegate.window else { continue }
                guard let window = sceneWindow else { continue }
                windows.append(window)
            }
        } else {
            windows = UIApplication.shared.windows
        }
        return windows
    }
}

// MARK: - 屏幕方向
public extension UIWindow {
    /// 屏幕方向切换
    /// - Parameter isLandscape:是否是横屏
    static func changeOrientation(isLandscape: Bool) {
        if isLandscape { // 横屏
            guard !EnvUtils.isLandscape else { return }
            // 重置方向
            let resetOrientationTargert = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
            UIDevice.current.setValue(resetOrientationTargert, forKey: "orientation")
            // 设置方向
            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.landscapeRight.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")

        } else { // 竖屏
            guard EnvUtils.isLandscape else { return }
            // 重置方向
            let resetOrientationTargert = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
            UIDevice.current.setValue(resetOrientationTargert, forKey: "orientation")
            // 设置方向
            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.portrait.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        }
    }
}

// MARK: - UIViewController
public extension UIWindow {
    /// 获取可用窗口的根控制器
    /// - Returns: `UIViewController?`
    static func rootViewController() -> UIViewController? {
        UIWindow.main?.rootViewController
    }

    /// 获取基准控制器的最顶层控制器
    /// - Parameter base:基准控制器
    /// - Returns:返回 UIViewController
    static func topViewController(_ root: UIViewController? = nil) -> UIViewController? {
        var startViewController: UIViewController = rootViewController()!
        if let root { startViewController = root }

        // 导航控制器
        if let navigationController = startViewController as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }

        // 标签控制器
        if let tabBarController = startViewController as? UITabBarController {
            return topViewController(tabBarController.selectedViewController)
        }

        // 被startViewController present出来的的视图控制器
        if let presentedViewController = startViewController.presentedViewController {
            return topViewController(presentedViewController.presentedViewController)
        }

        return startViewController
    }
}

// MARK: - rootViewController
public extension UIWindow {
    /// 动画方式设置`rootViewController`
    /// - Parameters:
    ///   - rootViewController: 要设置的`viewController`
    ///   - animated: 是否动画
    ///   - duration: 动画时长
    ///   - options: 动画选项
    ///   - competion: 完成回调
    /// - Returns: `Self`
    static func setupRootViewController(with rootViewController: UIViewController,
                                        animated: Bool = true,
                                        duration: TimeInterval = 0.25,
                                        options: UIView.AnimationOptions = .transitionFlipFromRight,
                                        competion: (() -> Void)?)
    {
        guard let window = UIWindow.main else { return }
        if animated { // 需要动画切换
            UIView.transition(with: window, duration: duration, options: options) {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            } completion: { _ in
                competion?()
            }
        } else { // 不需要动画
            window.rootViewController = rootViewController
            competion?()
        }
    }

    /// 转场方式设置`rootViewController`
    /// - Parameters:
    ///   - rootViewController: 要设置的`viewController`
    ///   - animated: 是否动画
    ///   - duration: 动画时长
    ///   - animationType: 动画类型
    ///   - animationSubtype: 动画子类型
    ///   - timingFunction: 定时功能
    ///   - competion: 完成回调
    static func setupRootViewController(with rootViewController: UIViewController,
                                        animated: Bool = true,
                                        duration: TimeInterval = 0.25,
                                        animationType: CATransitionType = .fade,
                                        animationSubtype: CATransitionSubtype? = .fromRight,
                                        timingFunction: CAMediaTimingFunction? = CAMediaTimingFunction(name: .easeOut),
                                        competion: (() -> Void)? = nil)
    {
        guard let window = UIWindow.main else { return }
        if animated {
            // 转场动画
            let animation = CATransition()
            animation.type = animationType
            animation.subtype = animationSubtype
            animation.duration = duration
            animation.timingFunction = timingFunction
            animation.isRemovedOnCompletion = true
            // 添加转场动画到window
            window.layer.add(animation, forKey: "animation")
        }
        window.rootViewController = rootViewController

        competion?()
    }
}

// MARK: - Defaultable
public extension UIWindow {
    typealias Associatedtype = UIWindow

    override class func `default`() -> Associatedtype {
        let window = UIWindow(frame: SizeUtils.screenBounds)
        return window
    }
}

// MARK: - 链式语法
public extension UIWindow {}
