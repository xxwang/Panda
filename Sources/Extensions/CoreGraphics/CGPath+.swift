
import UIKit

public extension CGPath {
    func xx_mutable() -> CGMutablePath {
        return CGMutablePath().xx_addPath(self)
    }
}
