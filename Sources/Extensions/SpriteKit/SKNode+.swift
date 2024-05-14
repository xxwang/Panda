
import SpriteKit

public extension SKNode {

    var xx_center: CGPoint {
        get {
            let contents = calculateAccumulatedFrame()
            return CGPoint(x: contents.midX, y: contents.midY)
        }
        set {
            let contents = calculateAccumulatedFrame()
            position = CGPoint(x: newValue.x - contents.midX, y: newValue.y - contents.midY)
        }
    }

    var xx_topLeft: CGPoint {
        get {
            let contents = calculateAccumulatedFrame()
            return CGPoint(x: contents.minX, y: contents.maxY)
        }
        set {
            let contents = calculateAccumulatedFrame()
            position = CGPoint(x: newValue.x - contents.minX, y: newValue.y - contents.maxY)
        }
    }

    var xx_topRight: CGPoint {
        get {
            let contents = calculateAccumulatedFrame()
            return CGPoint(x: contents.maxX, y: contents.maxY)
        }
        set {
            let contents = calculateAccumulatedFrame()
            position = CGPoint(x: newValue.x - contents.maxX, y: newValue.y - contents.maxY)
        }
    }

    var xx_bottomLeft: CGPoint {
        get {
            let contents = calculateAccumulatedFrame()
            return CGPoint(x: contents.minX, y: contents.minY)
        }
        set {
            let contents = calculateAccumulatedFrame()
            position = CGPoint(x: newValue.x - contents.minX, y: newValue.y - contents.minY)
        }
    }

    var xx_bottomRight: CGPoint {
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

    func xx_descendants() -> [SKNode] {
        var children = children
        children.append(contentsOf: children.reduce(into: [SKNode]()) { $0.append(contentsOf: $1.xx_descendants()) })
        return children
    }
}
