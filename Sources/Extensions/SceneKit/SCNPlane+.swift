
import SceneKit
import UIKit


public extension SCNPlane {

    convenience init(width: CGFloat) {
        self.init(width: width, height: width)
    }

    convenience init(width: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(width: width, height: height)
        self.materials = [material]
    }

    convenience init(width: CGFloat, material: SCNMaterial) {
        self.init(width: width, height: width)
        self.materials = [material]
    }


    convenience init(width: CGFloat, height: CGFloat, color: UIColor) {
        self.init(width: width, height: height)
        self.materials = [SCNMaterial(color: color)]
    }

    convenience init(width: CGFloat, color: UIColor) {
        self.init(width: width, height: width)
        self.materials = [SCNMaterial(color: color)]
    }
}
