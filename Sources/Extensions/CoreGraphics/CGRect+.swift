
import CoreGraphics
import Foundation

public extension CGRect {
    var xx_center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    var xx_middle: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
}

public extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        self.init(origin: origin, size: size)
    }
}

public extension CGRect {
    func xx_resizing(to size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> CGRect {
        let sizeDelta = CGSize(width: size.width - width, height: size.height - height)
        let origin = CGPoint(x: minX - sizeDelta.width * anchor.x, y: minY - sizeDelta.height * anchor.y)
        return CGRect(origin: origin, size: size)
    }
}
