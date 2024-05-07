
import SceneKit
import UIKit

public extension SCNGeometry {
    var pd_boundingSize: SCNVector3 {
        return (boundingBox.max - boundingBox.min).pd_absolute
    }
}
