//
//  CATransform3D+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import CoreGraphics
import QuartzCore

// MARK: - 属性
public extension CATransform3D {
    /// 判断是否是`CATransform3D`默认对象
    var isIdentity: Bool {
        CATransform3DIsIdentity(self)
    }

    /// 如果`CATransform3D`可以用`CGAffineTransform`(`仿射变换`)精确表示，则返回 `true`
    var isAffine: Bool {
        CATransform3DIsAffine(self)
    }

    /// `CATransform3D`默认值(`[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]`)
    static var identity: CATransform3D {
        CATransform3DIdentity
    }
}

// MARK: - 构造方法
public extension CATransform3D {
    /// 创建一个值为 `(tx, ty, tz)` 的`CATransform3D`
    /// - Parameters:
    ///   - tx: x 轴平移
    ///   - ty: y轴平移
    ///   - tz: z 轴平移
    @inlinable
    init(tx: CGFloat, ty: CGFloat, tz: CGFloat) {
        self = CATransform3DMakeTranslation(tx, ty, tz)
    }

    /// 创建一个按 `(sx, sy, sz)` 缩放的`CATransform3D`
    /// - Parameters:
    ///   - sx:x 轴缩放
    ///   - sy:y轴缩放
    ///   - sz:z轴缩放
    @inlinable
    init(sx: CGFloat, sy: CGFloat, sz: CGFloat) {
        self = CATransform3DMakeScale(sx, sy, sz)
    }

    /// 创建一个围绕向量 `(x, y, z)` 旋转 `angle` 弧度的`CATransform3D`
    /// - Parameters:
    ///   - angle:旋转的角度
    ///   - x:向量的x位置
    ///   - y:向量的y位置
    ///   - z:向量的z位置
    @inlinable
    init(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        self = CATransform3DMakeRotation(angle, x, y, z)
    }
}

// MARK: - 方法
public extension CATransform3D {
    /// `CATransform3D`转`CGAffineTransform`失败,返回`identity`
    func toCGAffineTransform() -> CGAffineTransform {
        CATransform3DGetAffineTransform(self)
    }

    /// 通过平移`(tx, ty, tz)` 返回新的`CATransform3D`
    /// - Parameters:
    ///   - tx:x 轴平移
    ///   - ty:y 轴平移
    ///   - tz:z 轴平移
    /// - Returns:平移后的`CATransform3D`
    func translatedBy(tx: CGFloat, ty: CGFloat, tz: CGFloat) -> CATransform3D {
        CATransform3DTranslate(self, tx, ty, tz)
    }

    /// 通过缩放`(sx, sy, sz)` 返回新的`CATransform3D`
    /// - Parameters:
    ///   - sx:x 轴缩放
    ///   - sy:y 轴缩放
    ///   - sz:z 轴缩放
    /// - Returns:缩放后的`CATransform3D`
    func scaledBy(sx: CGFloat, sy: CGFloat, sz: CGFloat) -> CATransform3D {
        CATransform3DScale(self, sx, sy, sz)
    }

    /// 通过旋转`(x, y, z)` 返回新的`CATransform3D`
    /// - Parameters:
    ///   - angle:旋转的角度
    ///   - x:向量的x位置
    ///   - y:向量的y位置
    ///   - z:向量的z位置
    /// - Returns:旋转后的`CATransform3D`
    func rotated(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) -> CATransform3D {
        CATransform3DRotate(self, angle, x, y, z)
    }

    /// 反转`CATransform3D`
    /// - Returns:`CATransform3D`
    func inverted() -> CATransform3D {
        CATransform3DInvert(self)
    }

    /// 将两个`CATransform3D`连接,并生成新的`CATransform3D`
    /// - Parameter t2:`CATransform3D`
    /// - Returns: 新的`CATransform3D`
    func concatenating(_ t2: CATransform3D) -> CATransform3D {
        CATransform3DConcat(self, t2)
    }

    /// 通过平移`(tx, ty, tz)` 并赋值给`base`
    /// - Parameters:
    ///   - tx:x 轴平移
    ///   - ty:y 轴平移
    ///   - tz:z 轴平移
    /// - Returns:平移后的`CATransform3D`
    mutating func translatedBy(tx: CGFloat, ty: CGFloat, tz: CGFloat) {
        self = CATransform3DTranslate(self, tx, ty, tz)
    }

    /// 通过缩放`(sx, sy, sz)`  并赋值给`base`
    /// - Parameters:
    ///   - sx:x 轴缩放
    ///   - sy:y 轴缩放
    ///   - sz:z 轴缩放
    /// - Returns:缩放后的`CATransform3D`
    mutating func scaledBy(sx: CGFloat, sy: CGFloat, sz: CGFloat) {
        self = CATransform3DScale(self, sx, sy, sz)
    }

    /// 通过旋转`(x, y, z)`  并赋值给`base`
    /// - Parameters:
    ///   - angle:旋转的角度
    ///   - x:向量的x位置
    ///   - y:向量的y位置
    ///   - z:向量的z位置
    /// - Returns:旋转后的`CATransform3D`
    mutating func rotated(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        self = CATransform3DRotate(self, angle, x, y, z)
    }

    /// 反转`CATransform3D` 并赋值给`base`
    /// - Returns:`CATransform3D`
    mutating func inverted() {
        self = CATransform3DInvert(self)
    }

    /// 将两个`CATransform3D`连接, 并赋值给`base`
    /// - Parameter t2:`CATransform3D`
    /// - Returns: 新的`CATransform3D`
    mutating func concatenating(_ t2: CATransform3D) {
        self = CATransform3DConcat(self, t2)
    }
}

// MARK: - 运算符
extension CATransform3D: Equatable {
    /// 判断两个`CATransform3D`是否相等
    /// - Returns:是否相等
    @inlinable
    public static func == (lhs: CATransform3D, rhs: CATransform3D) -> Bool {
        CATransform3DEqualToTransform(lhs, rhs)
    }
}
