
import SpriteKit

public extension SKNode {

    var sk_center: CGPoint {
        get {
            let contents = calculateAccumulatedFrame()
            return CGPoint(x: contents.midX, y: contents.midY)
        }
        set {
            let contents = calculateAccumulatedFrame()
            position = CGPoint(x: newValue.x - contents.midX, y: newValue.y - contents.midY)
        }
    }

    var sk_topLeft: CGPoint {
        get {
            let contents = calculateAccumulatedFrame()
            return CGPoint(x: contents.minX, y: contents.maxY)
        }
        set {
            let contents = calculateAccumulatedFrame()
            position = CGPoint(x: newValue.x - contents.minX, y: newValue.y - contents.maxY)
        }
    }

    var sk_topRight: CGPoint {
        get {
            let contents = calculateAccumulatedFrame()
            return CGPoint(x: contents.maxX, y: contents.maxY)
        }
        set {
            let contents = calculateAccumulatedFrame()
            position = CGPoint(x: newValue.x - contents.maxX, y: newValue.y - contents.maxY)
        }
    }

    var sk_bottomLeft: CGPoint {
        get {
            let contents = calculateAccumulatedFrame()
            return CGPoint(x: contents.minX, y: contents.minY)
        }
        set {
            let contents = calculateAccumulatedFrame()
            position = CGPoint(x: newValue.x - contents.minX, y: newValue.y - contents.minY)
        }
    }

    var sk_bottomRight: CGPoint {
        get {
            let contents = calculateAccumulatedFrame()
            return CGPoint(x: contents.maxX, y: contents.minY)
        }
        set {
            let contents = calculateAccumulatedFrame()
            position = CGPoint(x: newValue.x - contents.maxX, y: newValue.y - contents.minY)
        }
    }
}

public extension SKNode {

    func sk_descendants() -> [SKNode] {
        var children = children
        children.append(contentsOf: children.reduce(into: [SKNode]()) { $0.append(contentsOf: $1.sk_descendants()) })
        return children
    }
}
