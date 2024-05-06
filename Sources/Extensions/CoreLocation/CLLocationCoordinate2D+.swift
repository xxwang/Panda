
import CoreLocation

public extension CLLocationCoordinate2D {
    func pd_location() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

public extension CLLocationCoordinate2D {
    func pd_distance(to second: CLLocationCoordinate2D) -> Double {
        return pd_location().distance(from: second.pd_location())
    }
}
