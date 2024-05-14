
import SceneKit
import UIKit

public extension SCNGeometry {
    var xx_boundingSize: SCNVector3 {
        return (boundingBox.max - boundingBox.min).xx_absolute
    }
}
