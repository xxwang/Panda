
import CoreLocation
import Foundation

public extension CLVisit {
    func sk_location() -> CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
