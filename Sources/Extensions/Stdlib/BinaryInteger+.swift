import CoreGraphics
import Foundation

// MARK: - 类型转换
public extension BinaryInteger {
    /// 转换为`NSNumber`
    /// - Returns: `NSNumber`
    func pd_nsNumber() -> NSNumber {
        return NSNumber(value: Double(self))
    }

    /// 转换为`NSDecimalNumber`
    /// - Returns: `NSDecimalNumber`
    func pd_nsDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: Double(self))
    }

    /// 转换为`Decimal`
    /// - Returns: `Decimal`
    func pd_decimal() -> Decimal {
        return self.pd_nsDecimalNumber().decimalValue
    }

    /// 转换为`Int`
    /// - Returns: `Int`
    func pd_int() -> Int {
        return self.pd_nsNumber().intValue
    }

    /// 转换为`Int64`
    /// - Returns: `Int64`
    func pd_int64() -> Int64 {
        return self.pd_nsNumber().int64Value
    }

    /// 转换为`UInt`
    /// - Returns: `UInt`
    func pd_uInt() -> UInt {
        return self.pd_nsNumber().uintValue
    }

    /// 转换为`UInt64`
    /// - Returns: `UInt64`
    func pd_uInt64() -> UInt64 {
        return self.pd_nsNumber().uint64Value
    }

    /// 转换为`Float`
    /// - Returns: `Float`
    func pd_float() -> Float {
        return self.pd_nsNumber().floatValue
    }

    /// 转换为`Double`
    /// - Returns: `Double`
    func pd_double() -> Double {
        return self.pd_nsNumber().doubleValue
    }

    /// 转换为`CGFloat`
    /// - Returns: `CGFloat`
    func pd_cgFloat() -> CGFloat {
        return self.pd_double()
    }

    /// 转换为`String`
    /// - Returns: `String`
    func pd_string() -> String {
        return String(self)
    }

    /// 转换为`Character?`
    /// - Returns: `Character?`
    func pd_character() -> Character? {
        return Character(self.pd_string())
    }

    /// 从`整数`转换成`Character?`
    /// - Returns: `Character?`
    func pd_asciiCharacter() -> Character? {
        guard let n = self as? Int,
              let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    /// 转换为`CGPoint`
    /// - Returns: `CGPoint`
    func pd_cgPoint() -> CGPoint {
        return CGPoint(x: self.pd_cgFloat(), y: self.pd_cgFloat())
    }

    /// 转换为`CGSize`
    /// - Returns: `CGSize`
    func pd_cgSize() -> CGSize {
        return CGSize(width: self.pd_cgFloat(), height: self.pd_cgFloat())
    }
}

// MARK: - 角度/弧度转换
public extension BinaryInteger {
    /// `角度`转`弧度`(0-360) -> (0-2PI)
    /// - Returns: `Double`弧度
    func pd_radians() -> Double {
        return self.pd_double() / 180.0 * Double.pi
    }

    /// `弧度`转`角度`(0-2PI) -> (0-360)
    /// - Returns: `Double`角度
    func pd_degrees() -> Double {
        return self.pd_double() * (180.0 / Double.pi)
    }
}

// MARK: - 判断
public extension BinaryInteger {
    /// 判断是否是奇数
    /// - Returns: `Bool`
    func pd_isOdd() -> Bool {
        return self % 2 != 0
    }

    /// 是否是偶数
    /// - Returns: `Bool`
    func pd_isEven() -> Bool {
        return self % 2 == 0
    }
}

// MARK: - 方法
public extension BinaryInteger {
    /// 生成`0-self`之间的`CountableRange<Int>`
    /// - Returns: `CountableRange<Int>`
    func pd_range() -> CountableRange<Int> {
        let n = self as! Int
        return 0 ..< n
    }

    /// 数字转罗马数字
    /// - Returns: `String?`罗马数字
    func pd_romanNumeral() -> String? {
        guard self > 0 else { return nil }

        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = self.pd_int()

        for (index, romanChar) in romanValues.enumerated() {
            let arabicValue = arabicValues[index]
            let div = startingValue / arabicValue
            for _ in 0 ..< div {
                romanValue.append(romanChar)
            }
            startingValue -= arabicValue * div
        }
        return romanValue
    }

    /// 转字节数组(`UInt8`数组)
    ///
    ///     var number = Int16(-128)
    ///     print(number.pd_bytes) ->  "[255, 128]"
    ///
    /// - Returns: `[UInt8]`
    func pd_bytes() -> [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Self>.size)
        var value = self
        for _ in 0 ..< MemoryLayout<Self>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }

    /// `byte(字节)`转换存储单位
    /// - Returns: `String`单位大小
    func pd_storeUnit() -> String {
        var value = self.pd_double()
        var index = 0
        let units = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while value > 1024 {
            value /= 1024
            index += 1
        }
        return String(format: "%4.2f %@", value, units[index])
    }
}

// MARK: - 日期/时间
public extension BinaryInteger {
    /// `Int`时间戳转日期对象
    /// - Parameter isUnix:是否是`Unix`时间戳格式(默认`true`)
    /// - Returns:Date
    func pd_date(isUnix: Bool = true) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.pd_double() / (isUnix ? 1.0 : 1000.0)))
    }

    /// 秒转换成播放时间条的格式
    /// - Parameters:
    ///   - component:格式类型`nil`为默认类型
    /// - Returns:返回时间条
    func pd_mediaTimeString(component: Calendar.Component? = nil) -> String {
        if self <= 0 { return "00:00" }

        // 秒
        let second = self.pd_int() % 60
        if component == .second {
            return String(format: "%02d", self.pd_int())
        }

        // 分钟
        var minute = Int(self / 60)
        if component == .minute {
            return String(format: "%02d:%02d", minute, second)
        }

        // 小时
        var hour = 0
        if minute >= 60 {
            hour = Int(minute / 60)
            minute = minute - hour * 60
        }

        if component == .hour {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }

        // normal 类型
        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }

        if minute > 0 {
            return String(format: "%02d:%02d", minute, second)
        }
        return String(format: "%02d", second)
    }
}
