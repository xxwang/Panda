//
//  SCNGeometry+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import SceneKit
import UIKit

// MARK: - 属性
public extension SCNGeometry {
    /// 返回几何体边界框的大小
    var boundingSize: SCNVector3 {
        (boundingBox.max - boundingBox.min).absolute
    }
}
