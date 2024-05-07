
import SceneKit
import UIKit


public extension SCNCone {

    convenience init(topDiameter: CGFloat, bottomDiameter: CGFloat, height: CGFloat) {
        self.init(topRadius: topDiameter / 2, bottomRadius: bottomDiameter / 2, height: height)
    }

    convenience init(topRadius: CGFloat, bottomRadius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(topRadius: topRadius, bottomRadius: bottomRadius, height: height)
        self.materials = [material]
    }

    convenience init(topDiameter: CGFloat, bottomDiameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(topRadius: topDiameter / 2, bottomRadius: bottomDiameter / 2, height: height)
        self.materials = [material]
    }

    convenience init(topRadius: CGFloat, bottomRadius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(topRadius: topRadius, bottomRadius: bottomRadius, height: height)
        self.materials = [SCNMaterial(color: color)]
    }

    convenience init(topDiameter: CGFloat, bottomDiameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(topRadius: topDiameter / 2, bottomRadius: bottomDiameter / 2, height: height)
        self.materials = [SCNMaterial(color: color)]
    }
}
