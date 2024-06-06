
import UIKit

public extension CGMutablePath {
    func sk_path() -> CGPath {
        self
    }
}

extension CGMutablePath {
    @discardableResult
    func sk_addRect(_ rect: CGRect,
                    transform: CGAffineTransform = .identity) -> Self
    {
        self.addRect(rect, transform: transform)
        return self
    }

    @discardableResult
    func sk_addRoundedRect(in rect: CGRect,
                           cornerWidth: CGFloat,
                           cornerHeight: CGFloat,
                           transform: CGAffineTransform = .identity) -> Self
    {
        self.addRoundedRect(in: rect,
                            cornerWidth: cornerWidth,
                            cornerHeight: cornerHeight,
                            transform: transform)
        return self
    }

    @discardableResult
    func sk_addRects(_ rects: [CGRect],
                     transform: CGAffineTransform = .identity) -> Self
    {
        self.addRects(rects, transform: transform)
        return self
    }

    @discardableResult
    func sk_move(to point: CGPoint,
                 transform: CGAffineTransform = .identity) -> Self
    {
        self.move(to: point, transform: transform)
        return self
    }

    @discardableResult
    func sk_addLine(to point: CGPoint,
                    transform: CGAffineTransform = .identity) -> Self
    {
        self.addLine(to: point, transform: transform)
        return self
    }

    @discardableResult
    func sk_addQuadCurve(to end: CGPoint,
                         control: CGPoint,
                         transform: CGAffineTransform = .identity) -> Self
    {
        self.addQuadCurve(to: end,
                          control: control,
                          transform: transform)
        return self
    }

    @discardableResult
    func sk_addCurve(to end: CGPoint,
                     control1: CGPoint,
                     control2: CGPoint,
                     transform: CGAffineTransform = .identity) -> Self
    {
        self.addCurve(to: end,
                      control1: control1,
                      control2: control2,
                      transform: transform)
        return self
    }

    @discardableResult
    func sk_addLines(between points: [CGPoint],
                     transform: CGAffineTransform = .identity) -> Self
    {
        self.addLines(between: points, transform: transform)
        return self
    }

    @discardableResult
    func sk_addEllipse(in rect: CGRect,
                       transform: CGAffineTransform = .identity) -> Self
    {
        self.addEllipse(in: rect, transform: transform)
        return self
    }

    @discardableResult
    func sk_addRelativeArc(center: CGPoint,
                           radius: CGFloat,
                           startAngle: CGFloat,
                           delta: CGFloat,
                           transform: CGAffineTransform = .identity) -> Self
    {
        self.addRelativeArc(center: center,
                            radius: radius,
                            startAngle: startAngle,
                            delta: delta,
                            transform: transform)
        return self
    }

    @discardableResult
    func sk_addArc(center: CGPoint,
                   radius: CGFloat,
                   startAngle: CGFloat,
                   endAngle: CGFloat,
                   clockwise: Bool,
                   transform: CGAffineTransform = .identity) -> Self
    {
        self.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: clockwise,
                    transform: transform)
        return self
    }

    @discardableResult
    func sk_addArc(tangent1End: CGPoint,
                   tangent2End: CGPoint,
                   radius: CGFloat,
                   transform: CGAffineTransform = .identity) -> Self
    {
        self.addArc(tangent1End: tangent1End,
                    tangent2End: tangent2End,
                    radius: radius,
                    transform: transform)
        return self
    }

    @discardableResult
    func sk_addPath(_ path: CGPath,
                    transform: CGAffineTransform = .identity) -> Self
    {
        self.addPath(path, transform: transform)
        return self
    }
}
