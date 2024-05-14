
import CoreLocation
import Foundation

public extension CLVisit {
    func xx_location() -> CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
