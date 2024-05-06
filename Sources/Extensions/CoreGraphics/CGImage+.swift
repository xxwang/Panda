
import CoreGraphics
import UIKit


public extension CGImage {

    func pd_uiImage() -> UIImage? {
        return UIImage(cgImage: self)
    }
}
