
import CoreGraphics
import UIKit

public extension CGSize {
    var sk_aspectRatio: CGFloat {
        guard height != 0 else { return 0 }
        return width / height
    }

    var sk_maxDimension: CGFloat {
        max(width, height)
    }

    var sk_minDimension: CGFloat {
        min(width, height)
    }
}

public extension CGSize {
    func sk_aspectFit(to size: CGSize) -> CGSize {
        let minRatio = min(size.width / width, size.height / height)
        return CGSize(width: width * minRatio, height: height * minRatio)
    }

    func sk_aspectFill(to size: CGSize) -> CGSize {
        let maxRatio = max(size.width / width, size.height / height)
        let aWidth = min(width * maxRatio, size.width)
        let aHeight = min(height * maxRatio, size.height)
        return CGSize(width: aWidth, height: aHeight)
    }
}

public extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func + (lhs: CGSize, tuple: (width: CGFloat, height: CGFloat)) -> CGSize {
        CGSize(width: lhs.width + tuple.width, height: lhs.height + tuple.height)
    }

    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    static func += (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width += tuple.width
        lhs.height += tuple.height
    }

    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func - (lhs: CGSize, tuple: (width: CGFloat, heoght: CGFloat)) -> CGSize {
        CGSize(width: lhs.width - tuple.width, height: lhs.height - tuple.heoght)
    }

    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    static func -= (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width -= tuple.width
        lhs.height -= tuple.height
    }

    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }

    static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: lhs.width * scalar, height: lhs.height * scalar)
    }

    static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
        CGSize(width: scalar * rhs.width, height: scalar * rhs.height)
    }

    static func *= (lhs: inout CGSize, scalar: CGFloat) {
        lhs.width *= scalar
        lhs.height *= scalar
    }
}
