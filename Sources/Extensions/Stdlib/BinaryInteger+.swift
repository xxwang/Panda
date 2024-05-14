import CoreGraphics
import Foundation

public extension BinaryInteger {

    func xx_nsNumber() -> NSNumber {
        return NSNumber(value: Double(self))
    }

    func xx_nsDecimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: Double(self))
    }

    func xx_decimal() -> Decimal {
        return self.xx_nsDecimalNumber().decimalValue
    }

    func xx_int() -> Int {
        return self.xx_nsNumber().intValue
    }

    func xx_int64() -> Int64 {
        return self.xx_nsNumber().int64Value
    }

    func xx_uInt() -> UInt {
        return self.xx_nsNumber().uintValue
    }

    func xx_uInt64() -> UInt64 {
        return self.xx_nsNumber().uint64Value
    }

    func xx_float() -> Float {
        return self.xx_nsNumber().floatValue
    }

    func xx_double() -> Double {
        return self.xx_nsNumber().doubleValue
    }

    func xx_cgFloat() -> CGFloat {
        return self.xx_double()
    }

    func xx_string() -> String {
        return String(self)
    }

    func xx_character() -> Character? {
        return Character(self.xx_string())
    }

    func xx_asciiCharacter() -> Character? {
        guard let n = self as? Int,
              let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    func xx_cgPoint() -> CGPoint {
        return CGPoint(x: self.xx_cgFloat(), y: self.xx_cgFloat())
    }

    func xx_cgSize() -> CGSize {
        return CGSize(width: self.xx_cgFloat(), height: self.xx_cgFloat())
    }
}

public extension BinaryInteger {

    func xx_radians() -> Double {
        return self.xx_double() / 180.0 * Double.pi
    }

    func xx_degrees() -> Double {
        return self.xx_double() * (180.0 / Double.pi)
    }
}

public extension BinaryInteger {

    func xx_isOdd() -> Bool {
        return self % 2 != 0
    }

    func xx_isEven() -> Bool {
        return self % 2 == 0
    }
}


public extension BinaryInteger {

    func xx_range() -> CountableRange<Int> {
        let n = self as! Int
        return 0 ..< n
    }

    func xx_romanNumeral() -> String? {
        guard self > 0 else { return nil }

        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = self.xx_int()

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

    func xx_bytes() -> [UInt8] {
        var result = [UInt8]()
        result.reserveCapacity(MemoryLayout<Self>.size)
        var value = self
        for _ in 0 ..< MemoryLayout<Self>.size {
            result.append(UInt8(truncatingIfNeeded: value))
            value >>= 8
        }
        return result.reversed()
    }

    func xx_storeUnit() -> String {
        var value = self.xx_double()
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

    func xx_date(isUnix: Bool = true) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.xx_double() / (isUnix ? 1.0 : 1000.0)))
    }

    func xx_mediaTimeString(component: Calendar.Component? = nil) -> String {
        if self <= 0 { return "00:00" }

        let second = self.xx_int() % 60
        if component == .second {
            return String(format: "%02d", self.xx_int())
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
