import UIKit

public extension UIViewController {
    var xx_isVisible: Bool {
        return self.isViewLoaded && self.view.window != nil
    }
}

public extension UIViewController {

    func xx_addChildViewController(_ child: UIViewController, to containerView: UIView) {
        self.addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

public extension UIViewController {

    func xx_present(viewController: UIViewController, fullScreen: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        if fullScreen {
            viewController.modalPresentationStyle = .fullScreen
        }
        present(viewController, animated: animated, completion: completion)
    }

    func xx_push(viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func xx_popLast(thenPush viewController: UIViewController, animated: Bool = true) {
        guard let navigationController else { return }

        var viewControllers = navigationController.viewControllers
        guard viewControllers.count >= 1 else { return }

        viewControllers.removeLast()
        viewControllers.append(viewController)
        navigationController.setViewControllers(viewControllers, animated: animated)
    }

    func xx_pop(count: Int, thenPush viewController: UIViewController, animated: Bool = true) {
        guard let navigationController else { return }
        if count < 1 { return }

        let navViewControllers = navigationController.viewControllers
        if count >= navViewControllers.count {
            if let firstViewController = navViewControllers.first {
                navigationController.setViewControllers([firstViewController, viewController], animated: animated)
            }
            return
        }

        var vcs = navViewControllers[0 ... (navViewControllers.count - count - 1)]
        vcs.append(viewController)
        viewController.hidesBottomBarWhenPushed = vcs.count > 0
        navigationController.setViewControllers(Array(vcs), animated: animated)
    }

    func xx_previousViewController() -> UIViewController? {
        guard let nav = navigationController else { return nil }
        if nav.viewControllers.count <= 1 { return nil }
        guard let index = nav.viewControllers.firstIndex(of: self), index > 0 else { return nil }
        return nav.viewControllers[index - 1]
    }
}

public extension UIViewController {

    func xx_pop2rootViewController(_ animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }

    func xx_popViewController(_ animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }

    func xx_pop2(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.popToViewController(viewController, animated: animated)
    }

    @discardableResult
    func xx_pop2(aClass: AnyClass, animated: Bool = false) -> Bool {
        func pop2(nav: UINavigationController?) -> Bool {
            guard let nav else { return false }

            for viewController in nav.viewControllers.reversed() {
                if viewController.isMember(of: aClass) {
                    nav.popToViewController(viewController, animated: animated)
                    return true
                }
            }
            return false
        }

        if let nav = self as? UINavigationController {
            return pop2(nav: nav)
        } else {
            return pop2(nav: navigationController)
        }
    }

    func xx_pop(count: Int, animated: Bool = false) {
        guard let navigationController else { return }
        guard count >= 1 else { return }

        let navViewControllers = navigationController.viewControllers

        if count >= navViewControllers.count {
            navigationController.popToRootViewController(animated: animated)
            return
        }

        let viewController = navViewControllers[navViewControllers.count - count - 1]
        navigationController.popToViewController(viewController, animated: animated)
    }

    func xx_dismissViewController(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }

    func xx_closeViewController(_ animated: Bool = true) {
        guard let nav = navigationController else {
            self.dismiss(animated: animated, completion: nil)
            return
        }

        if nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
        } else if let _ = nav.presentingViewController {
            nav.dismiss(animated: animated, completion: nil)
        }
    }
}

public extension UIViewController {

    func xx_presentPopover(
        _ contentViewController: UIViewController,
        arrowPoint: CGPoint,
        contentSize: CGSize? = nil,
        delegate: UIPopoverPresentationControllerDelegate? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {

        contentViewController.modalPresentationStyle = .popover
        if let contentSize {
            contentViewController.preferredContentSize = contentSize
        }

        if let popoverPresentationController = contentViewController.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(origin: arrowPoint, size: .zero)
            popoverPresentationController.delegate = delegate
        }

        self.present(contentViewController, animated: animated, completion: completion)
    }
}

public extension UIViewController {

    class func xx_instantiateViewController(from storyboard: String = "Main", bundle: Bundle? = nil, identifier: String? = nil) -> Self {
        let identifier = identifier ?? String(describing: self)
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        let instantiateViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self
        guard let instantiateViewController else {
            preconditionFailure(
                "Unable to instantiate view controller with identifier \(identifier) as type \(type(of: self))")
        }
        return instantiateViewController
    }
}

@objc extension UIViewController {

    override public class func xx_initializeMethod() {
        super.xx_initializeMethod()

        if self == UIViewController.self {
            let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
            DispatchQueue.xx_once(token: onceToken) {
  
                let oriSel = #selector(viewDidLoad)
                let repSel = #selector(xx_hook_viewDidLoad)
                _ = self.xx_hookInstanceMethod(of: oriSel, with: repSel)

         
                let oriSel1 = #selector(viewWillAppear(_:))
                let repSel1 = #selector(xx_hook_viewWillAppear(animated:))
                _ = self.xx_hookInstanceMethod(of: oriSel1, with: repSel1)

      
                let oriSel2 = #selector(viewWillDisappear(_:))
                let repSel2 = #selector(xx_hook_viewWillDisappear(animated:))
                _ = self.xx_hookInstanceMethod(of: oriSel2, with: repSel2)

         
                let oriSelPresent = #selector(present(_:animated:completion:))
                let repSelPresent = #selector(xx_hook_present(_:animated:completion:))
                _ = self.xx_hookInstanceMethod(of: oriSelPresent, with: repSelPresent)
            }
        } else if self == UINavigationController.self {
            let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
            DispatchQueue.xx_once(token: onceToken) {
           
                let oriSel = #selector(UINavigationController.pushViewController(_:animated:))
                let repSel = #selector(UINavigationController.xx_hook_pushViewController(_:animated:))
                _ = self.xx_hookInstanceMethod(of: oriSel, with: repSel)
            }
        }
    }

    private func xx_hook_viewDidLoad(animated: Bool) {
        self.xx_hook_viewDidLoad(animated: animated)
    }

    private func xx_hook_viewWillAppear(animated: Bool) {
        self.xx_hook_viewWillAppear(animated: animated)
    }

    private func xx_hook_viewWillDisappear(animated: Bool) {
        self.xx_hook_viewWillDisappear(animated: animated)
    }

    private func xx_hook_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent.presentationController == nil {
            viewControllerToPresent.presentationController?.presentedViewController.dismiss(animated: false, completion: nil)
            print("viewControllerToPresent.presentationController not is nil")
            return
        }
        xx_hook_present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

@objc public extension UINavigationController {

    func xx_hook_pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count <= 1 {
            Logger.info("root vc")
        }

        if !children.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }

        self.xx_hook_pushViewController(viewController, animated: animated)
    }
}


extension UIViewController: Defaultable {}
extension UIViewController {
    public typealias Associatedtype = UIViewController

    @objc open class func `default`() -> Associatedtype {
        let vc = UIViewController()
        return vc
    }
}


public extension UIViewController {

    @discardableResult
    func xx_overrideUserInterfaceStyle(_ userInterfaceStyle: UIUserInterfaceStyle) -> Self {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = userInterfaceStyle
        }
        return self
    }

    @discardableResult
    func xx_backgroundColor(_ backgroundColor: UIColor) -> Self {
        self.view.backgroundColor = backgroundColor
        return self
    }

    @discardableResult
    func xx_automaticallyAdjustsScrollViewInsets(_ automaticallyAdjustsScrollViewInsets: Bool) -> Self {
        if #available(iOS 11, *) {} else {
            self.automaticallyAdjustsScrollViewInsets = automaticallyAdjustsScrollViewInsets
        }
        return self
    }

    @discardableResult
    func xx_modalPresentationStyle(_ style: UIModalPresentationStyle) -> Self {
        self.modalPresentationStyle = style
        return self
    }
}
