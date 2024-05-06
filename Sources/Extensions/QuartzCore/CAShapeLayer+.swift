
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
    func pd_path(_ path: CGPath) -> Self {
        self.path = path
        return self
    }

    @discardableResult
    func pd_lineWidth(_ width: CGFloat) -> Self {
        lineWidth = width
        return self
    }

    @discardableResult
    func pd_fillColor(_ color: UIColor) -> Self {
        fillColor = color.cgColor
        return self
    }

    @discardableResult
    func pd_strokeColor(_ color: UIColor) -> Self {
        strokeColor = color.cgColor
        return self
    }

    @discardableResult
    func pd_strokeStart(_ strokeStart: CGFloat) -> Self {
        self.strokeStart = strokeStart
        return self
    }

    @discardableResult
    func pd_strokeEnd(_ strokeEnd: CGFloat) -> Self {
        self.strokeEnd = strokeEnd
        return self
    }

    @discardableResult
    func pd_miterLimit(_ miterLimit: CGFloat) -> Self {
        self.miterLimit = miterLimit
        return self
    }

    @discardableResult
    func pd_lineCap(_ lineCap: CAShapeLayerLineCap) -> Self {
        self.lineCap = lineCap
        return self
    }

    @discardableResult
    func pd_lineJoin(_ lineJoin: CAShapeLayerLineJoin) -> Self {
        self.lineJoin = lineJoin
        return self
    }

    @discardableResult
    func pd_fillRule(_ fillRule: CAShapeLayerFillRule) -> Self {
        self.fillRule = fillRule
        return self
    }

    @discardableResult
    func pd_lineDashPhase(_ lineDashPhase: CGFloat) -> Self {
        self.lineDashPhase = lineDashPhase
        return self
    }

    @discardableResult
    func pd_lineDashPattern(_ lineDashPattern: [NSNumber]) -> Self {
        self.lineDashPattern = lineDashPattern
        return self
    }
}
