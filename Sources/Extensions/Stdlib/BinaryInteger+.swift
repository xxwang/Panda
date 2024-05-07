import CoreGraphics
import Foundation

public extension BinaryInteger {

    func pd_nsNumber() -> NSNumber {
        return NSNumber(value: Double(self))
    }

    func pd_nsDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: Double(self))
    }

    func pd_decimal() -> Decimal {
        return self.pd_nsDecimalNumber().decimalValue
    }

    func pd_int() -> Int {
        return self.pd_nsNumber().intValue
    }

    func pd_int64() -> Int64 {
        return self.pd_nsNumber().int64Value
    }

    func pd_uInt() -> UInt {
        return self.pd_nsNumber().uintValue
    }

    func pd_uInt64() -> UInt64 {
        return self.pd_nsNumber().uint64Value
    }

    func pd_float() -> Float {
        return self.pd_nsNumber().floatValue
    }

    func pd_double() -> Double {
        return self.pd_nsNumber().doubleValue
    }

    func pd_cgFloat() -> CGFloat {
        return self.pd_double()
    }

    func pd_string() -> String {
        return String(self)
    }

    func pd_character() -> Character? {
        return Character(self.pd_string())
    }

    func pd_asciiCharacter() -> Character? {
        guard let n = self as? Int,
              let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    func pd_cgPoint() -> CGPoint {
        return CGPoint(x: self.pd_cgFloat(), y: self.pd_cgFloat())
    }

    func pd_cgSize() -> CGSize {
        return CGSize(width: self.pd_cgFloat(), height: self.pd_cgFloat())
    }
}

public extension BinaryInteger {

    func pd_radians() -> Double {
        return self.pd_double() / 180.0 * Double.pi
    }

    func pd_degrees() -> Double {
        return self.pd_double() * (180.0 / Double.pi)
    }
}

public extension BinaryInteger {

    func pd_isOdd() -> Bool {
        return self % 2 != 0
    }

    func pd_isEven() -> Bool {
        return self % 2 == 0
    }
}


public extension BinaryInteger {

    func pd_range() -> CountableRange<Int> {
        let n = self as! Int
        return 0 ..< n
    }

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

public extension BinaryInteger {

    func pd_date(isUnix: Bool = true) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.pd_double() / (isUnix ? 1.0 : 1000.0)))
    }

    func pd_mediaTimeString(component: Calendar.Component? = nil) -> String {
        if self <= 0 { return "00:00" }

        let second = self.pd_int() % 60
        if component == .second {
            return String(format: "%02d", self.pd_int())
        }

        var minute = Int(self / 60)
        if component == .minute {
            return String(format: "%02d:%02d", minute, second)
        }

        var hour = 0
        if minute >= 60 {
            hour = Int(minute / 60)
            minute = minute - hour * 60
        }

        if component == .hour {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }

        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }

        if minute > 0 {
            return String(format: "%02d:%02d", minute, second)
        }
        return String(format: "%02d", second)
    }
}
