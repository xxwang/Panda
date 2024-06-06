
import CoreGraphics
import Foundation

public extension CGFloat {
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

    func sk_nsNumber() -> NSNumber {
        return NSNumber(value: Double(self))
    }

    func sk_decimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: Double(self))
    }

    func sk_decimal() -> Decimal {
        return self.sk_decimalNumber().decimalValue
    }

    func sk_string() -> String {
        return String(self.sk_double())
    }
}

public extension CGFloat {
    func sk_radians() -> Double {
        return self.sk_double() / 180.0 * Double.pi
    }

    func sk_degrees() -> Double {
        return self.sk_double() * (180.0 / Double.pi)
    }

    func sk_abs() -> Self {
        return Swift.abs(self)
    }

    func sk_ceil() -> Self {
        return Foundation.ceil(self)
    }

    func sk_floor() -> Self {
        return Foundation.floor(self)
    }

    func sk_lround() -> Int {
        return Darwin.lround(Double(self))
    }

    func sk_truncate(places: Int) -> Self {
        let divisor = pow(10.0, places.sk_double())
        return Self(self.sk_double() * divisor / divisor)
    }

    func sk_round(_ places: Int) -> Self {
        let divisor = pow(10.0, places.sk_double())
        return Self((self.sk_double() * divisor).rounded() / divisor)
    }

    func sk_rounded(_ places: Int, rule: FloatingPointRoundingRule) -> Self {
        let factor = Self(pow(10.0, Double(Swift.max(0, places))))
        return (self * factor).rounded(rule) / factor
    }
}
