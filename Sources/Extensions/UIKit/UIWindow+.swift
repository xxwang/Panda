import UIKit


public extension UIWindow {

    static var pd_main: UIWindow? {
        var targetWindow: UIWindow?
        if let window = pd_delegateWindow { targetWindow = window }
        if let window = pd_keyWindow { targetWindow = window }
        if let window = pd_windows.last { targetWindow = window }
        if targetWindow?.windowLevel == .normal { return targetWindow }
        pd_windows.forEach { if $0.windowLevel == .normal { targetWindow = $0 }}

        return targetWindow
    }

    static var pd_keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return pd_windows.filter(\.isKeyWindow).last
        } else {
            if let window = UIApplication.shared.keyWindow { return window }
        }
        return nil
    }

    static var pd_delegateWindow: UIWindow? {
        guard let delegateWindow = UIApplication.shared.delegate?.window else { return nil }
        guard let window = delegateWindow else { return nil }
        return window
    }

    static var pd_windows: [UIWindow] {
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

public extension UIWindow {

    static func pd_changeOrientation(isLandscape: Bool) {
        if isLandscape {
            guard !environment.isLandscape else { return }
            let resetOrientationTargert = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
            UIDevice.current.setValue(resetOrientationTargert, forKey: "orientation")
            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.landscapeRight.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")

        } else {
            guard environment.isLandscape else { return }
            let resetOrientationTargert = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
            UIDevice.current.setValue(resetOrientationTargert, forKey: "orientation")
            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.portrait.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        }
    }
}

public extension UIWindow {

    static func pd_rootViewController() -> UIViewController? {
        return UIWindow.pd_main?.rootViewController
    }

    static func pd_topViewController(_ root: UIViewController? = nil) -> UIViewController? {
        var startViewController: UIViewController = self.pd_rootViewController()!
        if let root { startViewController = root }

        if let navigationController = startViewController as? UINavigationController {
            return pd_topViewController(navigationController.visibleViewController)
        }

        if let tabBarController = startViewController as? UITabBarController {
            return pd_topViewController(tabBarController.selectedViewController)
        }

        if let presentedViewController = startViewController.presentedViewController {
            return pd_topViewController(presentedViewController.presentedViewController)
        }

        return startViewController
    }
}

public extension UIWindow {

    static func pd_setupRootViewController(with rootViewController: UIViewController,
                                           animated: Bool = true,
                                           duration: TimeInterval = 0.25,
                                           options: UIView.AnimationOptions = .transitionFlipFromRight,
                                           competion: (() -> Void)?)
    {
        guard let window = UIWindow.pd_main else { return }
        if animated {
            UIView.transition(with: window, duration: duration, options: options) {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            } completion: { _ in
                competion?()
            }
        } else {
            window.rootViewController = rootViewController
            competion?()
        }
    }

    static func pd_setupRootViewController(with rootViewController: UIViewController,
                                           animated: Bool = true,
                                           duration: TimeInterval = 0.25,
                                           animationType: CATransitionType = .fade,
                                           animationSubtype: CATransitionSubtype? = .fromRight,
                                           timingFunction: CAMediaTimingFunction? = CAMediaTimingFunction(name: .easeOut),
                                           competion: (() -> Void)? = nil)
    {
        guard let window = UIWindow.pd_main else { return }
        if animated {
            let animation = CATransition()
            animation.type = animationType
            animation.subtype = animationSubtype
            animation.duration = duration
            animation.timingFunction = timingFunction
            animation.isRemovedOnCompletion = true
            window.layer.add(animation, forKey: "animation")
        }
        window.rootViewController = rootViewController

        competion?()
    }
}

public extension UIWindow {
    typealias Associatedtype = UIWindow

    override class func `default`() -> Associatedtype {
        let window = UIWindow(frame: sizer.screen.bounds)
        return window
    }
}

public extension UIWindow {}
