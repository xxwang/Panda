//
//  UITextField+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - Defaultable
public extension UITextField {
    typealias Associatedtype = UITextField

    override class func `default`() -> Associatedtype {
        let textField = UITextField()
        return textField
    }
}

// MARK: - 链式语法
public extension UITextField {
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

    /// 设置占位符
    /// - Parameter placeholder:占位符文字
    /// - Returns:`Self`
    @discardableResult
    func pd_placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }

    /// 设置富文本占位符
    /// - Parameter attributedPlaceholder:富文本占位符
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedPlaceholder(_ attributedPlaceholder: NSAttributedString) -> Self {
        self.attributedPlaceholder = attributedPlaceholder
        return self
    }

    /// 设置占位符颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    func pd_placeholderColor(_ color: UIColor) -> Self {
        if let holder = attributedPlaceholder, !holder.string.isEmpty {
            var attributes = holder.attributes()
            attributes[.foregroundColor] = color
            attributedPlaceholder = holder.toMutable().pd_addAttributes(attributes, for: holder.fullNSRange())
        } else if let holder = placeholder {
            let attributedPlaceholder = NSMutableAttributedString(string: holder)
            attributedPlaceholder
                .pd_addAttributes([.foregroundColor: color], for: holder.fullNSRange())
            self.attributedPlaceholder = attributedPlaceholder
        }
        return self
    }

    /// 设置占位符字体
    /// - Parameter font:字体
    /// - Returns:`Self`
    func pd_placeholderFont(_ font: UIFont) -> Self {
        if let holder = attributedPlaceholder, !holder.string.isEmpty {
            var attributes = holder.attributes()
            attributes[.font] = font
            attributedPlaceholder = holder.toMutable().pd_addAttributes(attributes, for: holder.string.fullNSRange())
        } else if let holder = placeholder {
            let attributedPlaceholder = NSMutableAttributedString(string: holder)
            attributedPlaceholder
                .pd_addAttributes([.font: font], for: holder.fullNSRange())
            self.attributedPlaceholder = attributedPlaceholder
        }
        return self
    }

    /// 设置占位符的字体及颜色
    /// - Parameters:
    ///   - color:颜色
    ///   - font:字体
    /// - Returns:`Self`
    func pd_placeholder(_ color: UIColor, font: UIFont) -> Self {
        if let holder = attributedPlaceholder, !holder.string.isEmpty {
            var attributes = holder.attributes()
            attributes[.font] = font
            attributes[.foregroundColor] = color
            attributedPlaceholder = holder.toMutable().pd_addAttributes(attributes, for: holder.fullNSRange())
        } else if let holder = placeholder {
            let attributedPlaceholder = NSMutableAttributedString(string: holder)
            attributedPlaceholder
                .pd_addAttributes([.font: font, .foregroundColor: color], for: holder.fullNSRange())
            self.attributedPlaceholder = attributedPlaceholder
        }
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
    /// - Parameter textColor:文本颜色
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
    func pd_delegate(_ delegate: UITextFieldDelegate) -> Self {
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

    /// 设置左侧`view`模式
    /// - Parameter mode:模式
    /// - Returns:`Self`
    @discardableResult
    func pd_leftViewMode(_ mode: ViewMode) -> Self {
        leftViewMode = mode
        return self
    }

    /// 设置右侧`view`模式
    /// - Parameter mode:模式
    /// - Returns:`Self`
    @discardableResult
    func pd_rightViewMode(_ mode: ViewMode) -> Self {
        rightViewMode = mode
        return self
    }

    /// 添加左边的内边距
    /// - Parameter padding:边距
    /// - Returns:`Self`
    @discardableResult
    func pd_leftPadding(_ padding: CGFloat) -> Self {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: padding, height: frame.height)
        self.leftView = leftView
        leftViewMode = .always
        return self
    }

    /// 添加右边的内边距
    /// - Parameter padding:边距
    /// - Returns:`Self`
    @discardableResult
    func pd_rightPadding(_ padding: CGFloat) -> Self {
        let rightView = UIView()
        rightView.frame = CGRect(x: 0, y: 0, width: padding, height: frame.height)
        self.rightView = rightView
        rightViewMode = .always
        return self
    }

    /// 添加左边的`view`
    /// - Parameters:
    ///   - view:要添加的view
    ///   - containerRect:容器大小
    ///   - contentRect:内容大小
    /// - Returns:`Self`
    @discardableResult
    func pd_leftView(_ view: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        // 容器
        let containerView = UIView()
        containerView.frame = containerRect

        // 内容
        if let contentRect { view?.frame = contentRect }

        // 添加内容
        if let view { containerView.addSubview(view) }

        leftView = leftView
        leftViewMode = .always

        return self
    }

    /// 添加右边的`view`
    /// - Parameters:
    ///   - view:要添加的view
    ///   - containerRect:容器大小
    ///   - contentRect:内容大小
    /// - Returns:`Self`
    @discardableResult
    func pd_rightView(_ view: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        // 容器
        let containerView = UIView()
        containerView.frame = containerRect

        // 内容
        if let contentRect { view?.frame = contentRect }

        // 添加内容
        if let view { containerView.addSubview(view) }
        rightView = containerView
        rightViewMode = .always

        return self
    }
}
