import UIKit

public extension NSMutableAttributedString {
    func xx_immutable() -> NSAttributedString {
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
    func xx_string(_ string: String) -> Self {
        self.xx_attributedString(string.xx_nsAttributedString())
        return self
    }

    @discardableResult
    func xx_attributedString(_ attributedString: NSAttributedString) -> Self {
        self.setAttributedString(attributedString)
        return self
    }

    @discardableResult
    func xx_append(_ attributedString: NSAttributedString) -> Self {
        self.append(attributedString)
        return self
    }

    @discardableResult
    func xx_font(_ font: UIFont?, for range: NSRange? = nil) -> Self {
        if let font {
            let range = range ?? xx_fullNSRange()
            return xx_addAttributes([NSAttributedString.Key.font: font], for: range)
        }
        return self
    }

    @discardableResult
    func xx_wordSpacing(_ wordSpacing: CGFloat, for range: NSRange? = nil) -> Self {
        let range = range ?? xx_fullNSRange()
        xx_addAttributes([.kern: wordSpacing], for: range)
        return self
    }

    @discardableResult
    func xx_lineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> Self {
        let range = range ?? xx_fullNSRange()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        return xx_addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: range)
    }

    @discardableResult
    func xx_foregroundColor(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let range = range ?? xx_fullNSRange()
        return xx_addAttributes([NSAttributedString.Key.foregroundColor: color], for: range)
    }

    @discardableResult
    func xx_underline(_ color: UIColor, stytle: NSUnderlineStyle = .single, for range: NSRange? = nil) -> Self {
        let range = range ?? xx_fullNSRange()

        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return xx_addAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: range)
    }

    @discardableResult
    func xx_strikethrough(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let lineStytle = NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.strikethroughStyle] = lineStytle
        attributes[NSAttributedString.Key.strikethroughColor] = color

        if #available(iOS 10.3, *) {
            attributes[NSAttributedString.Key.baselineOffset] = 0
        } else {
            attributes[NSAttributedString.Key.strikethroughStyle] = 0
        }
        let range = range ?? xx_fullNSRange()
        return xx_addAttributes(attributes, for: range)
    }

    @discardableResult
    func xx_firstLineHeadIndent(_ indent: CGFloat) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return xx_addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: xx_fullNSRange())
    }

    @discardableResult
    func xx_obliqueness(_ obliqueness: Float = 0, for range: NSRange? = nil) -> Self {
        let range = range ?? xx_fullNSRange()
        return xx_addAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: range)
    }

    @discardableResult
    func xx_image(_ image: String, bounds: CGRect = .zero, index: Int = 0) -> Self {
        let attch = NSTextAttachment()
        attch.image = UIImage.xx_loadImage(with: image)
        attch.bounds = bounds

        let string = NSAttributedString(attachment: attch)
        insert(string, at: index)

        return self
    }

    @discardableResult
    func xx_addAttributes(_ attributes: [NSAttributedString.Key: Any], for range: NSRange? = nil) -> Self {
        for name in attributes.keys {
            self.addAttribute(name, value: attributes[name] ?? "", range: range ?? xx_fullNSRange())
        }
        return self
    }

    @discardableResult
    func xx_addAttributes(_ attributes: [NSAttributedString.Key: Any], for text: String) -> Self {
        let ranges = xx_nsRanges(with: [text])
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
    func xx_addAttributes(_ attributes: [Key: Any], toRangesMatching pattern: String, options: NSRegularExpression.Options = []) -> Self {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else { return self }
        let matches = pattern.matches(in: string, options: [], range: NSRange(0 ..< length))
        for match in matches {
            xx_addAttributes(attributes, for: match.range)
        }

        return self
    }

    @discardableResult
    func xx_addAttributes(_ attributes: [Key: Any], toOccurrencesOf target: some StringProtocol) -> Self {
        let pattern = "\\Q\(target)\\E"
        return xx_addAttributes(attributes, toRangesMatching: pattern)
    }
}
