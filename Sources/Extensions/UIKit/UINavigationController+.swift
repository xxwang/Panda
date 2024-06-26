import UIKit

// MARK: - 方法
public extension UINavigationController {
    /// 把控制器压入导航栈中
    /// - Parameters:
    ///   - viewController: 要入栈的控制器
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func pd_push(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    /// 把控制器人栈中移除
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func pd_pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }

    /// 设置导航条为透明
    /// - Parameter tintColor: 导航条`tintColor`
    func pd_transparent(with tintColor: UIColor = .white) {
        navigationBar.pd_isTranslucent(true)
            .pd_backgroundImage(UIImage())
            .pd_backgroundColor(.clear)
            .pd_shadowImage(UIImage())
            .pd_tintColor(tintColor)
            .pd_barTintColor(.clear)
            .pd_titleTextAttributes([.foregroundColor: tintColor])
    }

    /// 设置全局返回手势
    /// - Parameter isOpen: 是否开启
    func pd_fullScreenBackGesture(_ isOpen: Bool) {
        if isOpen {
            guard let popGestureRecognizer = interactivePopGestureRecognizer,
                  let targets = popGestureRecognizer.value(forKey: "_targets") as? [NSObject]
            else {
                return
            }
            guard let targetObjc = targets.first else { return }
            guard let target = targetObjc.value(forKey: "target") else { return }
            let action = Selector(("handleNavigationTransition:"))

            let panGR = UIPanGestureRecognizer(target: target, action: action)
            view.addGestureRecognizer(panGR)
        } else {
            view.gestureRecognizers?.filter { ges in
                ges is UIPanGestureRecognizer
            }.forEach { ges in
                ges.pd_remove()
            }
        }
    }
}

// MARK: - 链式语法
public extension UINavigationController {
    /// 设置导航控制器代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    @discardableResult
    func pd_delegate(_ delegate: UINavigationControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 隐藏导航栏
    /// - Parameters:
    ///   - hidden: 是否隐藏
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func pd_setNavigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        self.setNavigationBarHidden(hidden, animated: animated)
        return self
    }
}
