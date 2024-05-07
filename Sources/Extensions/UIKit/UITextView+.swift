
import UIKit

private class AssociateKeys {
    static var placeholder: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDEL".hashValue)
    static var placeholderLabel: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDELABEL".hashValue)
    static var placeholdFont: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDFONT".hashValue)
    static var placeholdColor: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDCOLOR".hashValue)
    static var placeholderOrigin: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDERORIGIN".hashValue)
}

public extension UITextView {
    var pd_placeholder: String? {
        get { AssociatedObject.get(self, &AssociateKeys.placeholder) as? String }
        set {
            AssociatedObject.set(self, &AssociateKeys.placeholder, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)

            guard let pd_placeholderLabel else {
                self.pd_initPlaceholder(pd_placeholder!)
                return
            }
            pd_placeholderLabel.pd_text(pd_placeholder)
            self.pd_constraintPlaceholder()
        }
    }

    var pd_placeholderFont: UIFont? {
        get {
            return (AssociatedObject.get(self, &AssociateKeys.placeholdFont) as? UIFont).pd_or(.systemFont(ofSize: 13))
        }
        set {
            AssociatedObject.set(self, &AssociateKeys.placeholdFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let pd_placeholderLabel = self.pd_placeholderLabel else { return }
            pd_placeholderLabel.pd_font(pd_placeholderFont!)
            self.pd_constraintPlaceholder()
        }
    }

    var pd_placeholderColor: UIColor? {
        get {
            return (AssociatedObject.get(self, AssociateKeys.placeholdColor) as? UIColor).pd_or(.lightGray)
        }
        set {
            AssociatedObject.set(self, AssociateKeys.placeholdColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            pd_placeholderLabel?.textColor = pd_placeholderColor
        }
    }

    var pd_placeholderOrigin: CGPoint? {
        get {
            return (AssociatedObject.get(self, AssociateKeys.placeholderOrigin) as? CGPoint).pd_or(.zero)
        }
        set {
            AssociatedObject.set(self, AssociateKeys.placeholderOrigin, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let pd_placeholderLabel, let pd_placeholderOrigin else { return }
            pd_placeholderLabel.frame.origin = pd_placeholderOrigin
        }
    }
}

private extension UITextView {
    var pd_placeholderLabel: UILabel? {
        set {
            AssociatedObject.set(self, AssociateKeys.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { AssociatedObject.get(self, AssociateKeys.placeholderLabel) as? UILabel }
    }

    func pd_initPlaceholder(_ placeholder: String) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pd_textChangeHandler(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)

        self.pd_placeholderLabel = UILabel.default()
            .pd_text(pd_placeholder)
            .pd_font(pd_placeholderFont ?? .systemFont(ofSize: 14))
            .pd_textColor(pd_placeholderColor ?? .gray)
            .pd_numberOfLines(0)
            .pd_add2(self)
            .pd_isHidden(text.count > 0)
        self.pd_constraintPlaceholder()
    }

    func pd_constraintPlaceholder() {
        guard let pd_placeholderLabel else { return }
        let placeholderSize = pd_placeholderLabel.pd_textSize()
        pd_placeholderLabel.pd_frame(CGRect(origin: self.pd_placeholderOrigin.pd_or(.zero), size: placeholderSize))
    }

    @objc func pd_textChangeHandler(_ notification: Notification) {
        self.pd_placeholderLabel?.pd_isHidden(text.count > 0)
    }
}

public extension UITextView {

    func pd_inputRestrictions(shouldChangeTextIn range: NSRange, replacementText text: String, maxCharacters: Int, regex: String?) -> Bool {
        guard !text.isEmpty else { return true }
        guard let oldContent = self.text else { return false }

        if let _ = markedTextRange {
            guard range.length != 0 else { return oldContent.count + 1 <= maxCharacters }
            if let weakRegex = regex, !text.pd_isMatchRegexp(weakRegex) { return false }
            let allContent = oldContent.pd_subString(to: range.location) + text
            if allContent.count > maxCharacters {
                let newContent = allContent.pd_subString(to: maxCharacters)
                self.text = newContent
                return false
            }
        } else {
            guard !text.pd_isNineKeyBoard() else { return true }
            if let weakRegex = regex, !text.pd_isMatchRegexp(weakRegex) { return false }
            guard oldContent.count + text.count <= maxCharacters else { return false }
        }
        return true
    }

    func pd_appendLinkString(_ linkString: String, font: UIFont, linkAddr: String? = nil) {
        let addAttributes = [NSAttributedString.Key.font: font]
        let linkAttributedString = NSMutableAttributedString(string: linkString, attributes: addAttributes)

        if let linkAddr {
            linkAttributedString.beginEditing()
            linkAttributedString.addAttribute(NSAttributedString.Key.link,
                                              value: linkAddr,
                                              range: linkString.pd_fullNSRange())
            linkAttributedString.endEditing()
        }

        attributedText = attributedText
            .pd_mutable()
            .pd_append(linkAttributedString)
    }

    func pd_resolveHashTags() {
        let nsText: NSString = text! as NSString

        let m_attributedText = (text ?? "").pd_nsMutableAttributedString().pd_font(font)

        var bookmark = 0
        let charactersSet = CharacterSet(charactersIn: "@#")
        let sentences: [String] = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for sentence in sentences {
            if !sentence.pd_isValidUrl() {
                let words: [String] = sentence.components(separatedBy: charactersSet)
                var bookmark2 = bookmark
                for i in 0 ..< words.count {
                    let word = words[i]
                    let keyword = pd_chopOffNonAlphaNumericCharacters(word as String) ?? ""
                    if keyword != "", i > 0 {

                        let remainingRangeLength = min(nsText.length - bookmark2 + 1, word.count + 2)
                        let remainingRange = NSRange(location: bookmark2 - 1, length: remainingRangeLength)

                        let encodeKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                        var matchRange = nsText.range(of: "@\(keyword)", options: .literal, range: remainingRange)
                        m_attributedText.addAttribute(NSAttributedString.Key.link, value: "test1:\(encodeKeyword)", range: matchRange)
                        matchRange = nsText.range(of: "#\(keyword)#", options: .literal, range: remainingRange)
                        m_attributedText.addAttribute(NSAttributedString.Key.link, value: "test2:\(encodeKeyword)", range: matchRange)
                        // attrString.addAttributes([NSAttributedString.Key.link :"test2:\(encodeKeyword)"], range:matchRange)
                    }
                    bookmark2 += word.count + 1
                }
            }
            bookmark += sentence.count + 1
        }
        attributedText = m_attributedText
    }

    private func pd_chopOffNonAlphaNumericCharacters(_ text: String) -> String? {
        let nonAlphaNumericCharacters = CharacterSet.alphanumerics.inverted
        return text.components(separatedBy: nonAlphaNumericCharacters).first
    }
}

public extension UITextView {
    typealias Associatedtype = UITextView

    override class func `default`() -> Associatedtype {
        let textView = UITextView()
        return textView
    }
}


public extension UITextView {

    @discardableResult
    func pd_clear() -> Self {
        self.text = ""
        self.attributedText = "".pd_nsAttributedString()
        return self
    }

    @discardableResult
    func pd_text(_ text: String) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    func pd_attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }

    @discardableResult
    func pd_textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    @discardableResult
    func pd_textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }

    @discardableResult
    func pd_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    @discardableResult
    func pd_systemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.systemFont(ofSize: fontSize)
        return self
    }

    @discardableResult
    func pd_delegate(_ delegate: UITextViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func pd_keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }

    @discardableResult
    func pd_returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.returnKeyType = returnKeyType
        return self
    }

