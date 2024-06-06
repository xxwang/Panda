
import UIKit


public extension UITextField {

    var sk_isEmpty: Bool {
        return self.text.sk_isNilOrEmpty
    }
}

public extension UITextField {
    func sk_clear() {
        self.text = ""
        self.attributedText = "".sk_nsMutableAttributedString()
    }

    @discardableResult
    func sk_addToolbar(items: [UIBarButtonItem]?, height: CGFloat = 44) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: sizer.screen.width, height: height)))
        toolBar.setItems(items, animated: false)
        inputAccessoryView = toolBar
        return toolBar
    }

    func sk_inputRestrictions(shouldChangeTextIn range: NSRange, replacementText text: String, maxCharacters: Int, regex: String?) -> Bool {
        guard !text.isEmpty else { return true }
        guard let oldContent = self.text else { return false }

        if let _ = markedTextRange {
            guard range.length != 0 else { return oldContent.count + 1 <= maxCharacters }

            if let weakRegex = regex, !text.sk_isMatchRegexp(weakRegex) { return false }
            let allContent = oldContent.sk_subString(to: range.location) + text
            if allContent.count > maxCharacters {
                let newContent = allContent.sk_subString(to: maxCharacters)
                self.text = newContent
                return false
            }
        } else {
            guard !text.sk_isNineKeyBoard() else { return true }
            if let weakRegex = regex, !text.sk_isMatchRegexp(weakRegex) { return false }
            guard oldContent.count + text.count <= maxCharacters else { return false }
        }
        return true
    }
}

extension UITextField {
    public typealias Associatedtype = UITextField

    @objc override open class func `default`() -> Associatedtype {
        let textField = UITextField()
        return textField
    }
}

public extension UITextField {

    @discardableResult
    func sk_text(_ text: String) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    func sk_attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }

    @discardableResult
    func sk_placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }

    @discardableResult
    func sk_attributedPlaceholder(_ attributedPlaceholder: NSAttributedString) -> Self {
        self.attributedPlaceholder = attributedPlaceholder
        return self
    }

    @discardableResult
    func sk_placeholderColor(_ color: UIColor) -> Self {
        if let holder = attributedPlaceholder, !holder.string.isEmpty {
            var attributes = holder.sk_attributes()
            attributes[.foregroundColor] = color
            attributedPlaceholder = holder.sk_mutable().sk_addAttributes(attributes, for: holder.sk_fullNSRange())
        } else if let holder = placeholder {
            let attributedPlaceholder = NSMutableAttributedString(string: holder)
            attributedPlaceholder
                .sk_addAttributes([.foregroundColor: color], for: holder.sk_fullNSRange())
            self.attributedPlaceholder = attributedPlaceholder
        }
        return self
    }

    @discardableResult
    func sk_placeholderFont(_ font: UIFont) -> Self {
        if let holder = attributedPlaceholder, !holder.string.isEmpty {
            var attributes = holder.sk_attributes()
            attributes[.font] = font
            attributedPlaceholder = holder.sk_mutable().sk_addAttributes(attributes, for: holder.string.sk_fullNSRange())
        } else if let holder = placeholder {
            let attributedPlaceholder = NSMutableAttributedString(string: holder)
            attributedPlaceholder
                .sk_addAttributes([.font: font], for: holder.sk_fullNSRange())
            self.attributedPlaceholder = attributedPlaceholder
        }
        return self
    }

    @discardableResult
    func sk_placeholder(_ color: UIColor, font: UIFont) -> Self {
        if let holder = attributedPlaceholder, !holder.string.isEmpty {
            var attributes = holder.sk_attributes()
            attributes[.font] = font
            attributes[.foregroundColor] = color
            attributedPlaceholder = holder.sk_mutable().sk_addAttributes(attributes, for: holder.sk_fullNSRange())
        } else if let holder = placeholder {
            let attributedPlaceholder = NSMutableAttributedString(string: holder)
            attributedPlaceholder
                .sk_addAttributes([.font: font, .foregroundColor: color], for: holder.sk_fullNSRange())
            self.attributedPlaceholder = attributedPlaceholder
        }
        return self
    }

    @discardableResult
    func sk_textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    @discardableResult
    func sk_textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }

    @discardableResult
    func sk_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    func sk_adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }

    @discardableResult
    func sk_systemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.systemFont(ofSize: fontSize)
        return self
    }

    @discardableResult
    func sk_delegate(_ delegate: UITextFieldDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func sk_keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }

    @discardableResult
    func sk_returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.returnKeyType = returnKeyType
        return self
    }

    @discardableResult
    func sk_leftViewMode(_ mode: ViewMode) -> Self {
        leftViewMode = mode
        return self
    }

    @discardableResult
    func sk_rightViewMode(_ mode: ViewMode) -> Self {
        rightViewMode = mode
        return self
    }

    @discardableResult
    func sk_leftPadding(_ padding: CGFloat) -> Self {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftViewMode = .always
        return self
    }

    @discardableResult
    func sk_rightPadding(_ padding: CGFloat) -> Self {
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        rightViewMode = .always
        return self
    }

    @discardableResult
    func sk_leftView(_ leftView: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {
        let containerView = UIView(frame: containerRect)
        if let contentRect { leftView?.frame = contentRect }
        if let leftView { containerView.addSubview(leftView) }

        self.leftView = containerView
        leftViewMode = .always

        return self
    }

    @discardableResult
    func sk_rightView(_ rightView: UIView?, containerRect: CGRect, contentRect: CGRect? = nil) -> Self {

        let containerView = UIView(frame: containerRect)
        if let contentRect {
            leftView?.frame = contentRect
        } else {
            leftView?.frame = leftView?.frame ?? .zero
        }

        if let contentRect { rightView?.frame = contentRect }
        if let rightView { containerView.addSubview(rightView) }

        self.rightView = containerView
        rightViewMode = .always

        return self
    }

    @discardableResult
    func sk_inputAccessoryView(_ inputAccessoryView: UIView?) -> Self {
        self.inputAccessoryView = inputAccessoryView
        return self
    }

    @discardableResult
    func sk_inputView(_ inputView: UIView) -> Self {
        self.inputView = inputView
        return self
    }

    @discardableResult
    func sk_toolbar(_ toobar: UIToolbar) -> Self {
        inputAccessoryView = toobar
        return self
    }
}
