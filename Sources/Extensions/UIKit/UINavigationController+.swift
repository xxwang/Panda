import UIKit


public extension UINavigationController {

    func pd_push(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    func pd_pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }

    func pd_transparent(with tintColor: UIColor = .white) {
        navigationBar.pd_isTranslucent(true)
            .pd_backgroundImage(UIImage())
            .pd_backgroundColor(.clear)
            .pd_shadowImage(UIImage())
            .pd_tintColor(tintColor)
            .pd_barTintColor(.clear)
            .pd_titleTextAttributes([.foregroundColor: tintColor])
    }

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

public extension UINavigationController {
    @discardableResult
    func pd_delegate(_ delegate: UINavigationControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func pd_setNavigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        self.setNavigationBarHidden(hidden, animated: animated)
        return self
    }
}