    @discardableResult
    func pd_enablesReturnKeyAutomatically(_ enable: Bool) -> Self {
        enablesReturnKeyAutomatically = enable
        return self
    }

    @discardableResult
    func pd_textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
        self.textContainerInset = textContainerInset
        return self
    }

    @discardableResult
    func pd_lineFragmentPadding(_ lineFragmentPadding: CGFloat) -> Self {
        self.textContainer.lineFragmentPadding = lineFragmentPadding
        return self
    }

    @discardableResult
    func pd_placeholder(_ placeholder: String) -> Self {
        self.pd_placeholder = placeholder
        return self
    }

    @discardableResult
    func pd_placeholderColor(_ textColor: UIColor) -> Self {
        pd_placeholderColor = textColor
        return self
    }

    @discardableResult
    func pd_placeholderFont(_ font: UIFont) -> Self {
        pd_placeholderFont = font
        return self
    }
    
    @discardableResult
    func pd_placeholderOrigin(_ origin: CGPoint) -> Self {
        pd_placeholderOrigin = origin
        return self
    }

    @discardableResult
    func scrollToTop() -> Self {
        let range = NSRange(location: 0, length: 1)
        scrollRangeToVisible(range)
        return self
    }

    @discardableResult
    func scrollToBottom() -> Self {
        let range = NSRange(location: (text as NSString).length - 1, length: 1)
        scrollRangeToVisible(range)
        return self
    }

    @discardableResult
    func wrapToContent() -> Self {
        contentInset = .zero
        scrollIndicatorInsets = .zero
        contentOffset = .zero
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        sizeToFit()
        return self
    }
}
