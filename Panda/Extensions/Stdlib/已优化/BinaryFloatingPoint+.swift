import UIKit

// MARK: - 类型转换
public extension BinaryFloatingPoint {
    /// 转换为`NSNumber`
    /// - Returns: `NSNumber`
    func pd_NSNumber() -> NSNumber {
        return NSNumber(value: Double(self))
    }

    /// 转换为`NSDecimalNumber`
    /// - Returns: `NSDecimalNumber`
    func pd_NSDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: Double(self))
    }

    /// 转换为`Decimal`
    /// - Returns: `Decimal`
    func pd_Decimal() -> Decimal {
        return self.pd_NSDecimalNumber().decimalValue
    }

    /// 转换为`Int`
    /// - Returns: `Int`
    func pd_Int() -> Int {
        return self.pd_NSNumber().intValue
    }

    /// 转换为`Int64`
    /// - Returns: `Int64`
    func pd_Int64() -> Int64 {
        return self.pd_NSNumber().int64Value
    }

    /// 转换为`UInt`
    /// - Returns: `UInt`
    func pd_UInt() -> UInt {
        return self.pd_NSNumber().uintValue
    }

    /// 转换为`UInt64`
    /// - Returns: `UInt64`
    func pd_UInt64() -> UInt64 {
        return self.pd_NSNumber().uint64Value
    }

    /// 转换为`Float`
    /// - Returns: `Float`
    func pd_Float() -> Float {
        return self.pd_NSNumber().floatValue
    }

    /// 转换为`Double`
    /// - Returns: `Double`
    func pd_Double() -> Double {
        return self.pd_NSNumber().doubleValue
    }

    /// 转换为`CGFloat`
    /// - Returns: `CGFloat`
    func pd_CGFloat() -> CGFloat {
        return self.pd_Double()
    }

    /// 转换为`String`
    /// - Returns: `String`
    func pd_String() -> String {
        return String(self.pd_Double())
    }

    /// 转换为`CGPoint`
    /// - Returns: `CGPoint`
    func pd_CGPoint() -> CGPoint {
        return CGPoint(x: self.pd_CGFloat(), y: self.pd_CGFloat())
    }

    /// 转换为`CGSize`
    /// - Returns: `CGSize`
    func pd_CGSize() -> CGSize {
        return CGSize(width: self.pd_CGFloat(), height: self.pd_CGFloat())
    }
}

// MARK: - 角度/弧度转换
public extension BinaryFloatingPoint {
    /// `角度`转`弧度`(0-360) -> (0-2PI)
    /// - Returns: `Double`弧度
    func pd_radians() -> Double {
        return self.pd_Double() / 180.0 * Double.pi
    }

    /// `弧度`转`角度`(0-2PI) -> (0-360)
    /// - Returns: `Double`角度
    func pd_degrees() -> Double {
        return self.pd_Double() * (180.0 / Double.pi)
    }
}

// MARK: - 方法
public extension BinaryFloatingPoint {
    /// 取`绝对值`
    /// - Returns: `绝对值`
    func pd_abs() -> Self {
        return Swift.abs(self)
    }

    /// 向上取整
    /// - Returns: 取整结果
    func pd_ceil() -> Self {
        return Foundation.ceil(self)
    }

    /// 向下取整
    /// - Returns: 取整结果
    func pd_floor() -> Self {
        return Foundation.floor(self)
    }

    /// 四舍五入转`Int`
    /// - Returns: `Int`
    func pd_roundToInt() -> Int {
        return Darwin.lround(self.pd_Double())
    }

    /// 截断到小数点后某一位
    /// - Parameter places:指定位数
    /// - Returns:截断后的结果
    func pd_truncate(places: Int) -> Self {
        let divisor = pow(10.0, places.pd_Double())
        return Self((self.pd_Double() * divisor).pd_floor() / divisor)
    }

    /// 四舍五入到小数点后某一位
    /// - Parameter places:指定位数
    /// - Returns:四舍五入后的结果
    func pd_round(_ places: Int) -> Self {
        let divisor = pow(10.0, places.pd_Double())
        return Self((self.pd_Double() * divisor).rounded() / divisor)
    }

    /// 返回具有指定小数位数和舍入规则的舍入值.如果`places`为负数,小数部分则将使用'0'
    /// - Parameters:
    ///   - places:预期的小数位数
    ///   - rule:要使用的舍入规则
    /// - Returns:四舍五入的值
    func pd_rounded(_ places: Int, rule: FloatingPointRoundingRule) -> Self {
        let factor = Self(pow(10.0, Double(Swift.max(0, places))))
        return (self * factor).rounded(rule) / factor
    }
}
