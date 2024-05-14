import UIKit

public extension BinaryFloatingPoint {

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
        return String(self.xx_double())
    }

    func xx_cgPoint() -> CGPoint {
        return CGPoint(x: self.xx_cgFloat(), y: self.xx_cgFloat())
    }

    func xx_cgSize() -> CGSize {
        return CGSize(width: self.xx_cgFloat(), height: self.xx_cgFloat())
    }
}

public extension BinaryFloatingPoint {

    func xx_radians() -> Double {
        return self.xx_double() / 180.0 * Double.pi
    }

    func xx_degrees() -> Double {
        return self.xx_double() * (180.0 / Double.pi)
    }
}

public extension BinaryFloatingPoint {

    func xx_abs() -> Self {
        return Swift.abs(self)
    }

    func xx_ceil() -> Self {
        return Foundation.ceil(self)
    }

    func xx_floor() -> Self {
        return Foundation.floor(self)
    }

    func xx_roundToInt() -> Int {
        return Darwin.lround(self.xx_double())
    }

    func xx_truncate(places: Int) -> Self {
        let divisor = pow(10.0, places.xx_double())
        return Self((self.xx_double() * divisor).xx_floor() / divisor)
    }

    func xx_round(_ places: Int) -> Self {
        let divisor = pow(10.0, places.xx_double())
        return Self((self.xx_double() * divisor).rounded() / divisor)
    }

    func xx_rounded(_ places: Int, rule: FloatingPointRoundingRule) -> Self {
        let factor = Self(pow(10.0, Double(Swift.max(0, places))))
        return (self * factor).rounded(rule) / factor
    }
}
