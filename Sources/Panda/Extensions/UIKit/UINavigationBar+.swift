//
//  UINavigationBar+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

public extension UINavigationBar {
    static func fitAllNavigationBar() {
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

// MARK: - 方法
public extension UINavigationBar {
    /// 设置导航条为透明
    /// - Parameter tintColor:`tintColor`
    func setupTransparent(with tintColor: UIColor = .white) {
        pd_isTranslucent(true)
            .pd_backgroundColor(.clear)
            .pd_backgroundImage(UIImage())
            .pd_barTintColor(.clear)
            .pd_tintColor(tintColor)
            .pd_shadowImage(UIImage())
            .pd_titleTextAttributes([.foregroundColor: tintColor])
    }

    /// 设置导航条背景和文字颜色
    /// - Parameters:
    ///   - background:背景颜色
    ///   - text:文字颜色
    func setupColors(background: UIColor, text: UIColor) {
        isTranslucent = false
        backgroundColor = background
        barTintColor = background
        setBackgroundImage(UIImage(), for: .default)
        tintColor = text
        titleTextAttributes = [.foregroundColor: text]
    }

    /// 修改`statusBar`的背景颜色
    /// - Parameter color:要设置的颜色
    func setupStatusBarBackgroundColor(with color: UIColor) {
        guard self.statusBar == nil else {
            self.statusBar?.backgroundColor = color
            return
        }

        let statusBar = UIView(frame: CGRect(
            x: 0,
            y: -SizeManager.statusBarHeight,
            width: SizeManager.screenWidth,
            height: SizeManager.screenHeight
        )).pd_add2(self)
        statusBar.backgroundColor = .clear
        self.statusBar = statusBar
    }

    /// 移除`statusBar`
    func clearStatusBar() {
        statusBar?.removeFromSuperview()
        statusBar = nil
    }
}

// MARK: - 关联键
private class AssociateKeys {
    static var StatusBarKey = "UINavigationBar" + "StatusBarKey"
}

// MARK: - 关联属性
private extension UINavigationBar {
    /// 通过 Runtime 的属性关联添加自定义 View
    var statusBar: UIView? {
        get { objc_getAssociatedObject(self, &AssociateKeys.StatusBarKey) as? UIView }
        set { objc_setAssociatedObject(self, &AssociateKeys.StatusBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

// MARK: - Defaultable
public extension UINavigationBar {
    typealias Associatedtype = UINavigationBar

    override class func `default`() -> Associatedtype {
        let slider = UINavigationBar()
        return slider
    }
}

// MARK: - 链式语法
public extension UINavigationBar {
    /// 是否半透明
    /// - Parameter isTranslucent:是否半透明
    /// - Returns:`Self`
    @discardableResult
    func pd_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    /// 设置是否大导航
    /// - Parameter large:是否大导航
    /// - Returns:`Self`
    func pd_prefersLargeTitles(_ large: Bool) -> Self {
        prefersLargeTitles = large
        return self
    }

    /// 设置标题字体
    /// - Parameters:
    ///   - font:字体
    ///   - state:状态
    /// - Returns:`Self`
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

    /// 设置大标题字体
    /// - Parameters:
    ///   - font:字体
    ///   - state:状态
    /// - Returns:`Self`
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

    /// 设置标题颜色
    /// - Parameters:
    ///   - color:颜色
    ///   - state:状态
    /// - Returns:`Self`
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

    /// 设置大标题颜色
    /// - Parameters:
    ///   - color:颜色
    ///   - state:状态
    /// - Returns:`Self`
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

    /// 设置`barTintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func pd_barTintColor(_ color: UIColor) -> Self {
        barTintColor = color
        return self
    }

    /// 设置`tintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    override func pd_tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }

    /// 设置背景颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
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

    /// 设置背景图片
    /// - Parameter image:图片
    /// - Returns:`Self`
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

    /// 设置阴影图片
    /// - Parameter imageName:图片
    /// - Returns:`Self`
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

    /// 设置当页面中有滚动时`UITabBar`的外观与`standardAppearance`一致
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollEdgeAppearance() -> Self {
        if #available(iOS 13.0, *) {
            let appearance = standardAppearance
            if #available(iOS 15.0, *) { self.scrollEdgeAppearance = appearance }
        }
        return self
    }

    /// 设置标题的的属性
    /// - Parameter attributes: 富文本属性
    /// - Returns: `Self`
    @discardableResult
    func pd_titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        titleTextAttributes = attributes
        return self
    }
}
