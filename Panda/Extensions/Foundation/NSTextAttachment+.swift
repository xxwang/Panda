//
//  NSTextAttachment+.swift
//
//
//  Created by xxwang on 2023/5/26.
//

import UIKit

// MARK: - 方法
public extension NSTextAttachment {
    /// 使用`NSTextAttachment`创建`NSAttributedString`
    /// - Returns: `NSAttributedString`
    func toAttributedString() -> NSAttributedString {
        NSAttributedString(attachment: self)
    }
}

// MARK: - Defaultable
extension NSTextAttachment: Defaultable {}
public extension NSTextAttachment {
    typealias Associatedtype = NSTextAttachment
    static func `default`() -> Associatedtype {
        NSTextAttachment()
    }
}

// MARK: - 链式语法
public extension NSTextAttachment {
    /// 设置附件图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func pd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置附件边界
    /// - Parameter bounds: 边界
    /// - Returns: `Self`
    @discardableResult
    func pd_bounds(_ bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
}
