import UIKit

public extension NSMutableAttributedString {
    func pd_immutable() -> NSAttributedString {
        return self
    }
}

extension NSMutableAttributedString: Defaultable {}
extension NSMutableAttributedString {
    public typealias Associatedtype = NSMutableAttributedString

    @objc open class func `default`() -> Associatedtype {
        return NSMutableAttributedString()
    }
}

public extension NSMutableAttributedString {
    @discardableResult
    func pd_string(_ string: String) -> Self {
        self.pd_attributedString(string.pd_nsAttributedString())
        return self
    }

    @discardableResult
    func pd_attributedString(_ attributedString: NSAttributedString) -> Self {
        self.setAttributedString(attributedString)
        return self
    }

    @discardableResult
    func pd_append(_ attributedString: NSAttributedString) -> Self {
        self.append(attributedString)
        return self
    }

    @discardableResult
    func pd_font(_ font: UIFont?, for range: NSRange? = nil) -> Self {
        if let font {
            let range = range ?? pd_fullNSRange()
            return pd_addAttributes([NSAttributedString.Key.font: font], for: range)
        }
        return self
    }

    @discardableResult
    func pd_wordSpacing(_ wordSpacing: CGFloat, for range: NSRange? = nil) -> Self {
        let range = range ?? pd_fullNSRange()
        pd_addAttributes([.kern: wordSpacing], for: range)
        return self
    }

    @discardableResult
    func pd_lineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> Self {
        let range = range ?? pd_fullNSRange()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        return pd_addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: range)
    }

    @discardableResult
    func pd_foregroundColor(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let range = range ?? pd_fullNSRange()
        return pd_addAttributes([NSAttributedString.Key.foregroundColor: color], for: range)
    }

    @discardableResult
    func pd_underline(_ color: UIColor, stytle: NSUnderlineStyle = .single, for range: NSRange? = nil) -> Self {
        let range = range ?? pd_fullNSRange()

        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return pd_addAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: range)
    }

    @discardableResult
    func pd_strikethrough(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let lineStytle = NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.strikethroughStyle] = lineStytle
        attributes[NSAttributedString.Key.strikethroughColor] = color

        if #available(iOS 10.3, *) {
            attributes[NSAttributedString.Key.baselineOffset] = 0
        } else {
            attributes[NSAttributedString.Key.strikethroughStyle] = 0
        }
        let range = range ?? pd_fullNSRange()
        return pd_addAttributes(attributes, for: range)
    }

    @discardableResult
    func pd_firstLineHeadIndent(_ indent: CGFloat) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return pd_addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: pd_fullNSRange())
    }

    @discardableResult
    func pd_obliqueness(_ obliqueness: Float = 0, for range: NSRange? = nil) -> Self {
        let range = range ?? pd_fullNSRange()
        return pd_addAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: range)
    }

    @discardableResult
    func pd_image(_ image: String, bounds: CGRect = .zero, index: Int = 0) -> Self {
        let attch = NSTextAttachment()
        attch.image = UIImage.pd_loadImage(with: image)
        attch.bounds = bounds

        let string = NSAttributedString(attachment: attch)
        insert(string, at: index)

        return self
    }

    @discardableResult
    func pd_addAttributes(_ attributes: [NSAttributedString.Key: Any], for range: NSRange? = nil) -> Self {
        for name in attributes.keys {
            self.addAttribute(name, value: attributes[name] ?? "", range: range ?? pd_fullNSRange())
        }
        return self
    }

    @discardableResult
    func pd_addAttributes(_ attributes: [NSAttributedString.Key: Any], for text: String) -> Self {
        let ranges = pd_nsRanges(with: [text])
        if !ranges.isEmpty {
            for name in attributes.keys {
                for range in ranges {
                    self.addAttribute(name, value: attributes[name] ?? "", range: range)
                }
            }
        }
        return self
    }

    @discardableResult
    func pd_addAttributes(_ attributes: [Key: Any], toRangesMatching pattern: String, options: NSRegularExpression.Options = []) -> Self {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else { return self }
        let matches = pattern.matches(in: string, options: [], range: NSRange(0 ..< length))
        for match in matches {
            pd_addAttributes(attributes, for: match.range)
        }

        return self
    }

    @discardableResult
    func pd_addAttributes(_ attributes: [Key: Any], toOccurrencesOf target: some StringProtocol) -> Self {
        let pattern = "\\Q\(target)\\E"
        return pd_addAttributes(attributes, toRangesMatching: pattern)
    }
}
