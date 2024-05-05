//
//  CAGradientLayer+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import QuartzCore
import UIKit

// MARK: - 构造方法
public extension CAGradientLayer {
    /// 创建渐变图层(`CAGradientLayer`)
    /// - Parameters:
    ///   - frame:图层尺寸及位置信息
    ///   - colors:颜色位置数组
    ///   - locations:颜色数组中颜色对应的位置
    ///   - start:渐变开始点
    ///   - end:渐变结束点
    ///   - type:渐变类型
    convenience init(_ frame: CGRect = .zero,
                     colors: [UIColor],
                     locations: [CGFloat]? = nil,
                     start: CGPoint,
                     end: CGPoint,
                     type: CAGradientLayerType = .axial)
    {
        self.init()

        pd_frame(frame)
            .pd_colors(colors)
            .pd_locations(locations ?? [])
            .pd_start(start)
            .pd_end(end)
            .pd_type(type)
    }
}

// MARK: - Defaultable
public extension CAGradientLayer {
    typealias Associatedtype = CAGradientLayer

    override class func `default`() -> Associatedtype {
        let layer = CAGradientLayer()
        return layer
    }
}

// MARK: - 链式语法
public extension CAGradientLayer {
    /// 设置渐变颜色数组
    /// - Parameter colors:要设置的渐变颜色数组
    /// - Returns:`Self`
    @discardableResult
    func pd_colors(_ colors: [UIColor]) -> Self {
        let cgColors = colors.map(\.cgColor)
        self.colors = cgColors
        return self
    }

    /// 设置渐变位置数组
    /// - Parameter locations:要设置的渐变位置数组
    /// - Returns:`Self`
    @discardableResult
    func pd_locations(_ locations: [CGFloat] = [0, 1]) -> Self {
        let locationNumbers = locations.map { flt in
            NSNumber(floatLiteral: flt)
        }
        self.locations = locationNumbers
        return self
    }

    /// 设置渐变开始位置
    /// - Parameter startPoint:渐变开始位置
    /// - Returns:`Self`
    @discardableResult
    func pd_start(_ startPoint: CGPoint = .zero) -> Self {
        self.startPoint = startPoint
        return self
    }

    /// 设置渐变结束位置
    /// - Parameter endPoint:渐变结束位置
    /// - Returns:`Self`
    @discardableResult
    func pd_end(_ endPoint: CGPoint = .zero) -> Self {
        self.endPoint = endPoint
        return self
    }

    /// 设置渐变类型
    /// - Parameter type:渐变类型
    /// - Returns:`Self`
    @discardableResult
    func pd_type(_ type: CAGradientLayerType) -> Self {
        self.type = type
        return self
    }
}
