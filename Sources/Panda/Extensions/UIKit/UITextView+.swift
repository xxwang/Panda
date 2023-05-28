//
//  UITextView+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 关联键
private class AssociateKeys {
    static var placeholder: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDEL".hashValue)
    static var placeholderLabel: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDELABEL".hashValue)
    static var placeholdFont: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDFONT".hashValue)
    static var placeholdColor: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDCOLOR".hashValue)
    static var placeholderOrigin: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "PLACEHOLDERORIGIN".hashValue)
}

// MARK: - 占位符Label
public extension UITextView {
    /// 设置占位符
    var placeholder: String? {
        get { AssociatedObject.get(self, &AssociateKeys.placeholder) }
        set {
            AssociatedObject.set(self, &AssociateKeys.placeholder, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            initPlaceholder(placeholder!)
        }
    }

    /// 占位文本字体
    var placeholderFont: UIFont? {
        set {
            AssociatedObject.set(self, &AssociateKeys.placeholdFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard placeholderLabel != nil else { return }
            placeholderLabel?.font = placeholderFont
            constraintPlaceholder()
        }
        get {
            AssociatedObject.get(self, &AssociateKeys.placeholdFont) ?? UIFont.systemFont(ofSize: 13)
        }
    }

    /// 占位文本的颜色
    var placeholderColor: UIColor? {
        get {
            AssociatedObject.get(self, AssociateKeys.placeholdColor) ?? UIColor.lightGray
        }
        set {
            AssociatedObject.set(self, AssociateKeys.placeholdColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            placeholderLabel?.textColor = placeholderColor
        }
    }

    /// 设置占位文本的`Origin`
    var placeholderOrigin: CGPoint? {
        get {
            AssociatedObject.get(self, AssociateKeys.placeholderOrigin) ?? CGPoint(x: 7, y: 7)
        }
        set {
            AssociatedObject.set(self, AssociateKeys.placeholderOrigin, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard placeholderLabel != nil, placeholderOrigin != nil else { return }
            placeholderLabel?.frame.origin = placeholderOrigin!
        }
    }
}

// MARK: - 私有(占位符)
private extension UITextView {
    /// 默认文本
    var placeholderLabel: UILabel? {
        set {
            AssociatedObject.set(self, AssociateKeys.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { AssociatedObject.get(self, AssociateKeys.placeholderLabel) }
    }

    /// 初始化占位符Label
    /// - Parameter placeholder:占位符
    func initPlaceholder(_ placeholder: String) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChangeHandler(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)

        placeholderLabel = UILabel.default()
            .pd_text(placeholder)
            .pd_font(placeholderFont ?? .systemFont(ofSize: 14))
            .pd_textColor(placeholderColor ?? .gray)
            .pd_numberOfLines(0)
            .pd_add2(self)
            .pd_isHidden(text.count > 0)
        constraintPlaceholder()
    }

    /// 为占位Label添加约束
    func constraintPlaceholder() {
        guard let placeholderLabel else { return }

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        let placeholderSize = placeholderLabel.textSize()
        addConstraints([
            NSLayoutConstraint(item: placeholderLabel,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .width,
                               multiplier: 1,
                               constant: placeholderSize.width),
            NSLayoutConstraint(item: placeholderLabel,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .height,
                               multiplier: 1,
                               constant: placeholderSize.height),
            NSLayoutConstraint(item: placeholderLabel,
                               attribute: .left,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .left,
                               multiplier: 1,
                               constant: textContainer.lineFragmentPadding),
            NSLayoutConstraint(item: placeholderLabel,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerY,
                               multiplier: 1, constant: 0),
        ])
    }

    /// 文本框输入内容变化通知处理
    /// - Parameter notification:动态监听
    @objc func textChangeHandler(_ notification: Notification) {
        if placeholder != nil { placeholderLabel?.isHidden = text.count > 0 }
    }
}

// MARK: - 方法
public extension UITextView {
    /// 清空内容
    func clear() {
        text = ""
        attributedText = "".toAttributedString()
    }

    /// 限制输入的字数
    ///
    /// 调用位置
    /// `func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool`
    ///
    /// - Parameters:
    ///   - range:范围
    ///   - text:输入的文字
    ///   - maxCharacters:限制字数
    ///   - regex:可输入内容(正则)
    /// - Returns:返回是否可输入
    func inputRestrictions(shouldChangeTextIn range: NSRange, replacementText text: String, maxCharacters: Int, regex: String?) -> Bool {
        guard !text.isEmpty else { return true }
        guard let oldContent = self.text else { return false }

        if let _ = markedTextRange {
            // 有高亮联想中
            guard range.length != 0 else { return oldContent.count + 1 <= maxCharacters }
            // 无高亮
            // 正则的判断
            if let weakRegex = regex, !text.isMatchRegexp(weakRegex) { return false }
            // 联想选中键盘
            let allContent = oldContent.subString(to: range.location) + text
            if allContent.count > maxCharacters {
                let newContent = allContent.subString(to: maxCharacters)
                self.text = newContent
                return false
            }
        } else {
            guard !text.isNineKeyBoard() else { return true }
            // 正则的判断
            if let weakRegex = regex, !text.isMatchRegexp(weakRegex) { return false }
            // 如果数字大于指定位数,不能输入
            guard oldContent.count + text.count <= maxCharacters else { return false }
        }
        return true
    }

    /// 添加链接文本(链接为空时则表示普通文本)
    /// - Parameters:
    ///   - string:文本
    ///   - withURLString:链接
    func appendLinkString(_ linkString: String, font: UIFont, linkAddr: String? = nil) {
        // 新增的文本内容(使用默认设置的字体样式)
        let addAttributes = [NSAttributedString.Key.font: font]
        let linkAttributedString = NSMutableAttributedString(string: linkString, attributes: addAttributes)

        // 判断是否是链接文字
        if let linkAddr {
            linkAttributedString.beginEditing()
            linkAttributedString.addAttribute(NSAttributedString.Key.link,
                                              value: linkAddr,
                                              range: linkString.fullNSRange())
            linkAttributedString.endEditing()
        }

        attributedText = attributedText
            .toMutable()
            .pd_append(linkAttributedString)
    }

    // FIXME: - 待完成方法
    /// 转换特殊符号标签字段
    func resolveHashTags() {
        let nsText: NSString = text! as NSString

        // 使用默认设置的字体样式
        let m_attributedText = (text ?? "").toMutableAttributedString().pd_font(font)

        // 用来记录遍历字符串的索引位置
        var bookmark = 0
        // 用于拆分的特殊符号
        let charactersSet = CharacterSet(charactersIn: "@#")

        // 先将字符串按空格和分隔符拆分
        let sentences: [String] = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for sentence in sentences {
            // 如果是url链接则跳过
            if !sentence.isURL() {
                // 再按特殊符号拆分
                let words: [String] = sentence.components(separatedBy: charactersSet)
                var bookmark2 = bookmark
                for i in 0 ..< words.count {
                    let word = words[i]
                    let keyword = chopOffNonAlphaNumericCharacters(word as String) ?? ""
                    if keyword != "", i > 0 {
                        // 使用自定义的scheme来表示各种特殊链接,比如:mention:hangge
                        // 使得这些字段会变蓝色且可点击
                        // 匹配的范围
                        let remainingRangeLength = min(nsText.length - bookmark2 + 1, word.count + 2)
                        let remainingRange = NSRange(location: bookmark2 - 1, length: remainingRangeLength)
                        // print(keyword, bookmark2, remainingRangeLength)
                        // 获取转码后的关键字,用于url里的值
                        // (确保链接的正确性,比如url链接直接用中文就会有问题)
                        let encodeKeyword = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                        // 匹配@某人
                        var matchRange = nsText.range(of: "@\(keyword)", options: .literal, range: remainingRange)
                        m_attributedText.addAttribute(NSAttributedString.Key.link, value: "test1:\(encodeKeyword)", range: matchRange)
                        // 匹配#话题#
                        matchRange = nsText.range(of: "#\(keyword)#", options: .literal, range: remainingRange)
                        m_attributedText.addAttribute(NSAttributedString.Key.link, value: "test2:\(encodeKeyword)", range: matchRange)
                        // attrString.addAttributes([NSAttributedString.Key.link :"test2:\(encodeKeyword)"], range:matchRange)
                    }
                    // 移动坐标索引记录
                    bookmark2 += word.count + 1
                }
            }
            // 移动坐标索引记录
            bookmark += sentence.count + 1
        }
        // print(nsText.length, bookmark)
        // 最终赋值
        attributedText = m_attributedText
    }

    // FIXME: - 待完成方法
    /// 过滤部多余的非数字和字符的部分
    /// - Parameter text:@hangge.123 -> @hangge
    /// - Returns:返回过滤后的字符串
    private func chopOffNonAlphaNumericCharacters(_ text: String) -> String? {
        let nonAlphaNumericCharacters = CharacterSet.alphanumerics.inverted
        return text.components(separatedBy: nonAlphaNumericCharacters).first
    }
}

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
    /// 清空内容
    /// - Returns:`Self`
    @discardableResult
    func pd_clear() -> Self {
        clear()
        return self
    }

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
    @discardableResult
    func pd_enablesReturnKeyAutomatically(_ enable: Bool) -> Self {
        enablesReturnKeyAutomatically = enable
        return self
    }

    /// 设置内容容器的外间距
    /// - Parameter textContainerInset: 外间距
    /// - Returns: `Self`
    @discardableResult
    func pd_textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
        self.textContainerInset = textContainerInset
        return self
    }

    /// 设置文本容器左右内间距
    /// - Parameter lineFragmentPadding: 左右内间距
    /// - Returns: `Self`
    @discardableResult
    func pd_lineFragmentPadding(_ lineFragmentPadding: CGFloat) -> Self {
        textContainer.lineFragmentPadding = lineFragmentPadding
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

    /// 设置占位符颜色
    /// - Parameter textColor:文字颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_placeholderColor(_ textColor: UIColor) -> Self {
        placeholderColor = textColor
        return self
    }

    /// 设置占位符字体
    /// - Parameter font:文字字体
    /// - Returns:`Self`
    @discardableResult
    func pd_placeholderFont(_ font: UIFont) -> Self {
        placeholderFont = font
        return self
    }

    /// 设置占位符`Origin`
    /// - Parameter origin:`CGPoint`
    /// - Returns:`Self`
    @discardableResult
    func pd_placeholderOrigin(_ origin: CGPoint) -> Self {
        placeholderOrigin = origin
        return self
    }

    /// 滚动到文本视图的顶部
    /// - Returns: `Self`
    @discardableResult
    func scrollToTop() -> Self {
        let range = NSRange(location: 0, length: 1)
        scrollRangeToVisible(range)
        return self
    }

    /// 滚动到文本视图的底部
    /// - Returns: `Self`
    @discardableResult
    func scrollToBottom() -> Self {
        let range = NSRange(location: (text as NSString).length - 1, length: 1)
        scrollRangeToVisible(range)
        return self
    }

    /// 调整大小到内容的大小
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
