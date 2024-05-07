import UIKit

public extension UINavigationBar {
    static func pd_fitAllNavigationBar() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.shadowColor = UIColor.clear
            navigationBarAppearance.backgroundEffect = nil
            navigationBarAppearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
            ]
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().standardAppearance
        }
    }
}

public extension UINavigationBar {

    func pd_setupTransparent(with tintColor: UIColor = .white) {
        self.pd_isTranslucent(true)
            .pd_backgroundColor(.clear)
            .pd_backgroundImage(UIImage())
            .pd_barTintColor(.clear)
            .pd_tintColor(tintColor)
            .pd_shadowImage(UIImage())
            .pd_titleTextAttributes([.foregroundColor: tintColor])
    }

    func pd_setupColors(background: UIColor, text: UIColor) {
        self.isTranslucent = false
        self.backgroundColor = background
        self.barTintColor = background
        self.setBackgroundImage(UIImage(), for: .default)
        self.tintColor = text
        self.titleTextAttributes = [.foregroundColor: text]
    }

    func pd_setupStatusBarBackgroundColor(with color: UIColor) {
        guard self.pd_statusBar == nil else {
            self.pd_statusBar?.backgroundColor = color
            return
        }

        let statusBar = UIView(frame: CGRect(
            x: 0,
            y: -sizer.nav.statusHeight,
            width: sizer.screen.width,
            height: sizer.nav.statusHeight
        )).pd_add2(self)
        statusBar.backgroundColor = .clear
        self.pd_statusBar = statusBar
    }

    func pd_clearStatusBar() {
        self.pd_statusBar?.removeFromSuperview()
        self.pd_statusBar = nil
    }
}

private class AssociateKeys {
    static var StatusBarKey = UnsafeRawPointer(bitPattern: ("UINavigationBar" + "StatusBarKey").hashValue)
}

private extension UINavigationBar {
    var pd_statusBar: UIView? {
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
    func pd_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    func pd_prefersLargeTitles(_ large: Bool) -> Self {
        prefersLargeTitles = large
        return self
    }

    @discardableResult
    func pd_titleFont(_ font: UIFont) -> Self {
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
    func pd_largeTitleFont(_ font: UIFont) -> Self {
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
    func pd_titleColor(_ color: UIColor) -> Self {
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
    func pd_largeTitleColor(_ color: UIColor) -> Self {
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
    func pd_barTintColor(_ color: UIColor) -> Self {
        barTintColor = color
        return self
    }

    @discardableResult
    override func pd_tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }

    @discardableResult
    override func pd_backgroundColor(_ color: UIColor) -> Self {
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
    func pd_backgroundImage(_ image: UIImage) -> Self {
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
    func pd_shadowImage(_ image: UIImage) -> Self {
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
    func pd_scrollEdgeAppearance() -> Self {
        if #available(iOS 13.0, *) {
            let appearance = standardAppearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        }
        return self
    }

    @discardableResult
    func pd_titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        titleTextAttributes = attributes
        return self
    }
}
