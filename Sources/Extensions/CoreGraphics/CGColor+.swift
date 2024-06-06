
import CoreGraphics
import UIKit

public extension CGColor {
    func sk_uiColor() -> UIColor {
        UIColor(cgColor: self)
    }
}
