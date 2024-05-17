import UIKit

public extension UINavigationBar {
    static func xx_fitAllNavigationBar() {
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

    func xx_setupTransparent(with tintColor: UIColor = .white) {
        self.xx_isTranslucent(true)
            .xx_backgroundColor(.clear)
            .xx_backgroundImage(UIImage())
            .xx_barTintColor(.clear)
            .xx_tintColor(tintColor)
            .xx_shadowImage(UIImage())
            .xx_titleTextAttributes([.foregroundColor: tintColor])
    }

    func xx_setupColors(background: UIColor, text: UIColor) {
        self.isTranslucent = false
        self.backgroundColor = background
        self.barTintColor = background
        self.setBackgroundImage(UIImage(), for: .default)
        self.tintColor = text
        self.titleTextAttributes = [.foregroundColor: text]
    }

    func xx_setupStatusBarBackgroundColor(with color: UIColor) {
        guard self.xx_statusBar == nil else {
            self.xx_statusBar?.backgroundColor = color
            return
        }

        let statusBar = UIView(frame: CGRect(
            x: 0,
            y: -sizer.nav.statusHeight,
            width: sizer.screen.width,
            height: sizer.nav.statusHeight
        )).xx_add2(self)
        statusBar.backgroundColor = .clear
        self.xx_statusBar = statusBar
    }

    func xx_clearStatusBar() {
        self.xx_statusBar?.removeFromSuperview()
        self.xx_statusBar = nil
    }
}

private class AssociateKeys {
    static var StatusBarKey = UnsafeRawPointer(bitPattern: ("UINavigationBar" + "StatusBarKey").hashValue)
}

private extension UINavigationBar {
    var xx_statusBar: UIView? {
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
    func xx_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    func xx_prefersLargeTitles(_ large: Bool) -> Self {
        prefersLargeTitles = large
        return self
    }

    @discardableResult
    func xx_titleFont(_ font: UIFont) -> Self {
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
    func xx_largeTitleFont(_ font: UIFont) -> Self {
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
    func xx_titleColor(_ color: UIColor) -> Self {
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
    func xx_largeTitleColor(_ color: UIColor) -> Self {
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
    func xx_barTintColor(_ color: UIColor) -> Self {
        barTintColor = color
        return self
    }

    @discardableResult
    override func xx_tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }

    @discardableResult
    override func xx_backgroundColor(_ color: UIColor) -> Self {
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
    func xx_backgroundImage(_ image: UIImage) -> Self {
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
    func xx_shadowImage(_ image: UIImage) -> Self {
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
    func xx_scrollEdgeAppearance() -> Self {
        if #available(iOS 13.0, *) {
            let appearance = standardAppearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        }
        return self
    }

    @discardableResult
    func xx_titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        titleTextAttributes = attributes
        return self
    }
}
