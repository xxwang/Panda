import Foundation

public extension Measurement<UnitAngle> {
    /// 以`角度`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func pd_degrees(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .degrees)
    }

    /// 以`弧度`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func pd_radians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .radians)
    }

    /// 以`弧分`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func pd_arcMinutes(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcMinutes)
    }

    /// 以`弧秒`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func pd_arcSeconds(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcSeconds)
    }

    /// 以`梯度`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func pd_gradians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .gradians)
    }

    /// 以`转数`为单位创建一个指定值的`Measurement`
    /// - Parameter value: 指定单位的值
    /// - Returns: `Measurement`
    static func pd_revolutions(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .revolutions)
    }
}
