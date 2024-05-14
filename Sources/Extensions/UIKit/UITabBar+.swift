
import UIKit

public extension UITabBar {
    typealias Associatedtype = UITabBar

    override class func `default`() -> Associatedtype {
        let tabBar = UITabBar()
        return tabBar
    }
}


public extension UITabBar {

    @discardableResult
    func xx_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    @discardableResult
    func xx_titleFont(_ font: UIFont, state: UIControl.State) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            if state == .normal {
                var attributeds = appearance.stackedLayoutAppearance.normal.titleTextAttributes
                attributeds[.font] = font
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributeds
            } else if state == .selected {
                var attributeds = appearance.stackedLayoutAppearance.selected.titleTextAttributes
                attributeds[.font] = font
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributeds
            }
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        } else {
            var attributeds = UITabBarItem.appearance().titleTextAttributes(for: state) ?? [:]
            attributeds[.font] = font
            UITabBarItem.appearance().setTitleTextAttributes(attributeds, for: state)
        }
        return self
    }

    @discardableResult
    func xx_titleColor(_ color: UIColor, state: UIControl.State) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            if state == .normal {
                var attributeds = appearance.stackedLayoutAppearance.normal.titleTextAttributes
                attributeds[.foregroundColor] = color
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributeds
            } else if state == .selected {
                var attributeds = appearance.stackedLayoutAppearance.selected.titleTextAttributes
                attributeds[.foregroundColor] = color
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributeds
            }
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }

            if state == .normal { self.unselectedItemTintColor = color }
            if state == .selected { self.tintColor = color }
        } else {
            var attributeds = UITabBarItem.appearance().titleTextAttributes(for: state) ?? [:]
            attributeds[.foregroundColor] = color
            UITabBarItem.appearance().setTitleTextAttributes(attributeds, for: state)
        }
        return self
    }

    @discardableResult
    func xx_backgroundColor(with color: UIColor) -> Self {
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
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        } else {
            backgroundImage = image
        }
        return self
    }

    @discardableResult
    func xx_titlePositionAdjustment(_ offset: UIOffset) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
            appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = appearance
            }
        } else {
            UITabBarItem.appearance().titlePositionAdjustment = offset
        }
        return self
    }

    @discardableResult
    func xx_shadowImage(_ image: UIImage) -> Self {
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance
            appearance.shadowImage = image.withRenderingMode(.alwaysOriginal)
            self.standardAppearance = appearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
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
    func xx_selectionIndicatorImage(_ image: UIImage) -> Self {
        selectionIndicatorImage = image
        return self
    }

    @discardableResult
    func xx_corner(corners: UIRectCorner, radius: CGFloat) -> Self {
        xx_roundCorners(radius: radius, corners: corners)
        return self
    }
}
