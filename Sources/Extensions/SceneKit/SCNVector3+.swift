
import SceneKit
import UIKit


public extension SCNVector3 {

    var sk_absolute: SCNVector3 {
        return SCNVector3(Swift.abs(x), Swift.abs(y), Swift.abs(z))
    }

    var sk_length: Float {
        return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
    }

    var sk_normalized: SCNVector3 {
        let length = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
        return SCNVector3(x / length, y / length, z / length)
    }
}


public extension SCNVector3 {

    static func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }

    static func += (lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }

    static func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }

    static func -= (lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }

    static func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }

    static func *= (vector: inout SCNVector3, scalar: Float) {
        vector.x *= scalar
        vector.y *= scalar
        vector.z *= scalar
    }

    static func * (scalar: Float, vector: SCNVector3) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }

    static func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }

    static func /= (vector: inout SCNVector3, scalar: Float) {
        vector = SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }
}
