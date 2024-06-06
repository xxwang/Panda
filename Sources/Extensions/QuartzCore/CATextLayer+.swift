
import QuartzCore
import UIKit

public extension CATextLayer {
    typealias Associatedtype = CATextLayer

    override class func `default`() -> Associatedtype {
        let layer = CATextLayer()
        return layer
    }
}

public extension CATextLayer {
    @discardableResult
    func sk_string(_ string: String) -> Self {
        self.string = string
        return self
    }

    @discardableResult
    func sk_isWrapped(_ isWrapped: Bool) -> Self {
        self.isWrapped = isWrapped
        return self
    }

    @discardableResult
    func sk_truncationMode(_ truncationMode: CATextLayerTruncationMode) -> Self {
        self.truncationMode = truncationMode
        return self
    }

    @discardableResult
    func sk_alignmentMode(_ alignmentMode: CATextLayerAlignmentMode) -> Self {
        self.alignmentMode = alignmentMode
        return self
    }

    @discardableResult
    func sk_foregroundColor(_ foregroundColor: UIColor) -> Self {
        self.foregroundColor = foregroundColor.cgColor
        return self
    }

    @discardableResult
    func sk_contentsScale(_ scale: CGFloat = UIScreen.main.scale) -> Self {
        contentsScale = scale
        return self
    }

    @discardableResult
    func sk_font(_ font: UIFont) -> Self {
        self.font = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        return self
    }
}
