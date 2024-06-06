
import CoreGraphics
import QuartzCore

public extension CATransform3D {
    var sk_isIdentity: Bool {
        return CATransform3DIsIdentity(self)
    }

    var sk_isAffine: Bool {
        return CATransform3DIsAffine(self)
    }

    static var sk_identity: CATransform3D {
        return CATransform3DIdentity
    }
}

public extension CATransform3D {
    @inlinable
    init(tx: CGFloat, ty: CGFloat, tz: CGFloat) {
        self = CATransform3DMakeTranslation(tx, ty, tz)
    }

    @inlinable
    init(sx: CGFloat, sy: CGFloat, sz: CGFloat) {
        self = CATransform3DMakeScale(sx, sy, sz)
    }

    @inlinable
    init(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        self = CATransform3DMakeRotation(angle, x, y, z)
    }
}

public extension CATransform3D {
    func sk_cgAffineTransform() -> CGAffineTransform {
        return CATransform3DGetAffineTransform(self)
    }

    func sk_translatedBy(tx: CGFloat, ty: CGFloat, tz: CGFloat) -> CATransform3D {
        return CATransform3DTranslate(self, tx, ty, tz)
    }

    func sk_scaledBy(sx: CGFloat, sy: CGFloat, sz: CGFloat) -> CATransform3D {
        return CATransform3DScale(self, sx, sy, sz)
    }

    func sk_rotated(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) -> CATransform3D {
        return CATransform3DRotate(self, angle, x, y, z)
    }

    func sk_inverted() -> CATransform3D {
        return CATransform3DInvert(self)
    }

    func sk_concatenating(_ t2: CATransform3D) -> CATransform3D {
        return CATransform3DConcat(self, t2)
    }

    mutating func sk_translatedBy(tx: CGFloat, ty: CGFloat, tz: CGFloat) {
        self = CATransform3DTranslate(self, tx, ty, tz)
    }

    mutating func sk_scaledBy(sx: CGFloat, sy: CGFloat, sz: CGFloat) {
        self = CATransform3DScale(self, sx, sy, sz)
    }

    mutating func sk_rotated(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        self = CATransform3DRotate(self, angle, x, y, z)
    }

    mutating func sk_inverted() {
        self = CATransform3DInvert(self)
    }

    mutating func sk_concatenating(_ t2: CATransform3D) {
        self = CATransform3DConcat(self, t2)
    }
}

extension CATransform3D: Equatable {
    @inlinable
    public static func == (lhs: CATransform3D, rhs: CATransform3D) -> Bool {
        CATransform3DEqualToTransform(lhs, rhs)
    }
}
