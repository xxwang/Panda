
import SceneKit
import UIKit


public extension SCNBox {

    convenience init(width: CGFloat, height: CGFloat, length: CGFloat) {
        self.init(width: width, height: height, length: length, chamferRadius: 0)
    }

    convenience init(sideLength: CGFloat, chamferRadius: CGFloat = 0) {
        self.init(width: sideLength, height: sideLength, length: sideLength, chamferRadius: chamferRadius)
    }

    convenience init(width: CGFloat, height: CGFloat, length: CGFloat, chamferRadius: CGFloat = 0, material: SCNMaterial) {
        self.init(width: width, height: height, length: length, chamferRadius: chamferRadius)
        materials = [material]
    }

    convenience init(sideLength: CGFloat, chamferRadius: CGFloat = 0, material: SCNMaterial) {
        self.init(width: sideLength, height: sideLength, length: sideLength, chamferRadius: chamferRadius)
        materials = [material]
    }

    convenience init(width: CGFloat, height: CGFloat, length: CGFloat, chamferRadius: CGFloat = 0, color: UIColor) {
        self.init(width: width, height: height, length: length, chamferRadius: chamferRadius)
        materials = [SCNMaterial(color: color)]
    }

    convenience init(sideLength: CGFloat, chamferRadius: CGFloat = 0, color: UIColor) {
        self.init(width: sideLength, height: sideLength, length: sideLength, chamferRadius: chamferRadius)
        materials = [SCNMaterial(color: color)]
    }
}
