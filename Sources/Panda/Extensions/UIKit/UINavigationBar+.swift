//
//  UINavigationBar+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

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
    func pd_tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }

    /// 设置背景颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_backgroundColor(_ color: UIColor) -> Self {
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
    func pd_titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        titleTextAttributes = attributes
        return self
    }
}
