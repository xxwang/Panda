
import CoreGraphics
import UIKit

public extension CGImage {
    func xx_uiImage() -> UIImage? {
        return UIImage(cgImage: self)
    }
}
