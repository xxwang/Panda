//
//  NSMutableParagraphStyle+.swift
//  
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

//MARK: - Defaultable
extension NSMutableParagraphStyle: Defaultable {}
public extension NSMutableParagraphStyle {
    typealias Associatedtype = NSMutableParagraphStyle

    @objc class func `default`() -> Associatedtype {
        let style = NSMutableParagraphStyle()
        style.hyphenationFactor = 1.0
        style.firstLineHeadIndent = 0.0
        style.paragraphSpacingBefore = 0.0
        style.headIndent = 0
        style.tailIndent = 0
        return style
    }
}

// MARK: - 链式语法
public extension NSMutableParagraphStyle {
    /// 设置对齐方式
    /// - Parameter alignment:对方方式
    /// - Returns:`Self`
    @discardableResult
    func pd_textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }

    /// 设置换行方式
    /// - Parameter lineBreakMode:换行方式
    /// - Returns:`Self`
    @discardableResult
    func pd_lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }

    /// 设置行间距
    /// - Parameter lineSpacing:行间距
    /// - Returns:`Self`
    @discardableResult
    func pd_lineSpacing(_ lineSpacing: CGFloat) -> Self {
        self.lineSpacing = lineSpacing
        return self
    }

    /// 设置段落间距
    /// - Parameter paragraphSpacing:段落间距
    /// - Returns:`Self`
    @discardableResult
    func pd_paragraphSpacing(_ paragraphSpacing: CGFloat) -> Self {
        self.paragraphSpacing = paragraphSpacing
        return self
    }
}
