
import UIKit

public extension UITabBarController {

    static var xx_selectIndex: Int {
        get { return self.xx_findTabBarController()?.selectedIndex ?? 0 }
        set { self.xx_findTabBarController()?.selectedIndex = newValue }
    }
}

public extension UITabBarController {
    static func xx_findTabBarController() -> UITabBarController? {
        guard let currentTabBarController = UIWindow.xx_main?.rootViewController as? UITabBarController else {
            return nil
        }
        return currentTabBarController
    }
}

public extension UITabBarController {
    typealias Associatedtype = UITabBarController

    override class func `default`() -> Associatedtype {
        let tabBarController = UITabBarController()
        return tabBarController
    }
}

public extension UITabBarController {

    @discardableResult
    func xx_delegate(_ delegate: UITabBarControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func xx_viewControllers(_ viewControllers: [UIViewController]?) -> Self {
        self.viewControllers = viewControllers
        return self
    }

    @discardableResult
    func xx_setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool = false) -> Self {
        self.setViewControllers(viewControllers, animated: animated)
        return self
    }

    @discardableResult
    func xx_selectedIndex(_ index: Int) -> Self {
        self.selectedIndex = index
        return self
    }
}