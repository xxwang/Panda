
import SceneKit
import UIKit


public extension SCNMaterial {

    convenience init(color: UIColor) {
        self.init()
        self.diffuse.contents = color
    }
}
