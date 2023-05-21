//
//  CAShapeLayer+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import QuartzCore
import UIKit

// MARK: - Defaultable
public extension CAShapeLayer {
    typealias Associatedtype = CAShapeLayer

    override class func `default`() -> Associatedtype {
        let layer = CAShapeLayer()
        return layer
    }
}

// MARK: - 链式语法
public extension CAShapeLayer {
    /// 设置路径
    /// - Parameter path:路径
    /// - Returns:`Self`
    @discardableResult
    func pd_path(_ path: CGPath) -> Self {
        self.path = path
        return self
    }

    /// 设置线宽
    /// - Parameter width:线宽
    /// - Returns:`Self`
    @discardableResult
    func pd_lineWidth(_ width: CGFloat) -> Self {
        lineWidth = width
        return self
    }

    /// 设置填充颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_fillColor(_ color: UIColor) -> Self {
        fillColor = color.cgColor
        return self
    }

    /// 设置笔触颜色
    /// - Parameter color:颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_strokeColor(_ color: UIColor) -> Self {
        strokeColor = color.cgColor
        return self
    }

    /// 设置笔触开始
    /// - Parameter strokeStart:画笔开始
    /// - Returns:`Self`
    @discardableResult
    func pd_strokeStart(_ strokeStart: CGFloat) -> Self {
        self.strokeStart = strokeStart
        return self
    }

    /// 设置笔触结束
    /// - Parameter strokeEnd:画笔结束
    /// - Returns:`Self`
    @discardableResult
    func pd_strokeEnd(_ strokeEnd: CGFloat) -> Self {
        self.strokeEnd = strokeEnd
        return self
    }

    /// 设置最大斜接长度
    /// - Parameter miterLimit:最大斜接长度
    /// - Returns:`Self`
    @discardableResult
    func pd_miterLimit(_ miterLimit: CGFloat) -> Self {
        self.miterLimit = miterLimit
        return self
    }

    /// 设置线条末端线帽的样式。
    /// - Parameter lineCap:线帽样式
    /// - Returns:`Self`
    @discardableResult
    func pd_lineCap(_ lineCap: CAShapeLayerLineCap) -> Self {
        self.lineCap = lineCap
        return self
    }

    /// 设置所创建边角的类型
    /// - Parameter lineJoin:边角类型
    /// - Returns:`Self`
    @discardableResult
    func pd_lineJoin(_ lineJoin: CAShapeLayerLineJoin) -> Self {
        self.lineJoin = lineJoin
        return self
    }

    /// 设置填充路径的填充规则
    /// - Parameter fillRule:填充规则
    /// - Returns:`Self`
    @discardableResult
    func pd_fillRule(_ fillRule: CAShapeLayerFillRule) -> Self {
        self.fillRule = fillRule
        return self
    }

    /// 设置线型模版的起点
    /// - Parameter lineDashPhase:线型模版的起点
    /// - Returns:`Self`
    @discardableResult
    func pd_lineDashPhase(_ lineDashPhase: CGFloat) -> Self {
        self.lineDashPhase = lineDashPhase
        return self
    }

    /// 设置线性模版
    /// - Parameter lineDashPattern:线性模版
    /// - Returns:`Self`
    @discardableResult
    func pd_lineDashPattern(_ lineDashPattern: [NSNumber]) -> Self {
        self.lineDashPattern = lineDashPattern
        return self
    }
}
