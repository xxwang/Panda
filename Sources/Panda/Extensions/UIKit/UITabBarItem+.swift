//
//  UITabBarItem+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - Defaultable
extension UITabBarItem: Defaultable {}
public extension UITabBarItem {
    typealias Associatedtype = UITabBarItem

    class func `default`() -> Associatedtype {
        let item = UITabBarItem()
        return item
    }
}

// MARK: - 链式语法
public extension UITabBarItem {
    /// 设置标题
    /// - Parameter title:标题
    /// - Returns:`Self`
    @discardableResult
    func pd_title(_ title: String) -> Self {
        self.title = title
        return self
    }

    /// 设置默认图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func pd_image(_ image: UIImage) -> Self {
        self.image = image.withRenderingMode(.alwaysOriginal)
        return self
    }

    /// 设置选中图片
    /// - Parameter image:图片
    /// - Returns:`Self`
    @discardableResult
    func pd_selectedImage(_ image: UIImage) -> Self {
        selectedImage = image
        return self
    }

    /// 设置`badgeColor`颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_badgeColor(_ color: UIColor) -> Self {
        badgeColor = color
        return self
    }

    /// 设置`badgeValue`值
    /// - Parameter value:值
    /// - Returns:`Self`
    @discardableResult
    func pd_badgeValue(_ value: String) -> Self {
        badgeValue = value
        return self
    }
}
