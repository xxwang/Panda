//
//  CGImage+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import CoreGraphics
import UIKit

// MARK: - 方法
public extension CGImage {
    /// `CGImage`转`UIImage`
    /// - Returns: `UIImage?`
    func pd_uiImage() -> UIImage? {
        return UIImage(cgImage: self)
    }
}
