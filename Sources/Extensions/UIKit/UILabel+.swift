import UIKit

public extension UILabel {
    var xx_fontSize: CGFloat {
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = minimumScaleFactor
        return font.pointSize * context.actualScaleFactor
    }

    var xx_requiredHeight: CGFloat {
        UILabel.default()
            .xx_frame(CGRect(x: 0, y: 0, width: frame.width, height: .greatestFiniteMagnitude))
            .xx_lineBreakMode(.byWordWrapping)
            .xx_font(font)
            .xx_text(text)
            .xx_attributedText(attributedText)
            .xx_sizeToFit()
            .xx_height
    }

    var xx_textLines: [String] {
        return (text ?? "").xx_lines(xx_width, font: font!)
    }

    var xx_firstLineString: String? {
        xx_linesContent().first
    }

    var xx_isTruncated: Bool {
        guard let labelText = text else { return false }
        let theorySize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelTextSize = (labelText as NSString)
            .boundingRect(
                with: theorySize,
                options: .usesLineFragmentOrigin,
                attributes: [.font: font!],
                context: nil
            )

        let labelTextLines = Int(Foundation.ceil(labelTextSize.height / font.lineHeight))
        var labelShowLines = Int(Foundation.floor(bounds.size.height / font.lineHeight))
        if numberOfLines != 0 { labelShowLines = min(labelShowLines, numberOfLines) }
        return labelTextLines > labelShowLines
    }
}

public extension UILabel {

    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        font = UIFont.preferredFont(forTextStyle: style)
        self.text = text
    }
}

public extension UILabel {

    func xx_textSize(_ lineWidth: CGFloat = sizer.screen.width) -> CGSize {
        return self.text?.xx_stringSize(lineWidth, font: self.font) ?? .zero
    }

    func xx_attributedTextSize(_ lineWidth: CGFloat = sizer.screen.width) -> CGSize {
        return self.attributedText?.xx_attributedSize(lineWidth) ?? .zero
    }
}

public extension UILabel {

    @discardableResult
    func xx_blend(_ text: String?,
                  images: [UIImage?] = [],
                  spacing: CGFloat = 5,
                  scale: CGFloat,
                  position: Int = 0,
                  isOrgin: Bool = false) -> NSMutableAttributedString
    {
        let headString = text?.xx_subString(to: position) ?? ""
        let attributedString = NSMutableAttributedString(string: headString)

        for image in images {
            guard let image else { continue }

            let imageHeight = (isOrgin ? image.size.height : font.pointSize) * scale
            let imageWidth = (image.size.width / image.size.height) * imageHeight
            let attachTop = (font.lineHeight - font.pointSize) / 2
            let imageAttributedString = NSTextAttachment.default()
                .xx_image(image)
                .xx_bounds(CGRect(x: -3, y: -attachTop, width: imageWidth, height: imageHeight))
                .toAttributedString()
            attributedString.append(imageAttributedString)
            attributedString.append(NSAttributedString(string: " "))
        }

        let tailString = text?.xx_subString(from: position) ?? ""
        attributedString.append(NSAttributedString(string: tailString))

        let spaceW = " ".xx_stringSize(.greatestFiniteMagnitude, font: font).width
        let range = NSRange(location: 0, length: images.count * 2)
        attributedString.addAttribute(.kern, value: spacing - spaceW, range: range)

        attributedText = attributedString

        return attributedString
    }

    @discardableResult
    func xx_setText(_ text: String, lineSpacing: CGFloat, wordSpacing: CGFloat = 1) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle.default()
            .xx_lineBreakMode(.byCharWrapping)
            .xx_alignment(.left)
            .xx_lineSpacing(lineSpacing)
            .xx_hyphenationFactor(1.0)
            .xx_firstLineHeadIndent(0.0)
            .xx_paragraphSpacingBefore(0.0)
            .xx_headIndent(0)
            .xx_tailIndent(0)

