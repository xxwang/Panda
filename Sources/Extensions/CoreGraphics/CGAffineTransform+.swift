
import CoreGraphics
import UIKit

public extension CGAffineTransform {
    func sk_CATransform3D() -> CATransform3D {
        CATransform3DMakeAffineTransform(self)
    }
}
