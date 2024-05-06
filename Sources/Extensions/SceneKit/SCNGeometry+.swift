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
    var pd_boundingSize: SCNVector3 {
        return (boundingBox.max - boundingBox.min).pd_absolute
    }
}
