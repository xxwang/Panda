//
//  UILabel+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

// MARK: - 属性
public extension UILabel {
    /// 获取字体的大小
    var fontSize: CGFloat {
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = minimumScaleFactor
        return font.pointSize * context.actualScaleFactor
    }

    /// 获取内容需要的高度(需要在`UILabel`宽度确定的情况下)
    var requiredHeight: CGFloat {
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
    var textLines: [String] {
        (text ?? "").lines(pd_width, font: font!)
    }

    /// 获取`UILabel`第一行内容
    var firstLineString: String? {
        linesContent().1?.first
    }

    /// 判断`UILabel`中的内容是否被截断
    var isTruncated: Bool {
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

// MARK: - 获取`UILabel`中内容大小
public extension UILabel {
    /// 获取`UILabel`中`字符串`的CGSize
    /// - Parameter maxLineWidth:最大宽度
    /// - Returns:`CGSize`
    func textSize(_ maxLineWidth: CGFloat = SizeUtils.screenWidth) -> CGSize {
        if let attributedText { return attributedText.strSize(maxLineWidth) }
        if let text { text.strSize(maxLineWidth, font: font) ?? .zero }
        return .zero
    }
}

// MARK: - Defaultable
public extension UILabel {
    typealias Associatedtype = UILabel

    override class func `default`() -> Associatedtype {
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
        let attribuedString = attributedText?.toMutable().pd_font(font, for: range)
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
        let attributedString = attributedText?.toMutable().pd_foregroundColor(color, for: range)
        attributedText = attributedString
        return self
    }

    /// 设置行间距
    /// - Parameter spacing:行间距
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedLineSpacing(_ spacing: CGFloat) -> Self {
        let attributedString = attributedText?.toMutable().pd_lineSpacing(spacing, for: (text ?? "").fullNSRange())
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
        let attributedString = attributedText?.toMutable().pd_underline(color, stytle: style, for: range)
        attributedText = attributedString
        return self
    }

    /// 设置特定范围的删除线
    /// - Parameters:
    ///   - color:删除线颜色
    ///   - range:范围
    @discardableResult
    func pd_attributedDeleteLine(_ color: UIColor, for range: NSRange) -> Self {
        let attributedString = attributedText?.toMutable().pd_strikethrough(color, for: range)
        attributedText = attributedString
        return self
    }

    /// 设置首行缩进
    /// - Parameter indent:进度宽度
    /// - Returns:`Self`
    @discardableResult
    func pd_attributedFirstLineHeadIndent(_ indent: CGFloat) -> Self {
        let attributedString = attributedText?.toMutable().pd_firstLineHeadIndent(indent)
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
        let attributedString = attributedText?.toMutable().pd_obliqueness(inclination, for: range)
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
        let mAttributedString = attributedText?.toMutable().pd_image(image, bounds: bounds, index: index)
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
