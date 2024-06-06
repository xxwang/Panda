
import SpriteKit

public extension SKSpriteNode {

    func sk_aspectFill(to fillSize: CGSize) {
        guard let textureSize = texture?.size() else { return }

        let width = textureSize.width
        let height = textureSize.height

        guard width > 0, height > 0 else { return }

        let horizontalRatio = fillSize.width / width
        let verticalRatio = fillSize.height / height
        let ratio = horizontalRatio < verticalRatio ? horizontalRatio : verticalRatio
        self.size = CGSize(width: width * ratio, height: height * ratio)
    }
}
