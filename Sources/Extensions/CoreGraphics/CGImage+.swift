//
//  CGImage+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import CoreGraphics
import UIKit

// MARK: - 方法
public extension CGImage {
    /// `CGImage`转`UIImage`
    /// - Returns: `UIImage?`
    func toUIImage() -> UIImage? {
        UIImage(cgImage: self)
    }
}
