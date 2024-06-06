import UIKit

public extension UINavigationBar {
    static func sk_fitAllNavigationBar() {
        if #available(iOS 15.0, *) {
//            let navigationBarAppearance = UINavigationBarAppearance()
//            navigationBarAppearance.configureWithOpaqueBackground()
//            navigationBarAppearance.shadowColor = UIColor.clear
//            navigationBarAppearance.backgroundEffect = nil
//            navigationBarAppearance.titleTextAttributes = [
//                .foregroundColor: UIColor.black,
//                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
//            ]
//            UINavigationBar.appearance().isTranslucent = false
//            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let navBarAppearance = UINavigationBarAppearance()
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
    }
}

public extension UINavigationBar {

    func sk_setupTransparent(with tintColor: UIColor = .white) {
        self.sk_isTranslucent(true)
            .sk_backgroundColor(.clear)
            .sk_backgroundImage(UIImage())
            .sk_barTintColor(.clear)
            .sk_tintColor(tintColor)
            .sk_shadowImage(UIImage())
            .sk_titleTextAttributes([.foregroundColor: tintColor])
    }

    func sk_setupColors(background: UIColor, text: UIColor) {
        self.isTranslucent = false
        self.backgroundColor = background
        self.barTintColor = background
        self.setBackgroundImage(UIImage(), for: .default)
        self.tintColor = text
        self.titleTextAttributes = [.foregroundColor: text]
    }

    func sk_setupStatusBarBackgroundColor(with color: UIColor) {
        guard self.sk_statusBar == nil else {
            self.sk_statusBar?.backgroundColor = color
            return
        }

        let statusBar = UIView(frame: CGRect(
            x: 0,
            y: -sizer.nav.statusHeight,
            width: sizer.screen.width,
            height: sizer.nav.statusHeight
        )).sk_add2(self)
        statusBar.backgroundColor = .clear
        self.sk_statusBar = statusBar
    }

    func sk_clearStatusBar() {
        self.sk_statusBar?.removeFromSuperview()
        self.sk_statusBar = nil
    }
}

private class AssociateKeys {
    static var StatusBarKey = UnsafeRawPointer(bitPattern: ("UINavigationBar" + "StatusBarKey").hashValue)
}

private extension UINavigationBar {
    var sk_statusBar: UIView? {
        get { AssociatedObject.get(self, &AssociateKeys.StatusBarKey) as? UIView }
        set { AssociatedObject.set(self, &AssociateKeys.StatusBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public extension UINavigationBar {
    typealias Associatedtype = UINavigationBar

    override class func `default`() -> Associatedtype {
        let slider = UINavigationBar()
        return slider
    }
}

public extension UINavigationBar {

    @discardableResult
    func sk_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    func sk_prefersLargeTitles(_ large: Bool) -> Self {
        prefersLargeTitles = large
        return self
    }

    @discardableResult
    func sk_titleFont(_ font: UIFont) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.titleTextAttributes
            attributeds[.font] = font
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = titleTextAttributes ?? [:]
            attributeds[.font] = font
            titleTextAttributes = attributeds
        }
        return self
    }

    @discardableResult
    func sk_largeTitleFont(_ font: UIFont) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.largeTitleTextAttributes
            attributeds[.font] = font
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = largeTitleTextAttributes ?? [:]
            attributeds[.font] = font
            titleTextAttributes = attributeds
        }
        return self
    }

    @discardableResult
    func sk_titleColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.titleTextAttributes
            attributeds[.foregroundColor] = color
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = titleTextAttributes ?? [:]
            attributeds[.foregroundColor] = color
            titleTextAttributes = attributeds
        }
        return self
    }

    @discardableResult
    func sk_largeTitleColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            var attributeds = appearance.largeTitleTextAttributes
            attributeds[.foregroundColor] = color
            appearance.titleTextAttributes = attributeds
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            var attributeds = largeTitleTextAttributes ?? [:]
            attributeds[.foregroundColor] = color
            titleTextAttributes = attributeds
        }
        return self
    }

    @discardableResult
    func sk_barTintColor(_ color: UIColor) -> Self {
        barTintColor = color
        return self
    }

    @discardableResult
    override func sk_tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }

    @discardableResult
    override func sk_backgroundColor(_ color: UIColor) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.backgroundColor = color
            appearance.backgroundEffect = nil
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            backgroundColor = color
            barTintColor = color
        }
        return self
    }

    @discardableResult
    func sk_backgroundImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.backgroundImage = image
            appearance.backgroundEffect = nil
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            setBackgroundImage(image, for: .default)
        }
        return self
    }

    @discardableResult
    func sk_shadowImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.shadowImage = image.withRenderingMode(.alwaysOriginal)
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            shadowImage = image.withRenderingMode(.alwaysOriginal)
        }
        return self
    }

    @discardableResult
    func sk_scrollEdgeAppearance() -> Self {
        if #available(iOS 13.0, *) {
            let appearance = standardAppearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        }
        return self
    }

    @discardableResult
    func sk_titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        titleTextAttributes = attributes
        return self
    }
}
