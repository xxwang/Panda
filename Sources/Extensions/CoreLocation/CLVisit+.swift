
import CoreLocation
import Foundation

public extension CLVisit {

    func pd_location() -> CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
