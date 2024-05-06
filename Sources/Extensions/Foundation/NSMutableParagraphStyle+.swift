import UIKit

extension NSMutableParagraphStyle: Defaultable {}
extension NSMutableParagraphStyle {
    public typealias Associatedtype = NSMutableParagraphStyle

    @objc open class func `default`() -> Associatedtype {
        let style = NSMutableParagraphStyle()
            .pd_hyphenationFactor(1.0)
            .pd_firstLineHeadIndent(0.0)
            .pd_paragraphSpacingBefore(0.0)
            .pd_headIndent(0)
            .pd_tailIndent(0)
        return style
    }
}

public extension NSMutableParagraphStyle {
    @discardableResult
    func pd_alignment(_ alignment: NSTextAlignment) -> Self {
        self.alignment = alignment
        return self
    }

    @discardableResult
    func pd_lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }

    @discardableResult
    func pd_lineSpacing(_ lineSpacing: CGFloat) -> Self {
        self.lineSpacing = lineSpacing
        return self
    }

    @discardableResult
    func pd_paragraphSpacing(_ paragraphSpacing: CGFloat) -> Self {
        self.paragraphSpacing = paragraphSpacing
        return self
    }

    @discardableResult
    func pd_hyphenationFactor(_ hyphenationFactor: Float) -> Self {
        self.hyphenationFactor = hyphenationFactor
        return self
    }

    @discardableResult
    func pd_firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> Self {
        self.firstLineHeadIndent = firstLineHeadIndent
        return self
    }

    @discardableResult
    func pd_paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> Self {
        self.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }

    @discardableResult
    func pd_headIndent(_ headIndent: CGFloat) -> Self {
        self.headIndent = headIndent
        return self
    }

    @discardableResult
    func pd_tailIndent(_ tailIndent: CGFloat) -> Self {
        self.tailIndent = tailIndent
        return self
    }
}
