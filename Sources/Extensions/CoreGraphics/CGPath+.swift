
import UIKit

public extension CGPath {
    func sk_mutable() -> CGMutablePath {
        return CGMutablePath().sk_addPath(self)
    }
}
