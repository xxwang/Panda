
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
    func xx_path(_ path: CGPath) -> Self {
        self.path = path
        return self
    }

    @discardableResult
    func xx_lineWidth(_ width: CGFloat) -> Self {
        lineWidth = width
        return self
    }

    @discardableResult
    func xx_fillColor(_ color: UIColor) -> Self {
        fillColor = color.cgColor
        return self
    }

    @discardableResult
    func xx_strokeColor(_ color: UIColor) -> Self {
        strokeColor = color.cgColor
        return self
    }

    @discardableResult
    func xx_strokeStart(_ strokeStart: CGFloat) -> Self {
        self.strokeStart = strokeStart
        return self
    }

    @discardableResult
    func xx_strokeEnd(_ strokeEnd: CGFloat) -> Self {
        self.strokeEnd = strokeEnd
        return self
    }

    @discardableResult
    func xx_miterLimit(_ miterLimit: CGFloat) -> Self {
        self.miterLimit = miterLimit
        return self
    }

    @discardableResult
    func xx_lineCap(_ lineCap: CAShapeLayerLineCap) -> Self {
        self.lineCap = lineCap
        return self
    }

    @discardableResult
    func xx_lineJoin(_ lineJoin: CAShapeLayerLineJoin) -> Self {
        self.lineJoin = lineJoin
        return self
    }

    @discardableResult
    func xx_fillRule(_ fillRule: CAShapeLayerFillRule) -> Self {
        self.fillRule = fillRule
        return self
    }

    @discardableResult
    func xx_lineDashPhase(_ lineDashPhase: CGFloat) -> Self {
        self.lineDashPhase = lineDashPhase
        return self
    }

    @discardableResult
    func xx_lineDashPattern(_ lineDashPattern: [NSNumber]) -> Self {
        self.lineDashPattern = lineDashPattern
        return self
    }
}
