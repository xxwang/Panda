//
//  SCNMaterial+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import SceneKit
import UIKit

// MARK: - 构造方法
public extension SCNMaterial {
    /// 使用`特定漫反射颜色`初始化`SCN材质`
    /// - Parameter color:漫反射颜色
    convenience init(color: UIColor) {
        self.init()
        self.diffuse.contents = color
    }
}
