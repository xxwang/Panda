//
//  UITextField+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import UIKit

// MARK: - 属性
public extension UITextField {
    /// 内容是否为空
    var pd_isEmpty: Bool {
        return self.text.pd_isNilOrEmpty
    }
}

// MARK: - 方法
public extension UITextField {
    /// 清空内容
    func pd_clear() {
        self.text = ""
        self.attributedText = "".pd_nsMutableAttributedString()
    }

    /// 将工具栏添加到`UITextField`的`inputAccessoryView`
    /// - Parameters:
    ///   - items: 工具栏中的选项
    ///   - height: 工具栏高度
    /// - Returns: `UIToolbar`
    @discardableResult
    func pd_addToolbar(items: [UIBarButtonItem]?, height: CGFloat = 44) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: sizer.screen.width, height: height)))
        toolBar.setItems(items, animated: false)
        inputAccessoryView = toolBar
        return toolBar
    }

    /// 限制字数的输入
    /// 调用位置
    /// `func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool`
    ///
    /// - Parameters:
    ///   - range:范围
    ///   - text:输入的文字
    ///   - maxCharacters:限制字数
    ///   - regex:可输入内容(正则)
    /// - Returns:返回是否可输入
    func pd_inputRestrictions(shouldChangeTextIn range: NSRange, replacementText text: String, maxCharacters: Int, regex: String?) -> Bool {
        guard !text.isEmpty else { return true }
        guard let oldContent = self.text else { return false }

        if let _ = markedTextRange {
            // 有高亮联想中
            guard range.length != 0 else { return oldContent.count + 1 <= maxCharacters }
            // 无高亮
            // 正则的判断
            if let weakRegex = regex, !text.pd_isMatchRegexp(weakRegex) { return false }
            // 联想选中键盘
            let allContent = oldContent.pd_subString(to: range.location) + text
            if allContent.count > maxCharacters {
                let newContent = allContent.pd_subString(to: maxCharacters)
                self.text = newContent
                return false
            }
        } else {
            guard !text.pd_isNineKeyBoard() else { return true }
            // 正则的判断
            if let weakRegex = regex, !text.pd_isMatchRegexp(weakRegex) { return false }
            // 如果数字大于指定位数,不能输入
            guard oldContent.count + text.count <= maxCharacters else { return false }
        }
        return true
    }
}

// MARK: - Defaultable
extension UITextField {
    public typealias Associatedtype = UITextField

    @objc override open class func `default`() -> Associatedtype {
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

    /// 设置字体根据控件大小自动调整
    /// - Parameter adjustsFontSizeToFitWidth: 是否自动适配宽度
    /// - Returns: `Self`
    func pd_adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
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
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftViewMode = .always
        return self
    }

    /// 添加右边的内边距
    /// - Parameter padding:边距
    /// - Returns:`Self`
    @discardableResult
    func pd_rightPadding(_ padding: CGFloat) -> Self {
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        rightViewMode = .always
        return self
    }

    /// 添加左边的`view`
    /// - Parameters:
    ///   - leftView:要添加的view
    ///   - containerRect:容器大小
    ///   - contentRect:内容大小
    /// - Returns:`Self`
    @discardableResult
    func pd_leftView(_ leftView: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        // 容器
        let containerView = UIView(frame: containerRect)
        // 内容
        if let contentRect { leftView?.frame = contentRect }
        // 添加内容
        if let leftView { containerView.addSubview(leftView) }

        self.leftView = containerView
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
    func pd_rightView(_ rightView: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        // 容器
        let containerView = UIView(frame: containerRect)
        if let contentRect {
            leftView?.frame = contentRect
        } else {
            leftView?.frame = leftView?.frame ?? .zero
        }
        // 内容
        if let contentRect { rightView?.frame = contentRect }
        // 添加内容
        if let rightView { containerView.addSubview(rightView) }

        self.rightView = containerView
        rightViewMode = .always

        return self
    }

    /// 添加输入框辅助视图
    /// - Parameters:
    ///   - view:要添加的view
    /// - Returns:`Self`
    @discardableResult
    func pd_inputAccessoryView(_ inputAccessoryView: UIView?) -> Self {
        self.inputAccessoryView = inputAccessoryView
        return self
    }

    /// 添加输入框视图
    /// - Parameters:
    ///   - view:要添加的view
    /// - Returns:`Self`
    @discardableResult
    func pd_inputView(_ inputView: UIView) -> Self {
        self.inputView = inputView
        return self
    }

    /// 将`UIToolbar`添加到`UITextField`的`inputAccessoryView`
    /// - Parameters:
    ///   - toobar: 工具栏
    /// - Returns: `Self`
    @discardableResult
    func pd_toolbar(_ toobar: UIToolbar) -> Self {
        inputAccessoryView = toobar
        return self
    }
}
