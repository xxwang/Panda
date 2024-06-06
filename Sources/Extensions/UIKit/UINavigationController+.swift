import UIKit


public extension UINavigationController {

    func sk_push(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    func sk_pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }

    func sk_transparent(with tintColor: UIColor = .white) {
        navigationBar.sk_isTranslucent(true)
            .sk_backgroundImage(UIImage())
            .sk_backgroundColor(.clear)
            .sk_shadowImage(UIImage())
            .sk_tintColor(tintColor)
            .sk_barTintColor(.clear)
            .sk_titleTextAttributes([.foregroundColor: tintColor])
    }

    func sk_fullScreenBackGesture(_ isOpen: Bool) {
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
                ges.sk_remove()
            }
        }
    }
}

public extension UINavigationController {
    @discardableResult
    func sk_delegate(_ delegate: UINavigationControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func sk_setNavigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        self.setNavigationBarHidden(hidden, animated: animated)
        return self
    }
}
