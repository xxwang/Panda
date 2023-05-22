//
//  UITextView+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - Defaultable
public extension UITextView {
    typealias Associatedtype = UITextView

    override class func `default`() -> Associatedtype {
        let textView = UITextView()
        return textView
    }
}

// MARK: - 链式语法
public extension UITextView {
    /// 设置文字
    /// - Parameter text:文字
    /// - Returns:`Self`
    @discardableResult
    func pd_text(_ text: String) -> Self {
        self.text = text
        return self
    }

    /// 设置富文本
    /// - Parameter attributedText:富文本文字
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }

    /// 设置文本格式
    /// - Parameter textAlignment:文本格式
    /// - Returns:`Self`
    @discardableResult
    func pd_textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color:文本颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }

    /// 设置文本字体
    /// - Parameter font:字体
    /// - Returns:`Self`
    @discardableResult
    func pd_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    /// 设置系统字体
    /// - Parameter fontSize:字体大小
    /// - Returns:`Self`
    @discardableResult
    func pd_systemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.systemFont(ofSize: fontSize)
        return self
    }

    /// 设置代理
    /// - Parameter delegate:代理
    /// - Returns:`Self`
    @discardableResult
    func pd_delegate(_ delegate: UITextViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置键盘类型
    /// - Parameter keyboardType:键盘样式
    /// - Returns:`Self`
    @discardableResult
    func pd_keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }

    /// 设置键盘`return`键类型
    /// - Parameter returnKeyType:按钮样式
    /// - Returns:`Self`
    @discardableResult
    func pd_returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.returnKeyType = returnKeyType
        return self
    }

    /// 设置`Return`键是否有内容才可以点击
    /// - Parameter enable:是否开启
    /// - Returns:`Self`
    func pd_enablesReturnKeyAutomatically(_ enable: Bool) -> Self {
        enablesReturnKeyAutomatically = enable
        return self
    }

    /// 设置占位符
    /// - Parameter placeholder:占位符文字
    /// - Returns:`Self`
    func pd_placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }

    /// 设置占位符颜色
    /// - Parameter textColor:文字颜色
    /// - Returns:`Self`
    func pd_placeholderColor(_ textColor: UIColor) -> Self {
        placeholderColor = textColor
        return self
    }

    /// 设置占位符字体
    /// - Parameter font:文字字体
    /// - Returns:`Self`
    func pd_placeholderFont(_ font: UIFont) -> Self {
        placeholderFont = font
        return self
    }

    /// 设置占位符`Origin`
    /// - Parameter origin:`CGPoint`
    /// - Returns:`Self`
    func pd_placeholderOrigin(_ origin: CGPoint) -> Self {
        placeholderOrigin = origin
        return self
    }
}
