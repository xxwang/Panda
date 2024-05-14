
import UIKit

private class AssociateKeys {
    static var placeholder: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDEL".hashValue)
    static var placeholderLabel: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDELABEL".hashValue)
    static var placeholdFont: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDFONT".hashValue)
    static var placeholdColor: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDCOLOR".hashValue)
    static var placeholderOrigin: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDERORIGIN".hashValue)
}

public extension UITextView {
    var xx_placeholder: String? {
        get { AssociatedObject.get(self, &AssociateKeys.placeholder) as? String }
        set {
            AssociatedObject.set(self, &AssociateKeys.placeholder, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)

            guard let xx_placeholderLabel else {
                self.xx_initPlaceholder(xx_placeholder!)
                return
            }
            xx_placeholderLabel.xx_text(xx_placeholder)
            self.xx_constraintPlaceholder()
        }
    }

    var xx_placeholderFont: UIFont? {
        get {
            return (AssociatedObject.get(self, &AssociateKeys.placeholdFont) as? UIFont).xx_or(.systemFont(ofSize: 13))
        }
        set {
            AssociatedObject.set(self, &AssociateKeys.placeholdFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let xx_placeholderLabel = self.xx_placeholderLabel else { return }
            xx_placeholderLabel.xx_font(xx_placeholderFont!)
            self.xx_constraintPlaceholder()
        }
    }

    var xx_placeholderColor: UIColor? {
        get {
            return (AssociatedObject.get(self, AssociateKeys.placeholdColor) as? UIColor).xx_or(.lightGray)
        }
        set {
            AssociatedObject.set(self, AssociateKeys.placeholdColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            xx_placeholderLabel?.textColor = xx_placeholderColor
        }
    }

    var xx_placeholderOrigin: CGPoint? {
        get {
            return (AssociatedObject.get(self, AssociateKeys.placeholderOrigin) as? CGPoint).xx_or(.zero)
        }
        set {
            AssociatedObject.set(self, AssociateKeys.placeholderOrigin, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let xx_placeholderLabel, let xx_placeholderOrigin else { return }
            xx_placeholderLabel.frame.origin = xx_placeholderOrigin
        }
    }
}

private extension UITextView {
    var xx_placeholderLabel: UILabel? {
        set {
            AssociatedObject.set(self, AssociateKeys.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { AssociatedObject.get(self, AssociateKeys.placeholderLabel) as? UILabel }
    }

    func xx_initPlaceholder(_ placeholder: String) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(xx_textChangeHandler(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)

        self.xx_placeholderLabel = UILabel.default()
            .xx_text(xx_placeholder)
            .xx_font(xx_placeholderFont ?? .systemFont(ofSize: 14))
            .xx_textColor(xx_placeholderColor ?? .gray)
            .xx_numberOfLines(0)
            .xx_add2(self)
            .xx_isHidden(text.count > 0)
        self.xx_constraintPlaceholder()
    }

    func xx_constraintPlaceholder() {
        guard let xx_placeholderLabel else { return }
        let placeholderSize = xx_placeholderLabel.xx_textSize()
        xx_placeholderLabel.xx_frame(CGRect(origin: self.xx_placeholderOrigin.xx_or(.zero), size: placeholderSize))
    }

    @objc func xx_textChangeHandler(_ notification: Notification) {
        self.xx_placeholderLabel?.xx_isHidden(text.count > 0)
    }
}

public extension UITextView {

    func xx_inputRestrictions(shouldChangeTextIn range: NSRange, replacementText text: String, maxCharacters: Int, regex: String?) -> Bool {
        guard !text.isEmpty else { return true }
        guard let oldContent = self.text else { return false }

        if let _ = markedTextRange {
            guard range.length != 0 else { return oldContent.count + 1 <= maxCharacters }
            if let weakRegex = regex, !text.xx_isMatchRegexp(weakRegex) { return false }
            let allContent = oldContent.xx_subString(to: range.location) + text
            if allContent.count > maxCharacters {
                let newContent = allContent.xx_subString(to: maxCharacters)
                self.text = newContent
                return false
            }
        } else {
            guard !text.xx_isNineKeyBoard() else { return true }
            if let weakRegex = regex, !text.xx_isMatchRegexp(weakRegex) { return false }
            guard oldContent.count + text.count <= maxCharacters else { return false }
        }
        return true
    }

    func xx_appendLinkString(_ linkString: String, font: UIFont, linkAddr: String? = nil) {
        let addAttributes = [NSAttributedString.Key.font: font]
        let linkAttributedString = NSMutableAttributedString(string: linkString, attributes: addAttributes)

        if let linkAddr {
            linkAttributedString.beginEditing()
            linkAttributedString.addAttribute(NSAttributedString.Key.link,
                                              value: linkAddr,
                                              range: linkString.xx_fullNSRange())
            linkAttributedString.endEditing()
        }

        attributedText = attributedText
            .xx_mutable()
            .xx_append(linkAttributedString)
    }

    func xx_resolveHashTags() {
        let nsText: NSString = text! as NSString

        let m_attributedText = (text ?? "").xx_nsMutableAttributedString().xx_font(font)

        var bookmark = 0
        let charactersSet = CharacterSet(charactersIn: "@#")
        let sentences: [String] = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for sentence in sentences {
            if !sentence.xx_isValidUrl() {
                let words: [String] = sentence.components(separatedBy: charactersSet)
                var bookmark2 = bookmark
                for i in 0 ..< words.count {
                    let word = words[i]
                    let keyword = xx_chopOffNonAlphaNumericCharacters(word as String) ?? ""
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

    private func xx_chopOffNonAlphaNumericCharacters(_ text: String) -> String? {
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
    func xx_clear() -> Self {
        self.text = ""
        self.attributedText = "".xx_nsAttributedString()
        return self
    }

    @discardableResult
    func xx_text(_ text: String) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    func xx_attributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }

    @discardableResult
    func xx_textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    @discardableResult
    func xx_textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }

    @discardableResult
    func xx_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    @discardableResult
    func xx_systemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.systemFont(ofSize: fontSize)
        return self
    }

    @discardableResult
    func xx_delegate(_ delegate: UITextViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func xx_keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }

    @discardableResult
    func xx_returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.returnKeyType = returnKeyType
        return self
    }

    @discardableResult
    func xx_enablesReturnKeyAutomatically(_ enable: Bool) -> Self {
        enablesReturnKeyAutomatically = enable
        return self
    }

    @discardableResult
    func xx_textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
        self.textContainerInset = textContainerInset
        return self
    }

    @discardableResult
    func xx_lineFragmentPadding(_ lineFragmentPadding: CGFloat) -> Self {
        self.textContainer.lineFragmentPadding = lineFragmentPadding
        return self
    }

    @discardableResult
    func xx_placeholder(_ placeholder: String) -> Self {
        self.xx_placeholder = placeholder
        return self
    }

    @discardableResult
    func xx_placeholderColor(_ textColor: UIColor) -> Self {
        xx_placeholderColor = textColor
        return self
    }

    @discardableResult
    func xx_placeholderFont(_ font: UIFont) -> Self {
        xx_placeholderFont = font
        return self
    }
    
    @discardableResult
    func xx_placeholderOrigin(_ origin: CGPoint) -> Self {
        xx_placeholderOrigin = origin
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
