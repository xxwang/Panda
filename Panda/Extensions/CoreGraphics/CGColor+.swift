//
//  CGColor+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import CoreGraphics
import UIKit

// MARK: - 方法
public extension CGColor {
    /// `CGColor`转`UIColor`
    /// - Returns: `UIColor`
    func toUIColor() -> UIColor {
        UIColor(cgColor: self)
    }
}
