
import SceneKit
import UIKit

public extension SCNSphere {

    convenience init(diameter: CGFloat) {
        self.init(radius: diameter / 2)
    }

    convenience init(radius: CGFloat, material: SCNMaterial) {
        self.init(radius: radius)
        self.materials = [material]
    }

    convenience init(radius: CGFloat, color: UIColor) {
        self.init(radius: radius, material: SCNMaterial(color: color))
    }

    convenience init(diameter: CGFloat, material: SCNMaterial) {
        self.init(radius: diameter / 2)
        self.materials = [material]
    }

    convenience init(diameter: CGFloat, color: UIColor) {
        self.init(diameter: diameter, material: SCNMaterial(color: color))
    }
}
