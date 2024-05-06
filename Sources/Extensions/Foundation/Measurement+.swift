import Foundation

public extension Measurement<UnitAngle> {
    static func pd_degrees(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .degrees)
    }

    static func pd_radians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .radians)
    }

    static func pd_arcMinutes(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcMinutes)
    }

    static func pd_arcSeconds(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcSeconds)
    }

    static func pd_gradians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .gradians)
    }

    static func pd_revolutions(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .revolutions)
    }
}
