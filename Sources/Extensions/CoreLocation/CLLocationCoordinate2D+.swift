
import CoreLocation

public extension CLLocationCoordinate2D {
    func xx_location() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

public extension CLLocationCoordinate2D {
    func xx_distance(to second: CLLocationCoordinate2D) -> Double {
        return xx_location().distance(from: second.xx_location())
    }
}
