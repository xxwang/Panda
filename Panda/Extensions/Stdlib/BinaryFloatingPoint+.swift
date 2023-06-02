//
//  BinaryFloatingPoint+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 类型转换
public extension BinaryFloatingPoint {
    /// 转换为`Int`
    func toInt() -> Int {
        toNSNumber().intValue
    }

    /// 转换为`Int64`
    func toInt64() -> Int64 {
        toNSNumber().int64Value
    }

    /// 转换为`UInt`
    func toUInt() -> UInt {
        toNSNumber().uintValue
    }

    /// 转换为`UInt64`
    func toUInt64() -> UInt64 {
        toNSNumber().uint64Value
    }

    /// 转换为`Float`
    func toFloat() -> Float {
        toNSNumber().floatValue
    }

    /// 转换为`Double`
    func toDouble() -> Double {
        toNSNumber().doubleValue
    }

    /// 转换为`CGFloat`
    func toCGFloat() -> CGFloat {
        toDouble()
    }

    /// 转换为`NSNumber`
    func toNSNumber() -> NSNumber {
        NSNumber(value: Double(self))
    }

    /// 转换为`NSDecimalNumber`
    func toDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(value: Double(self))
    }

    /// 转换为`Decimal`
    func toDecimal() -> Decimal {
        toDecimalNumber().decimalValue
    }

    /// 转换为`String`
    func toString() -> String {
        String(toDouble())
    }

    /// 转换为`CGPoint`
    func toCGPoint() -> CGPoint {
        CGPoint(x: toCGFloat(), y: toCGFloat())
    }

    /// 转换为`CGSize`
    func toCGSize() -> CGSize {
        CGSize(width: toCGFloat(), height: toCGFloat())
    }
}

// MARK: - 角度/弧度转换
public extension BinaryFloatingPoint {
    /// `角度`转`弧度`(0-360) -> (0-2PI)
    /// - Returns: `Double`弧度
    func degreesAsRadians() -> Double {
        toDouble() / 180.0 * Double.pi
    }

    /// `弧度`转`角度`(0-2PI) -> (0-360)
    /// - Returns: `Double`角度
    func radiansAsDegrees() -> Double {
        toDouble() * (180.0 / Double.pi)
    }
}

// MARK: - 方法
public extension BinaryFloatingPoint {
    /// 取`绝对值`
    /// - Returns: `绝对值`
    func abs() -> Self {
        Swift.abs(self)
    }

    /// 向上取整
    /// - Returns: 取整结果
    func ceil() -> Self {
        Foundation.ceil(self)
    }

    /// 向下取整
    /// - Returns: 取整结果
    func floor() -> Self {
        Foundation.floor(self)
    }

    /// 四舍五入转`Int`
    /// - Returns: `Int`
    func roundToInt() -> Int {
        Darwin.lround(toDouble())
    }

    /// 截断到小数点后某一位
    /// - Parameter places:指定位数
    /// - Returns:截断后的结果
    func truncate(places: Int) -> Self {
        let divisor = pow(10.0, places.toDouble())
        return Self((toDouble() * divisor).floor() / divisor)
    }

    /// 四舍五入到小数点后某一位
    /// - Parameter places:指定位数
    /// - Returns:四舍五入后的结果
    func round(_ places: Int) -> Self {
        let divisor = pow(10.0, places.toDouble())
        return Self((toDouble() * divisor).rounded() / divisor)
    }

    /// 返回具有指定小数位数和舍入规则的舍入值.如果`places`为负数,小数部分则将使用'0'
    /// - Parameters:
    ///   - places:预期的小数位数
    ///   - rule:要使用的舍入规则
    /// - Returns:四舍五入的值
    func rounded(_ places: Int, rule: FloatingPointRoundingRule) -> Self {
        let factor = Self(pow(10.0, Double(Swift.max(0, places))))
        return (self * factor).rounded(rule) / factor
    }
}
