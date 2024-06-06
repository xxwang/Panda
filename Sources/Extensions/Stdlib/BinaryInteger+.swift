import CoreGraphics
import Foundation

public extension BinaryInteger {

    func sk_nsNumber() -> NSNumber {
        return NSNumber(value: Double(self))
    }

    func sk_nsDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: Double(self))
    }

    func sk_decimal() -> Decimal {
        return self.sk_nsDecimalNumber().decimalValue
    }

    func sk_int() -> Int {
        return self.sk_nsNumber().intValue
    }

    func sk_int64() -> Int64 {
        return self.sk_nsNumber().int64Value
    }

    func sk_uInt() -> UInt {
        return self.sk_nsNumber().uintValue
    }

    func sk_uInt64() -> UInt64 {
        return self.sk_nsNumber().uint64Value
    }

    func sk_float() -> Float {
        return self.sk_nsNumber().floatValue
    }

    func sk_double() -> Double {
        return self.sk_nsNumber().doubleValue
    }

    func sk_cgFloat() -> CGFloat {
        return self.sk_double()
    }

    func sk_string() -> String {
        return String(self)
    }

    func sk_character() -> Character? {
        return Character(self.sk_string())
    }

    func sk_asciiCharacter() -> Character? {
        guard let n = self as? Int,
              let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    func sk_cgPoint() -> CGPoint {
        return CGPoint(x: self.sk_cgFloat(), y: self.sk_cgFloat())
    }

    func sk_cgSize() -> CGSize {
        return CGSize(width: self.sk_cgFloat(), height: self.sk_cgFloat())
    }
}

public extension BinaryInteger {

    func sk_radians() -> Double {
        return self.sk_double() / 180.0 * Double.pi
    }

    func sk_degrees() -> Double {
        return self.sk_double() * (180.0 / Double.pi)
    }
}

public extension BinaryInteger {

    func sk_isOdd() -> Bool {
        return self % 2 != 0
    }

    func sk_isEven() -> Bool {
        return self % 2 == 0
    }
}


public extension BinaryInteger {

    func sk_range() -> CountableRange<Int> {
        let n = self as! Int
        return 0 ..< n
    }

    func sk_romanNumeral() -> String? {
        guard self > 0 else { return nil }

        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = self.sk_int()

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

    func sk_bytes() -> [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Self>.size)
        var value = self
        for _ in 0 ..< MemoryLayout<Self>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }

    func sk_storeUnit() -> String {
        var value = self.sk_double()
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

    func sk_date(isUnix: Bool = true) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.sk_double() / (isUnix ? 1.0 : 1000.0)))
    }

    func sk_mediaTimeString(component: Calendar.Component? = nil) -> String {
        if self <= 0 { return "00:00" }

        let second = self.sk_int() % 60
        if component == .second {
            return String(format: "%02d", self.sk_int())
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
