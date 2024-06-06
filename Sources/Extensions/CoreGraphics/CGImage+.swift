
import CoreGraphics
import UIKit

public extension CGImage {
    func sk_uiImage() -> UIImage? {
        return UIImage(cgImage: self)
    }
}
