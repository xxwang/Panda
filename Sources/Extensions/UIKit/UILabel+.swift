//
//  UILabel+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import UIKit

// MARK: - 属性
public extension UILabel {
    /// 获取字体的大小
    var pd_fontSize: CGFloat {
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = minimumScaleFactor
        return font.pointSize * context.actualScaleFactor
    }

    /// 获取内容需要的高度(需要在`UILabel`宽度确定的情况下)
    var pd_requiredHeight: CGFloat {
        UILabel.default()
            .pd_frame(CGRect(x: 0, y: 0, width: frame.width, height: .greatestFiniteMagnitude))
            .pd_lineBreakMode(.byWordWrapping)
            .pd_font(font)
            .pd_text(text)
            .pd_attributedText(attributedText)
            .pd_sizeToFit()
            .pd_height
    }

    /// 获取`UILabel`的每一行字符串(需要`UILabel`具有宽度值)
    var pd_textLines: [String] {
        return (text ?? "").pd_lines(pd_width, font: font!)
    }

    /// 获取`UILabel`第一行内容
    var pd_firstLineString: String? {
        pd_linesContent().first
    }

    /// 判断`UILabel`中的内容是否被截断
    var pd_isTruncated: Bool {
        guard let labelText = text else { return false }
        // 计算理论上显示所有文字需要的尺寸
        let theorySize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        // 计算文本大小
        let labelTextSize = (labelText as NSString)
            .boundingRect(
                with: theorySize,
                options: .usesLineFragmentOrigin,
                attributes: [.font: font!],
                context: nil
            )

        // 计算理论上需要的行数
        let labelTextLines = Int(Foundation.ceil(labelTextSize.height / font.lineHeight))
        // 实际可显示的行数
        var labelShowLines = Int(Foundation.floor(bounds.size.height / font.lineHeight))
        if numberOfLines != 0 { labelShowLines = min(labelShowLines, numberOfLines) }
        // 比较两个行数来判断是否被截断
        return labelTextLines > labelShowLines
    }
}

// MARK: - 构造方法
public extension UILabel {
    /// 使用内容字符串来创建一个`UILabel`
    /// - Parameter text:内容字符串
    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    /// 使用内容字符串和字体样式来创建一个`UILabel`
    /// - Parameters:
    ///   - text:内容字符串
    ///   - style:字体样式
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        font = UIFont.preferredFont(forTextStyle: style)
        self.text = text
    }
}

// MARK: - 获取`UILabel`中内容大小
public extension UILabel {
    /// 获取`UILabel`中`字符串`的CGSize
    /// - Parameter lineWidth:最大宽度
    /// - Returns:`CGSize`
    func pd_textSize(_ lineWidth: CGFloat = sizer.screen.width) -> CGSize {
        return self.text?.pd_stringSize(lineWidth, font: self.font) ?? .zero
    }

    /// 获取`UILabel`中`属性字符串`的CGSize
    /// - Parameter lineWidth:最大宽度
    /// - Returns:`CGSize`
    func pd_attributedTextSize(_ lineWidth: CGFloat = sizer.screen.width) -> CGSize {
        return self.attributedText?.pd_attributedSize(lineWidth) ?? .zero
    }
}

// MARK: - 属性字符串
public extension UILabel {
    /// 设置图片/文字的混合内容
    /// - Parameters:
    ///   - text: 文本字符串
    ///   - images: 图片数组
    ///   - spacing: 间距
    ///   - scale: 缩放比例
    ///   - position: 图片插入位置
    ///   - isOrgin: 是否使用图片原始大小
    /// - Returns: `NSMutableAttributedString`
    @discardableResult
    func pd_blend(_ text: String?,
                  images: [UIImage?] = [],
                  spacing: CGFloat = 5,
                  scale: CGFloat,
                  position: Int = 0,
                  isOrgin: Bool = false) -> NSMutableAttributedString
    {
        // 头部字符串
        let headString = text?.pd_subString(to: position) ?? ""
        let attributedString = NSMutableAttributedString(string: headString)

        for image in images {
            guard let image else { continue }

            // 计算图片宽高
            let imageHeight = (isOrgin ? image.size.height : font.pointSize) * scale
            let imageWidth = (image.size.width / image.size.height) * imageHeight
            // 附件的Y坐标位置
            let attachTop = (font.lineHeight - font.pointSize) / 2

            // 使用图片附件创建属性字符串
            let imageAttributedString = NSTextAttachment.default()
                .pd_image(image)
                .pd_bounds(CGRect(x: -3, y: -attachTop, width: imageWidth, height: imageHeight))
                .toAttributedString()

            // 将图片属性字符串追加到`attribuedString`
            attributedString.append(imageAttributedString)
            // 文字间距只对文字有效
            attributedString.append(NSAttributedString(string: " "))
        }

        // 尾部字符串
        let tailString = text?.pd_subString(from: position) ?? ""
        attributedString.append(NSAttributedString(string: tailString))

        // 图文间距需要减去默认的空格宽度
        let spaceW = " ".pd_stringSize(.greatestFiniteMagnitude, font: font).width
        let range = NSRange(location: 0, length: images.count * 2)
        attributedString.addAttribute(.kern, value: spacing - spaceW, range: range)

        // 设置属性字符串到`UILabel`
        attributedText = attributedString

        return attributedString
    }

