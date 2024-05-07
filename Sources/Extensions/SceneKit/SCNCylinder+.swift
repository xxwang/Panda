
import SceneKit
import UIKit

public extension SCNCylinder {

    convenience init(diameter: CGFloat, height: CGFloat) {
        self.init(radius: diameter / 2, height: height)
    }

    convenience init(radius: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(radius: radius, height: height)
        self.materials = [material]
    }

    convenience init(diameter: CGFloat, height: CGFloat, material: SCNMaterial) {
        self.init(radius: diameter / 2, height: height)
        self.materials = [material]
    }

    convenience init(radius: CGFloat, height: CGFloat, color: UIColor) {
        self.init(radius: radius, height: height)
        self.materials = [SCNMaterial(color: color)]
    }

    convenience init(diameter: CGFloat, height: CGFloat, color: UIColor) {
        self.init(radius: diameter / 2, height: height)
        self.materials = [SCNMaterial(color: color)]
    }
}