        let attrString = text.xx_nsMutableAttributedString()
            .xx_addAttributes([
                .paragraphStyle: style,
                .kern: wordSpacing,
                .font: font ?? .systemFont(ofSize: 14),
            ])
        attributedText = attrString
        return attrString
    }

    func xx_linesContent(_ labelWidth: CGFloat? = nil,
                         lineSpacing: CGFloat = 0.0,
                         wordSpacing: CGFloat = 0.0,
                         paragraphSpacing: CGFloat = 0.0) -> [String]
    {
        guard let text, let font else { return [] }
        let labelWidth: CGFloat = labelWidth ?? bounds.width

        let style = NSMutableParagraphStyle.default()
            .xx_lineBreakMode(lineBreakMode)
            .xx_alignment(textAlignment)
            .xx_lineSpacing(lineSpacing)
            .xx_paragraphSpacing(paragraphSpacing)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: style,
            .kern: wordSpacing,
        ]

        let attributedString = text.xx_nsMutableAttributedString().xx_addAttributes(attributes)
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)

        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: labelWidth - 2.5, height: CGFloat(MAXFLOAT)))
        let framef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(framef) as NSArray

        var result = [String]()
        for line in lines {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            result.append(text.xx_subString(from: lineRange.location, length: lineRange.length))
        }
        return result
    }
}

extension UILabel {
    public typealias Associatedtype = UILabel

    override open class func `default`() -> Associatedtype {
        let label = UILabel()
        return label
    }
}

public extension UILabel {

    @discardableResult
    func xx_text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    func xx_numberOfLines(_ lines: Int) -> Self {
        numberOfLines = lines
        return self
    }

    @discardableResult
    func xx_lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        lineBreakMode = mode
        return self
    }

    @discardableResult
    func xx_textAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }

    @discardableResult
    func xx_attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    }

    @discardableResult
    func xx_textColor(_ color: UIColor) -> Self {
        textColor = color
        return self
    }

    @discardableResult
    func xx_highlightedTextColor(_ color: UIColor) -> Self {
        self.highlightedTextColor = color
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
    func xx_boldSystemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.boldSystemFont(ofSize: fontSize)
        return self
    }

    @discardableResult
    func xx_attributedFont(_ font: UIFont, for range: NSRange) -> Self {
        let attribuedString = attributedText?.xx_mutable().xx_font(font, for: range)
        attributedText = attribuedString
        return self
    }

    @discardableResult
    func xx_attributedColor(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.xx_mutable().xx_foregroundColor(color, for: range)
        attributedText = attributedString
        return self
    }

    @discardableResult
    func xx_lineSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.xx_mutable().xx_lineSpacing(spacing, for: (text ?? "").xx_fullNSRange())
        attributedText = attributedString
        return self
    }

    @discardableResult
    func xx_wordSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.xx_mutable().xx_wordSpacing(spacing, for: (text ?? "").xx_fullNSRange())
        attributedText = attributedString
        return self
    }

    @discardableResult
    func xx_attributedUnderLine(_ color: UIColor, style: NSUnderlineStyle = .single, for range: NSRange) -> Self {
        let attributedString = attributedText?.xx_mutable().xx_underline(color, stytle: style, for: range)
        attributedText = attributedString
        return self
    }

    @discardableResult
    func xx_attributedDeleteLine(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.xx_mutable().xx_strikethrough(color, for: range)
        attributedText = attributedString
        return self
    }

    @discardableResult
    func xx_attributedFirstLineHeadIndent(_ indent: CGFloat) -> Self {
        let attributedString = attributedText?.xx_mutable().xx_firstLineHeadIndent(indent)
        attributedText = attributedString
        return self
    }

    @discardableResult
    func xx_attributedBliqueness(_ inclination: Float = 0, for range: NSRange) -> Self {
        let attributedString = attributedText?.xx_mutable().xx_obliqueness(inclination, for: range)
        attributedText = attributedString
        return self
    }

    @discardableResult
    func xx_attributedImage(
        _ image: String,
        bounds: CGRect = .zero,
        index: Int = 0
    ) -> Self {
        let mAttributedString = attributedText?.xx_mutable().xx_image(image, bounds: bounds, index: index)
        attributedText = mAttributedString
        return self
    }

    @discardableResult
    func xx_adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        adjustsFontSizeToFitWidth = adjusts
        return self
    }

    @discardableResult
    func xx_sizeToFit() -> Self {
        sizeToFit()
        return self
    }
}
