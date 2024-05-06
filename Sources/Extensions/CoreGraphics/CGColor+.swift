
import CoreGraphics
import UIKit

public extension CGColor {
    func pd_uiColor() -> UIColor {
        UIColor(cgColor: self)
    }
}
