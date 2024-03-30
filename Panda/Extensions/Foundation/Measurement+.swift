//
//  Measurement+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import Foundation

public extension Measurement<UnitAngle> {
    /// 以`度数`为单位创建一个指定值的`Measurement`
    /// - Parameter value:指定单位的值
    /// - Returns:`Measurement`
    static func degrees(_ value: Double) -> Measurement<UnitAngle> {
        Measurement(value: value, unit: .degrees)
    }

    /// 以`弧分`为单位创建一个指定值的`Measurement`
    /// - Parameter value:指定单位的值
    /// - Returns:`Measurement`
    static func arcMinutes(_ value: Double) -> Measurement<UnitAngle> {
        Measurement(value: value, unit: .arcMinutes)
    }

    /// 以`弧秒`为单位创建一个指定值的`Measurement`
    /// - Parameter value:指定单位的值
    /// - Returns:`Measurement`
    static func arcSeconds(_ value: Double) -> Measurement<UnitAngle> {
        Measurement(value: value, unit: .arcSeconds)
    }

    /// 以`弧度`为单位创建一个指定值的`Measurement`
    /// - Parameter value:指定单位的值
    /// - Returns:`Measurement`
    static func radians(_ value: Double) -> Measurement<UnitAngle> {
        Measurement(value: value, unit: .radians)
    }

    /// 以`梯度`为单位创建一个指定值的`Measurement`
    /// - Parameter value:指定单位的值
    /// - Returns:`Measurement`
    static func gradians(_ value: Double) -> Measurement<UnitAngle> {
        Measurement(value: value, unit: .gradians)
    }

    /// 以`转数`为单位创建一个指定值的`Measurement`
    /// - Parameter value:指定单位的值
    /// - Returns:`Measurement`
    static func revolutions(_ value: Double) -> Measurement<UnitAngle> {
        Measurement(value: value, unit: .revolutions)
    }
}
