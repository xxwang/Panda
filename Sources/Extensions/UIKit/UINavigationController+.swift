import UIKit


public extension UINavigationController {

    func xx_push(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    func xx_pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }

    func xx_transparent(with tintColor: UIColor = .white) {
        navigationBar.xx_isTranslucent(true)
            .xx_backgroundImage(UIImage())
            .xx_backgroundColor(.clear)
            .xx_shadowImage(UIImage())
            .xx_tintColor(tintColor)
            .xx_barTintColor(.clear)
            .xx_titleTextAttributes([.foregroundColor: tintColor])
    }

    func xx_fullScreenBackGesture(_ isOpen: Bool) {
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
                ges.xx_remove()
            }
        }
    }
}

public extension UINavigationController {
    @discardableResult
    func xx_delegate(_ delegate: UINavigationControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func xx_setNavigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        self.setNavigationBarHidden(hidden, animated: animated)
        return self
    }
}
