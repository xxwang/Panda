//
//  UINavigationItem+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 方法
public extension UINavigationItem {
    /// 设置导航栏`titleView`为图片
    /// - Parameters:
    ///   - image: 要设置的图片
    ///   - size: 大小
    func titleView(with image: UIImage, size: CGSize = CGSize(width: 100, height: 30)) {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: size))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        titleView = imageView
    }
}

// MARK: - Defaultable
extension UINavigationItem: Defaultable {}
public extension UINavigationItem {
    typealias Associatedtype = UINavigationItem

    class func `default`() -> UINavigationItem {
        let item = UINavigationItem()
        return item
    }
}

// MARK: - 链式语法
public extension UINavigationItem {
    /// 设置大导航显示模型
    /// - Parameter mode:模型
    /// - Returns:`Self`
    @discardableResult
    func pd_largeTitleDisplayMode(_ mode: LargeTitleDisplayMode) -> Self {
        largeTitleDisplayMode = mode
        return self
    }

    /// 设置导航标题
    /// - Parameter title:标题
    /// - Returns:`Self`
    @discardableResult
    func pd_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置标题栏自定义标题
    /// - Parameter view:自定义标题view
    /// - Returns:`Self`
    @discardableResult
    func pd_titleView(_ view: UIView?) -> Self {
        titleView = view
        return self
    }
}
