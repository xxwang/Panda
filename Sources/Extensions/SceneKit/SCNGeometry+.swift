
import SceneKit
import UIKit

public extension SCNGeometry {
    var sk_boundingSize: SCNVector3 {
        return (boundingBox.max - boundingBox.min).sk_absolute
    }
}
