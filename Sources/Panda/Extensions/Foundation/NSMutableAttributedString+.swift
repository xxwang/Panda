//
//  NSMutableAttributedString+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

// MARK: - 链式语法
public extension NSMutableAttributedString {
    /// 设置指定`range`内的`字体`
    /// - Parameters:
    ///   - font:字体
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_font(_ font: UIFont, for range: NSRange? = nil) -> Self {
        let range = range ?? fullNSRange()
        return pd_addAttributes([NSAttributedString.Key.font: font], for: range)
    }

    /// 设置富文本文字的`字间距`
    /// - Parameters:
    ///   - wordSpacing:间距
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_wordSpacing(_ wordSpacing: CGFloat, for range: NSRange? = nil) -> Self {
        let range = range ?? fullNSRange()
        pd_addAttributes([.kern: wordSpacing], for: range)
        return self
    }

    /// 设置指定`range`内文字的`行间距`
    /// - Parameters:
    ///   - lineSpacing:行间距
    ///   - alignment:对齐方式
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_lineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> Self {
        let range = range ?? fullNSRange()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        return pd_addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: range)
    }

    /// 设置`文字`的`颜色`
    /// - Parameters:
    ///   - color:文字颜色
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_foregroundColor(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let range = range ?? fullNSRange()
        return pd_addAttributes([NSAttributedString.Key.foregroundColor: color], for: range)
    }

    /// 设置`range`内`文字`的`下划线`
    /// - Parameters:
    ///   - color:下划线颜色
    ///   - stytle:下划线样式
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_underline(_ color: UIColor, stytle: NSUnderlineStyle = .single, for range: NSRange? = nil) -> Self {
        let range = range ?? fullNSRange()

        let lineStytle = NSNumber(value: Int8(stytle.rawValue))
        return pd_addAttributes([
            NSAttributedString.Key.underlineStyle: lineStytle,
            NSAttributedString.Key.underlineColor: color,
        ], for: range)
    }

    /// 设置`range`内文字的`删除线`
    /// - Parameters:
    ///   - color:删除线颜色
    ///   - range:范围
    /// - Returns:`Self`
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
        let range = range ?? fullNSRange()
        return pd_addAttributes(attributes, for: range)
    }

    /// 添加`首行文字缩进`
    /// - Parameter indent:缩进宽度
    /// - Returns:`Self`
    @discardableResult
    func pd_firstLineHeadIndent(_ indent: CGFloat) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        return pd_addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], for: fullNSRange())
    }

    /// 设置`range`范围内`文字`的`倾斜`
    /// - Parameters:
    ///   - obliqueness:倾斜
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_obliqueness(_ obliqueness: Float = 0, for range: NSRange? = nil) -> Self {
        let range = range ?? fullNSRange()
        return pd_addAttributes([NSAttributedString.Key.obliqueness: obliqueness], for: range)
    }

    /// 插入`图片附件`到指定字符`index`,
    /// - Parameters:
    ///   - image:资源类型可为(`图片名称`/`图片URL`/`图片路径`/`网络图片`)网络图片需指定`bounds`
    ///   - bounds:图片的大小,默认`.zero`(以底部基线为基准`y>0:图片向上移动 y<0:图片向下移动`)
    ///   - index:图片的位置,默认插入到开头
    /// - Returns:`Self`
    @discardableResult
    func pd_image(_ image: String, bounds: CGRect = .zero, index: Int = 0) -> Self {
        // NSTextAttachment可以将要插入的图片作为特殊字符处理
        let attch = NSTextAttachment()
        attch.image = UIImage.loadImage(image)
        attch.bounds = bounds

        // 创建带有图片的富文本
        let string = NSAttributedString(attachment: attch)

        // 将图片添加到富文本
        insert(string, at: index)

        return self
    }

    /// 设置`range`内的`属性`
    /// - Parameters:
    ///   - attributes:属性
    ///   - range:范围
    /// - Returns:`Self`
    @discardableResult
    func pd_addAttributes(_ attributes: [NSAttributedString.Key: Any], for range: NSRange) -> Self {
        for name in attributes.keys {
            addAttribute(name, value: attributes[name] ?? "", range: range)
        }
        return self
    }

    /// 设置指定`文字`的`属性`
    /// - Parameters:
    ///   - attributes:属性
    ///   - text:文本
    /// - Returns:`Self`
    @discardableResult
    func pd_addAttributes(_ attributes: [NSAttributedString.Key: Any], for text: String) -> Self {
        let ranges = subNSRanges(with: [text])
        if !ranges.isEmpty {
            for name in attributes.keys {
                for range in ranges {
                    addAttribute(name, value: attributes[name] ?? "", range: range)
                }
            }
        }
        return self
    }

    /// 设置与`正则表达式`符合的`匹配项`的`属性`
    /// - Parameters:
    ///   - attributes:属性字典
    ///   - pattern:正则表达式
    ///   - options:匹配选项
    /// - Returns:`Self`
    @discardableResult
    func pd_addAttributes(_ attributes: [Key: Any], toRangesMatching pattern: String, options: NSRegularExpression.Options = []) -> Self {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else { return self }
        let matches = pattern.matches(in: string, options: [], range: NSRange(0 ..< length))

        for match in matches {
            pd_addAttributes(attributes, for: match.range)
        }

        return self
    }

    /// 将`属性`设置到与`target`匹配的结果
    /// - Parameters:
    ///   - attributes:属性字典
    ///   - target:目标字符串
    /// - Returns:`Self`
    @discardableResult
    func pd_addAttributes(_ attributes: [Key: Any], toOccurrencesOf target: some StringProtocol) -> Self {
        let pattern = "\\Q\(target)\\E"
        return pd_addAttributes(attributes, toRangesMatching: pattern)
    }
}
