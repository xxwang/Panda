//
//  CALayer+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import QuartzCore
import UIKit

// MARK: - 方法
public extension CALayer {
    /// 图层转图片(需要图层已经有`size`)
    /// - Returns: `UIImage?`
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 图层转颜色(`UIColor`)
    /// - Returns: `UIColor?`
    func toUIColor() -> UIColor? {
        if let image = toImage() {
            return UIColor(patternImage: image)
        }
        return nil
    }
}

// MARK: - Defaultable
extension CALayer: Defaultable {}
public extension CALayer {
    typealias Associatedtype = CALayer

    @objc class func `default`() -> Associatedtype {
        let layer = CALayer()
        return layer
    }
}

// MARK: - 链式语法
public extension CALayer {
    /// 添加到父视图
    /// - Parameter superView:父视图(UIView)
    /// - Returns:`Self`
    @discardableResult
    func pd_add2(_ superView: UIView) -> Self {
        superView.layer.addSublayer(self)
        return self
    }

    /// 添加到父视图(CALayer)
    /// - Parameter superLayer:父视图(CALayer)
    /// - Returns:`Self`
    @discardableResult
    func pd_add2(_ superLayer: CALayer) -> Self {
        superLayer.addSublayer(self)
        return self
    }

    /// 设置frame
    /// - Parameter frame:frame
    /// - Returns:`Self`
    @discardableResult
    func pd_frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    /// 设置背景色
    /// - Parameter color:背景色
    /// - Returns:`Self`
    @discardableResult
    func pd_backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color.cgColor
        return self
    }

    /// 设置背景色 (十六进制字符串)
    /// - Parameter hex:背景色 (十六进制字符串)
    /// - Returns:`Self`
    @discardableResult
    func pd_backgroundColor(_ hex: String) -> Self {
        backgroundColor = UIColor(hex: hex).cgColor
        return self
    }

    /// 是否隐藏
    /// - Parameter isHidden:是否隐藏
    /// - Returns:`Self`
    @discardableResult
    func pd_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置边框宽度
    /// - Parameter width:边框宽度
    /// - Returns:`Self`
    @discardableResult
    func pd_borderWidth(_ width: CGFloat) -> Self {
        borderWidth = width
        return self
    }

    /// 设置边框颜色
    /// - Parameter color:边框颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_borderColor(_ color: UIColor) -> Self {
        borderColor = color.cgColor
        return self
    }

    /// 设置边框颜色(十六进制颜色值)
    /// - Parameter hex:边框颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_borderColor(_ hex: String) -> Self {
        borderColor = UIColor(hex: hex).cgColor
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize:是否开启光栅化
    /// - Returns:`Self`
    @discardableResult
    func pd_shouldRasterize(_ rasterize: Bool) -> Self {
        shouldRasterize = rasterize
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale:光栅化比例
    /// - Returns:`Self`
    @discardableResult
    func pd_rasterizationScale(_ scale: CGFloat) -> Self {
        rasterizationScale = scale
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color:阴影颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowColor(_ color: UIColor) -> Self {
        shadowColor = color.cgColor
        return self
    }

    /// 设置阴影颜色(十六进制颜色值)
    /// - Parameter hex:阴影颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowColor(_ hex: String) -> Self {
        shadowColor = UIColor(hex: hex).cgColor
        return self
    }

    /// 设置阴影的透明度,范围:`0~1`
    /// - Parameter opacity:阴影的透明度
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowOpacity(_ opacity: Float) -> Self {
        shadowOpacity = opacity
        return self
    }

    /// 设置阴影的偏移量
    /// - Parameter offset:偏移量
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowOffset(_ offset: CGSize) -> Self {
        shadowOffset = offset
        return self
    }

    /// 设置阴影圆角
    /// - Parameter radius:圆角大小
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowRadius(_ radius: CGFloat) -> Self {
        shadowRadius = radius
        return self
    }

    /// 添加阴影
    /// - Parameter path:阴影Path
    /// - Returns:`Self`
    @discardableResult
    func pd_shadowPath(_ path: CGPath) -> Self {
        shadowPath = path
        return self
    }

    /// 设置裁剪
    /// - Parameter masksToBounds:是否裁剪
    /// - Returns:`Self`
    @discardableResult
    func pd_masksToBounds(_ masksToBounds: Bool = true) -> Self {
        self.masksToBounds = masksToBounds
        return self
    }

    /// 设置圆角
    /// - Parameter cornerRadius:圆角
    /// - Returns:`Self`
    @discardableResult
    func pd_cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        return self
    }

    /// 设置圆角 ⚠️`frame`大小必须已确定
    /// - Parameters:
    ///   - radius:圆角半径
    ///   - corners:需要设置的角(默认全部)
    /// - Returns:`Self`
    @discardableResult
    func pd_corner(_ radius: CGFloat, corners: UIRectCorner = .allCorners) -> Self {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        mask = maskLayer

        return self
    }
}
