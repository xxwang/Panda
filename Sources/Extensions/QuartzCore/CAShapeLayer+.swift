
import QuartzCore
import UIKit

public extension CAShapeLayer {
    typealias Associatedtype = CAShapeLayer

    override class func `default`() -> Associatedtype {
        let layer = CAShapeLayer()
        return layer
    }
}

public extension CAShapeLayer {
    @discardableResult
    func sk_path(_ path: CGPath) -> Self {
        self.path = path
        return self
    }

    @discardableResult
    func sk_lineWidth(_ width: CGFloat) -> Self {
        lineWidth = width
        return self
    }

    @discardableResult
    func sk_fillColor(_ color: UIColor) -> Self {
        fillColor = color.cgColor
        return self
    }

    @discardableResult
    func sk_strokeColor(_ color: UIColor) -> Self {
        strokeColor = color.cgColor
        return self
    }

    @discardableResult
    func sk_strokeStart(_ strokeStart: CGFloat) -> Self {
        self.strokeStart = strokeStart
        return self
    }

    @discardableResult
    func sk_strokeEnd(_ strokeEnd: CGFloat) -> Self {
        self.strokeEnd = strokeEnd
        return self
    }

    @discardableResult
    func sk_miterLimit(_ miterLimit: CGFloat) -> Self {
        self.miterLimit = miterLimit
        return self
    }

    @discardableResult
    func sk_lineCap(_ lineCap: CAShapeLayerLineCap) -> Self {
        self.lineCap = lineCap
        return self
    }

    @discardableResult
    func sk_lineJoin(_ lineJoin: CAShapeLayerLineJoin) -> Self {
        self.lineJoin = lineJoin
        return self
    }

    @discardableResult
    func sk_fillRule(_ fillRule: CAShapeLayerFillRule) -> Self {
        self.fillRule = fillRule
        return self
    }

    @discardableResult
    func sk_lineDashPhase(_ lineDashPhase: CGFloat) -> Self {
        self.lineDashPhase = lineDashPhase
        return self
    }

    @discardableResult
    func sk_lineDashPattern(_ lineDashPattern: [NSNumber]) -> Self {
        self.lineDashPattern = lineDashPattern
        return self
    }
}
