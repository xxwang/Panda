
import UIKit

public extension UIBezierPath {

    convenience init(from: CGPoint, to otherPoint: CGPoint) {
        self.init()
        move(to: from)
        addLine(to: otherPoint)
    }

    convenience init(points: [CGPoint]) {
        self.init()
        if !points.isEmpty {
            move(to: points[0])
            for point in points[1...] {
                addLine(to: point)
            }
        }
    }

    convenience init?(polygonWithPoints points: [CGPoint]) {
        guard points.count > 2 else { return nil }
        self.init()
        move(to: points[0])
        for point in points[1...] {
            addLine(to: point)
        }
        close()
    }

    convenience init(ovalOf size: CGSize, centered: Bool) {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        self.init(ovalIn: CGRect(origin: origin, size: size))
    }

    convenience init(rectOf size: CGSize, centered: Bool) {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        self.init(rect: CGRect(origin: origin, size: size))
    }
}

public extension UIBezierPath {

    func sk_addArc(startPoint: CGPoint, centerPoint: CGPoint, endPoint: CGPoint, clockwise: Bool) {
        let arcCenter = sk_getCircleCenter(pontA: startPoint, pontB: centerPoint, pontC: endPoint)
        let radius = sk_getRadius(center: arcCenter, point: startPoint)
        let startAngle = sk_getAngle(center: arcCenter, point: startPoint)
        let endAngle = sk_getAngle(center: arcCenter, point: endPoint)
        addArc(withCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }

    func sk_addArc(arcCenter: CGPoint, startPoint: CGPoint, endPoint: CGPoint, clockwise: Bool) {
        let radius = sk_getRadius(center: arcCenter, point: startPoint)
        let startAngle = sk_getAngle(center: arcCenter, point: startPoint)
        let endAngle = sk_getAngle(center: arcCenter, point: endPoint)
        addArc(withCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }
}

private extension UIBezierPath {

    func sk_getCircleCenter(pontA: CGPoint, pontB: CGPoint, pontC: CGPoint) -> CGPoint {
        let abCenter = sk_getCenterPoint(pontA: pontA, pontB: pontB)
        let slopeAB = sk_getSlope(pontA: pontA, pontB: pontB)
        let slopeABVertical = -1 / slopeAB

        let bcCenter = sk_getCenterPoint(pontA: pontB, pontB: pontC)
        let slopeBC = sk_getSlope(pontA: pontB, pontB: pontC)
        let slopeBCVertical = -1 / slopeBC

        return sk_getCircleCenter(slopeA: slopeABVertical, pointA: abCenter, slopeB: slopeBCVertical, pointB: bcCenter)
    }

    func sk_getCircleCenter(slopeA: CGFloat, pointA: CGPoint, slopeB: CGFloat, pointB: CGPoint) -> CGPoint {
        let centerX = -(pointA.y - slopeA * pointA.x - pointB.y + slopeB * pointB.x) / (slopeA - slopeB)
        let centerY = pointA.y - slopeA * (pointA.x - centerX)
        return CGPoint(x: centerX, y: centerY)
    }

    func sk_getCenterPoint(pontA: CGPoint, pontB: CGPoint) -> CGPoint {
        CGPoint(x: (pontA.x + pontB.x) / 2, y: (pontA.y + pontB.y) / 2)
    }

    func sk_getSlope(pontA: CGPoint, pontB: CGPoint) -> CGFloat {
        (pontB.y - pontA.y) / (pontB.x - pontA.x)
    }

    func sk_getRadius(center: CGPoint, point: CGPoint) -> CGFloat {
        let a = Double(Swift.abs(point.x - center.x))
        let b = Double(Swift.abs(point.y - center.y))
        let radius = sqrtf(Float(a * a + b * b))
        return CGFloat(radius)
    }


    func sk_getAngle(center: CGPoint, point: CGPoint) -> CGFloat {
        let pointX = point.x
        let pointY = point.y

        let centerX = center.x
        let centerY = center.y

        let a = Swift.abs(pointX - centerX)
        let b = Swift.abs(pointY - centerY)

        var angle: Double = 0
        if angle > Double.pi / 2 {
            return CGFloat(angle)
        }
        if pointX > centerX, pointY >= centerY {
            angle = Double(atan(b / a))
        } else if pointX <= centerX, pointY > centerY {
            angle = Double(atan(a / b))
            if a == 0 {
                angle = 0
            }
            angle = angle + Double.pi / 2
        } else if pointX < centerX, pointY <= centerY {
            angle = Double(atan(b / a))
            if a == 0 {
                angle = 0
            }
            angle = angle + Double.pi

        } else if pointX >= centerX, pointY < centerY {
            angle = Double(atan(a / b))
            if a == 0 {
                angle = 0
            }
            angle = angle + Double.pi / 2 * 3
        }
        return CGFloat(angle)
    }
}

extension UIBezierPath: Defaultable {}
extension UIBezierPath {
    public typealias Associatedtype = UIBezierPath

    @objc open class func `default`() -> Associatedtype {
        let path = UIBezierPath()
        return path
    }
}

public extension UIBezierPath {}
