//
//  CGPath+.swift
//
//
//  Created by 王斌 on 2023/5/26.
//

import UIKit

public extension CGPath {
    /// 转换为`CGMutablePath`
    func toMutable() -> CGMutablePath {
        CGMutablePath().pd_addPath(self)
    }
}
