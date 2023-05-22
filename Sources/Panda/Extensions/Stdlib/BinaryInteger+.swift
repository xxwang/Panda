//
//  BinaryInteger+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import CoreGraphics
import Foundation

// MARK: - 类型转换
public extension BinaryInteger {
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

    /// 转换为`Character?`
    func toCharacter() -> Character? {
        guard let n = self as? Int,
              let scalar = UnicodeScalar(n)
        else {
            return nil
        }
        return Character(scalar)
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
public extension BinaryInteger {
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
public extension BinaryInteger {
    /// 数字转罗马数字
    /// - Returns: `String?`罗马数字
    func toRomanNumeral() -> String? {
        guard self > 0 else {
            return nil
        }

        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = toInt()

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
    ///     print(number.bytes) ->  "[255, 128]"
    /// - Returns: `[UInt8]`
    func toBytes() -> [UInt8] {
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
    func toStoreUnit() -> String {
        var value = toDouble()
        var index = 0
        let units = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        while value > 1024 {
            value /= 1024
            index += 1
        }
        return String(format: "%4.2f %@", value, units[index])
    }

    /// 生成`0-self`之间的`CountableRange<Int>`
    /// - Returns: `CountableRange<Int>`
    func toRange() -> CountableRange<Int> {
        let n = self as! Int
        return 0 ..< n
    }
}

// MARK: - 日期/时间
public extension BinaryInteger {
    /// `Int`时间戳转日期对象
    /// - Parameter isUnix:是否是`Unix`时间戳格式(默认`true`)
    /// - Returns:Date
    func toDate(isUnix: Bool = true) -> Date {
        Date(timeIntervalSince1970: TimeInterval(toDouble() / (isUnix ? 1.0 : 1000.0)))
    }

    /// `Int`时间戳转日期字符串
    /// - Parameters:
    ///   - dateFormat:日期格式化样式
    ///   - isUnix:是否是`Unix`时间戳格式(默认`true`)
    /// - Returns:表示日期的字符串
    func toDateString(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss", isUnix: Bool = true) -> String {
        let date = toDate(isUnix: isUnix)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }

    /// `时间戳`与`当前时间`的`时间差`
    /// - Parameter format:格式化样式`yyyy-MM-dd HH:mm:ss`
    /// - Returns:日期字符串
    func toNowDistance(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeInterval: toDouble(), since: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    /// `Int`时间戳转表示日期的字符串(`刚刚/x分钟前`)
    /// - Parameter isUnix:是否是`Unix`时间戳格式(默认`true`)
    /// - Returns:表示日期的字符串
    func toTimeline(isUnix: Bool = true) -> String {
        // 获取当前的时间戳
        let currentTimeStamp = Date().timeIntervalSince1970
        // 服务器时间戳(如果是毫秒 要除以1000)
        var serverTimeStamp = TimeInterval(self)
        if !isUnix {
            serverTimeStamp /= 1000.0
        }
        // 时间差
        let reduceTime: TimeInterval = currentTimeStamp - serverTimeStamp

        if reduceTime < 60 {
            return "刚刚"
        }

        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }

        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时前"
        }

        let days = Int(reduceTime / 3600 / 24)
        if days < 30 {
            return "\(days)天前"
        }

        let date = Date(timeIntervalSince1970: serverTimeStamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return formatter.string(from: date)
    }
}
