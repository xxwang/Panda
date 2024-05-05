//
//  CGAffineTransform+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import CoreGraphics
import UIKit

// MARK: - 方法
public extension CGAffineTransform {
    /// `CGAffineTransform`转`CATransform3D`
    /// - Returns: `CATransform3D`
    func toCATransform3D() -> CATransform3D {
        CATransform3DMakeAffineTransform(self)
    }
}
