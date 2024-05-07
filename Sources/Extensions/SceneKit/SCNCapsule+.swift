
import SceneKit
import UIKit


public extension SCNCapsule {

    convenience init(capDiameter: CGFloat, height: CGFloat) {
        self.init(capRadius: capDiameter / 2, height: height)
    }

    convenience init(capRadius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(capRadius: capRadius, height: height)
        self.materials = [material]
    }

    convenience init(capDiameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(capRadius: capDiameter / 2, height: height)
        self.materials = [material]
    }

    convenience init(capRadius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(capRadius: capRadius, height: height)
        self.materials = [SCNMaterial(color: color)]
    }

    convenience init(capDiameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(capRadius: capDiameter / 2, height: height)
        self.materials = [SCNMaterial(color: color)]
    }
}
