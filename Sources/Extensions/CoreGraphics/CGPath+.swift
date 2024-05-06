
import UIKit

public extension CGPath {

    func pd_mutable() -> CGMutablePath {
        return CGMutablePath().pd_addPath(self)
    }
}
