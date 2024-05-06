//
//  CGPath+.swift
//
//
//  Created by xxwang on 2023/5/26.
//

import UIKit

public extension CGPath {
    /// 转换为`CGMutablePath`
    func pd_mutable() -> CGMutablePath {
        return CGMutablePath().pd_addPath(self)
    }
}
