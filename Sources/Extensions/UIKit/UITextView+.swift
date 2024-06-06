
import UIKit

private class AssociateKeys {
    static var placeholder: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDEL".hashValue)
    static var placeholderLabel: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDELABEL".hashValue)
    static var placeholdFont: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDFONT".hashValue)
    static var placeholdColor: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDCOLOR".hashValue)
    static var placeholderOrigin: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDERORIGIN".hashValue)
}

public extension UITextView {
    var sk_placeholder: String? {
        get { AssociatedObject.get(self, &AssociateKeys.placeholder) as? String }
        set {
            AssociatedObject.set(self, &AssociateKeys.placeholder, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)

            guard let sk_placeholderLabel else {
                self.sk_initPlaceholder(sk_placeholder!)
                return
            }
            sk_placeholderLabel.sk_text(sk_placeholder)
            self.sk_constraintPlaceholder()
        }
    }

    var sk_placeholderFont: UIFont? {
        get {
            return (AssociatedObject.get(self, &AssociateKeys.placeholdFont) as? UIFont).sk_or(.systemFont(ofSize: 13))
        }
        set {
            AssociatedObject.set(self, &AssociateKeys.placeholdFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let sk_placeholderLabel = self.sk_placeholderLabel else { return }
            sk_placeholderLabel.sk_font(sk_placeholderFont!)
            self.sk_constraintPlaceholder()
        }
    }

    var sk_placeholderColor: UIColor? {
        get {
            return (AssociatedObject.get(self, AssociateKeys.placeholdColor) as? UIColor).sk_or(.lightGray)
        }
        set {
            AssociatedObject.set(self, AssociateKeys.placeholdColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            sk_placeholderLabel?.textColor = sk_placeholderColor
        }
    }

    var sk_placeholderOrigin: CGPoint? {
        get {
            return (AssociatedObject.get(self, AssociateKeys.placeholderOrigin) as? CGPoint).sk_or(.zero)
        }
        set {
            AssociatedObject.set(self, AssociateKeys.placeholderOrigin, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let sk_placeholderLabel, let sk_placeholderOrigin else { return }
            sk_placeholderLabel.frame.origin = sk_placeholderOrigin
        }
    }
}

private extension UITextView {
    var sk_placeholderLabel: UILabel? {
        set {
            AssociatedObject.set(self, AssociateKeys.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { AssociatedObject.get(self, AssociateKeys.placeholderLabel) as? UILabel }
    }

    func sk_initPlaceholder(_ placeholder: String) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sk_textChangeHandler(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)

        self.sk_placeholderLabel = UILabel.default()
            .sk_text(sk_placeholder)
            .sk_font(sk_placeholderFont ?? .systemFont(ofSize: 14))
            .sk_textColor(sk_placeholderColor ?? .gray)
            .sk_numberOfLines(0)
            .sk_add2(self)
            .sk_isHidden(text.count > 0)
        self.sk_constraintPlaceholder()
    }

    func sk_constraintPlaceholder() {
        guard let sk_placeholderLabel else { return }
        let placeholderSize = sk_placeholderLabel.sk_textSize()
        sk_placeholderLabel.sk_frame(CGRect(origin: self.sk_placeholderOrigin.sk_or(.zero), size: placeholderSize))
    }

    @objc func sk_textChangeHandler(_ notification: Notification) {
        self.sk_placeholderLabel?.sk_isHidden(text.count > 0)
    }
}

public extension UITextView {

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

    func sk_appendLinkString(_ linkString: String, font: UIFont, linkAddr: String? = nil) {
        let addAttributes = [NSAttributedString.Key.font: font]
        let linkAttributedString = NSMutableAttributedString(string: linkString, attributes: addAttributes)

        if let linkAddr {
            linkAttributedString.beginEditing()
            linkAttributedString.addAttribute(NSAttributedString.Key.link,
                                              value: linkAddr,
                                              range: linkString.sk_fullNSRange())
            linkAttributedString.endEditing()
        }

        attributedText = attributedText
            .sk_mutable()
            .sk_append(linkAttributedString)
    }

    func sk_resolveHashTags() {
        let nsText: NSString = text! as NSString

        let m_attributedText = (text ?? "").sk_nsMutableAttributedString().sk_font(font)

        var bookmark = 0
        let charactersSet = CharacterSet(charactersIn: "@#")
        let sentences: [String] = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for sentence in sentences {
            if !sentence.sk_isValidUrl() {
                let words: [String] = sentence.components(separatedBy: charactersSet)
                var bookmark2 = bookmark
                for i in 0 ..< words.count {
                    let word = words[i]
                    let keyword = sk_chopOffNonAlphaNumericCharacters(word as String) ?? ""
                    if keyword != "", i > 0 {

                        let remainingRangeLength = min(nsText.length - bookmark2 + 1, word.count + 2)
                        let remainingRange = NSRange(location: bookmark2 - 1, length: remainingRangeLength)

                        let encodeKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                        var matchRange = nsText.range(of: "@\(keyword)", options: .literal, range: remainingRange)
                        m_attributedText.addAttribute(NSAttributedString.Key.link, value: "test1:\(encodeKeyword)", range: matchRange)
                        matchRange = nsText.range(of: "#\(keyword)#", options: .literal, range: remainingRange)
                        m_attributedText.addAttribute(NSAttributedString.Key.link, value: "test2:\(encodeKeyword)", range: matchRange)
                    }
                    bookmark2 += word.count + 1
                }
            }
            bookmark += sentence.count + 1
        }
        attributedText = m_attributedText
    }

    private func sk_chopOffNonAlphaNumericCharacters(_ text: String) -> String? {
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
    func sk_clear() -> Self {
        self.text = ""
        self.attributedText = "".sk_nsAttributedString()
        return self
    }

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

    @discardableResult
    func sk_systemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.systemFont(ofSize: fontSize)
        return self
    }

    @discardableResult
    func sk_delegate(_ delegate: UITextViewDelegate) -> Self {
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
    func sk_enablesReturnKeyAutomatically(_ enable: Bool) -> Self {
        enablesReturnKeyAutomatically = enable
        return self
    }

    @discardableResult
    func sk_textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
        self.textContainerInset = textContainerInset
        return self
    }

    @discardableResult
    func sk_lineFragmentPadding(_ lineFragmentPadding: CGFloat) -> Self {
        self.textContainer.lineFragmentPadding = lineFragmentPadding
        return self
    }

    @discardableResult
    func sk_placeholder(_ placeholder: String) -> Self {
        self.sk_placeholder = placeholder
        return self
    }

    @discardableResult
    func sk_placeholderColor(_ textColor: UIColor) -> Self {
        sk_placeholderColor = textColor
        return self
    }

    @discardableResult
    func sk_placeholderFont(_ font: UIFont) -> Self {
        sk_placeholderFont = font
        return self
    }
    
    @discardableResult
    func sk_placeholderOrigin(_ origin: CGPoint) -> Self {
        sk_placeholderOrigin = origin
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
