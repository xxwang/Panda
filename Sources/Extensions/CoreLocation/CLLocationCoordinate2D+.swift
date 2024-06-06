
import CoreLocation

public extension CLLocationCoordinate2D {
    func sk_location() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

public extension CLLocationCoordinate2D {
    func sk_distance(to second: CLLocationCoordinate2D) -> Double {
        return sk_location().distance(from: second.sk_location())
    }
}
