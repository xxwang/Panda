
import CoreGraphics
import Foundation

public extension CGFloat {
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

    func pd_nsNumber() -> NSNumber {
        return NSNumber(value: Double(self))
    }

    func pd_decimalNumber() -> NSDecimalNumber {
        return NSDecimalNumber(value: Double(self))
    }

    func pd_decimal() -> Decimal {
        return self.pd_decimalNumber().decimalValue
    }

    func pd_string() -> String {
        return String(self.pd_double())
    }
}

public extension CGFloat {
    func pd_radians() -> Double {
        return self.pd_double() / 180.0 * Double.pi
    }

    func pd_degrees() -> Double {
        return self.pd_double() * (180.0 / Double.pi)
    }

    func pd_abs() -> Self {
        return Swift.abs(self)
    }

    func pd_ceil() -> Self {
        return Foundation.ceil(self)
    }

    func pd_floor() -> Self {
        return Foundation.floor(self)
    }

    func pd_lround() -> Int {
        return Darwin.lround(Double(self))
    }

    func pd_truncate(places: Int) -> Self {
        let divisor = pow(10.0, places.pd_double())
        return Self(self.pd_double() * divisor / divisor)
    }

    func pd_round(_ places: Int) -> Self {
        let divisor = pow(10.0, places.pd_double())
        return Self((self.pd_double() * divisor).rounded() / divisor)
    }

    func pd_rounded(_ places: Int, rule: FloatingPointRoundingRule) -> Self {
        let factor = Self(pow(10.0, Double(Swift.max(0, places))))
        return (self * factor).rounded(rule) / factor
    }
}
