//
//  SKSpriteNode+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import SpriteKit

// MARK: - 方法
public extension SKSpriteNode {
    /// 等比例填充
    /// - Parameter fillSize:边界尺寸
    func aspectFill(to fillSize: CGSize) {
        guard let textureSize = texture?.size() else { return }

        let width = textureSize.width
        let height = textureSize.height

        guard width > 0, height > 0 else { return }

        let horizontalRatio = fillSize.width / width
        let verticalRatio = fillSize.height / height
        let ratio = horizontalRatio < verticalRatio ? horizontalRatio : verticalRatio
        size = CGSize(width: width * ratio, height: height * ratio)
    }
}
