
import CoreGraphics
import UIKit

public extension CGVector {
    var sk_angle: CGFloat {
        atan2(dy, dx)
    }

    var sk_magnitude: CGFloat {
        sqrt((dx * dx) + (dy * dy))
    }
}

public extension CGVector {
    init(angle: CGFloat, magnitude: CGFloat) {
        self.init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }
}

public extension CGVector {
    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }

    static func * (scalar: CGFloat, vector: CGVector) -> CGVector {
        CGVector(dx: scalar * vector.dx, dy: scalar * vector.dy)
    }

    static func *= (vector: inout CGVector, scalar: CGFloat) {
        vector.dx *= scalar
        vector.dy *= scalar
    }

    static prefix func - (vector: CGVector) -> CGVector {
        CGVector(dx: -vector.dx, dy: -vector.dy)
    }
}
