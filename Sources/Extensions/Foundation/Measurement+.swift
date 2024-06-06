import Foundation

public extension Measurement<UnitAngle> {
    static func sk_degrees(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .degrees)
    }

    static func sk_radians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .radians)
    }

    static func sk_arcMinutes(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcMinutes)
    }

    static func sk_arcSeconds(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcSeconds)
    }

    static func sk_gradians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .gradians)
    }

    static func sk_revolutions(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .revolutions)
    }
}
