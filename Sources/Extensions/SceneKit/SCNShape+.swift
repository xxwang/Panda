
import SceneKit
import UIKit

public extension SCNShape {

    convenience init(path: UIBezierPath, extrusionDepth: CGFloat, material: SCNMaterial) {
        self.init(path: path, extrusionDepth: extrusionDepth)
        self.materials = [material]
    }

    convenience init(path: UIBezierPath, extrusionDepth: CGFloat, color: UIColor) {
        self.init(path: path, extrusionDepth: extrusionDepth)
        self.materials = [SCNMaterial(color: color)]
    }
}