    /// 设置`text`属性
    /// - Parameters:
    ///   - text: 要设置的字符串
    ///   - lineSpacing: 行间距
    ///   - wordSpacing: 字间距
    /// - Returns: `NSMutableAttributedString`
    @discardableResult
    func pd_setText(_ text: String, lineSpacing: CGFloat, wordSpacing: CGFloat = 1) -> NSMutableAttributedString {
        // 段落样式
        let style = NSMutableParagraphStyle.default()
            .pd_lineBreakMode(.byCharWrapping)
            .pd_alignment(.left)
            .pd_lineSpacing(lineSpacing)
            .pd_hyphenationFactor(1.0)
            .pd_firstLineHeadIndent(0.0)
            .pd_paragraphSpacingBefore(0.0)
            .pd_headIndent(0)
            .pd_tailIndent(0)

        let attrString = text.pd_nsMutableAttributedString()
            .pd_addAttributes([
                .paragraphStyle: style,
                .kern: wordSpacing,
                .font: font ?? .systemFont(ofSize: 14),
            ])
        attributedText = attrString
        return attrString
    }

    /// 获取`UILabel`的文本行数及每一行的内容
    /// - Parameters:
    ///   - labelWidth:`UILabel`的宽度
    ///   - lineSpacing:行间距
    ///   - wordSpacing:字间距
    ///   - paragraphSpacing:段落间距
    /// - Returns:行数及每行内容
    func pd_linesContent(_ labelWidth: CGFloat? = nil,
                         lineSpacing: CGFloat = 0.0,
                         wordSpacing: CGFloat = 0.0,
                         paragraphSpacing: CGFloat = 0.0) -> [String]
    {
        guard let text, let font else { return [] }
        // UILabel的宽度
        let labelWidth: CGFloat = labelWidth ?? bounds.width

        // 段落样式
        let style = NSMutableParagraphStyle.default()
            .pd_lineBreakMode(lineBreakMode)
            .pd_alignment(textAlignment)
            .pd_lineSpacing(lineSpacing)
            .pd_paragraphSpacing(paragraphSpacing)
        // 属性列表
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: style,
            .kern: wordSpacing,
        ]

        // 创建属性字符串并设置属性
        let attributedString = text.pd_nsMutableAttributedString().pd_addAttributes(attributes)
        // 创建框架设置器
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)

        let path = CGMutablePath()
        // 2.5 是经验误差值
        path.addRect(CGRect(x: 0, y: 0, width: labelWidth - 2.5, height: CGFloat(MAXFLOAT)))
        let framef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        // 从框架设置器中获取行内容(Element == CTLine)
        let lines = CTFrameGetLines(framef) as NSArray

        // 结果
        var result = [String]()
        // 获取每行内容
        for line in lines {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            result.append(text.pd_subString(from: lineRange.location, length: lineRange.length))
        }
        return result
    }
}

// MARK: - Defaultable
extension UILabel {
    public typealias Associatedtype = UILabel

    override open class func `default`() -> Associatedtype {
        let label = UILabel()
        return label
    }
}

// MARK: - 链式语法
public extension UILabel {
    /// 设置文字
    /// - Parameter text:文字内容
    /// - Returns:`Self`
    @discardableResult
    func pd_text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    /// 设置文字行数
    /// - Parameter lines:行数
    /// - Returns:`Self`
    @discardableResult
    func pd_numberOfLines(_ lines: Int) -> Self {
        numberOfLines = lines
        return self
    }

    /// 设置换行模式
    /// - Parameter mode:模式
    /// - Returns:`Self`
    @discardableResult
    func pd_lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        lineBreakMode = mode
        return self
    }

    /// 设置文字对齐方式
    /// - Parameter alignment:对齐方式
    /// - Returns:`Self`
    @discardableResult
    func pd_textAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }

    /// 设置富文本文字
    /// - Parameter attributedText:富文本文字
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    }

    /// 设置文本颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_textColor(_ color: UIColor) -> Self {
        textColor = color
        return self
    }

    /// 设置文本高亮颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_highlightedTextColor(_ color: UIColor) -> Self {
        self.highlightedTextColor = color
        return self
    }

    /// 设置字体的大小
    /// - Parameter font:字体的大小
    /// - Returns:`Self`
    @discardableResult
    func pd_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    /// 设置字体的大小
    /// - Parameter fontSize:字体的大小
    /// - Returns:`Self`
    @discardableResult
    func pd_systemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.systemFont(ofSize: fontSize)
        return self
    }

    /// 设置字体的大小(粗体)
    /// - Parameter fontSize:字体的大小
    /// - Returns:`Self`
    @discardableResult
    func pd_boldSystemFont(_ fontSize: CGFloat) -> Self {
        font = UIFont.boldSystemFont(ofSize: fontSize)
        return self
    }

    /// 设置特定范围的字体
    /// - Parameters:
    ///   - font:字体
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedFont(_ font: UIFont, for range: NSRange) -> Self {
        let attribuedString = attributedText?.pd_mutable().pd_font(font, for: range)
        attributedText = attribuedString
        return self
    }

    /// 设置特定区域的文字颜色
    /// - Parameters:
    ///   - color:文字颜色
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedColor(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.pd_mutable().pd_foregroundColor(color, for: range)
        attributedText = attributedString
        return self
    }

    /// 设置行间距
    /// - Parameter spacing:行间距
    /// - Returns:`Self`
    @discardableResult
    func pd_lineSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.pd_mutable().pd_lineSpacing(spacing, for: (text ?? "").pd_fullNSRange())
        attributedText = attributedString
        return self
    }

    /// 设置字间距
    /// - Parameter spacing:字间距
    /// - Returns:`Self`
    @discardableResult
    func pd_wordSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.pd_mutable().pd_wordSpacing(spacing, for: (text ?? "").pd_fullNSRange())
        attributedText = attributedString
        return self
    }

    /// 设置特定范围的下划线
    /// - Parameters:
    ///   - color:下划线颜色
    ///   - style:下划线样式
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedUnderLine(_ color: UIColor, style: NSUnderlineStyle = .single, for range: NSRange) -> Self {
        let attributedString = attributedText?.pd_mutable().pd_underline(color, stytle: style, for: range)
        attributedText = attributedString
        return self
    }

    /// 设置特定范围的删除线
    /// - Parameters:
    ///   - color:删除线颜色
    ///   - range:范围
    @discardableResult
    func pd_attributedDeleteLine(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.pd_mutable().pd_strikethrough(color, for: range)
        attributedText = attributedString
        return self
    }

    /// 设置首行缩进
    /// - Parameter indent:进度宽度
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedFirstLineHeadIndent(_ indent: CGFloat) -> Self {
        let attributedString = attributedText?.pd_mutable().pd_firstLineHeadIndent(indent)
        attributedText = attributedString
        return self
    }

    /// 设置特定范围的倾斜
    /// - Parameters:
    ///   - inclination:倾斜度
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedBliqueness(_ inclination: Float = 0, for range: NSRange) -> Self {
        let attributedString = attributedText?.pd_mutable().pd_obliqueness(inclination, for: range)
        attributedText = attributedString
        return self
    }

    /// 往字符串中插入图片(属性字符串)
    /// - Parameters:
    ///   - image:图片资源(图片名称/URL地址)
    ///   - bounds:图片的大小,默认为.zero,即自动根据图片大小设置,并以底部基线为标准. y > 0 :图片向上移动；y < 0 :图片向下移动
    ///   - index:图片的位置,默认放在开头
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedImage(
        _ image: String,
        bounds: CGRect = .zero,
        index: Int = 0
    ) -> Self {
        let mAttributedString = attributedText?.pd_mutable().pd_image(image, bounds: bounds, index: index)
        attributedText = mAttributedString
        return self
    }

    /// 是否调整字体大小到适配宽度
    /// - Parameter adjusts:是否调整
    /// - Returns:`Self`
    @discardableResult
    func pd_adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        adjustsFontSizeToFitWidth = adjusts
        return self
    }

    /// 根据内容调整尺寸
    /// - Returns: `Self`
    @discardableResult
    func pd_sizeToFit() -> Self {
        sizeToFit()
        return self
    }
}
