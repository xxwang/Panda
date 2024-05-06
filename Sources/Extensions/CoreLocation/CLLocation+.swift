
import UIKit
import CoreLocation

public extension CLLocation {

    static func pd_distance(_ start: CLLocation, end: CLLocation) -> Double {
        start.distance(from: end)
    }


    static func pd_midLocation(_ start: CLLocation, _ end: CLLocation) -> CLLocation {
        start.pd_middleLocation(to: end)
    }
}

public extension CLLocation {

    func pd_middleLocation(to point: CLLocation) -> CLLocation {
        let lat1 = Double.pi * coordinate.latitude / 180.0
        let long1 = Double.pi * coordinate.longitude / 180.0

        let lat2 = Double.pi * point.coordinate.latitude / 180.0
        let long2 = Double.pi * point.coordinate.longitude / 180.0

        let bxLoc = cos(lat2) * cos(long2 - long1)
        let byLoc = cos(lat2) * sin(long2 - long1)
        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bxLoc) * (cos(lat1) + bxLoc) + (byLoc * byLoc)))
        let mlong = long1 + atan2(byLoc, cos(lat1) + bxLoc)

        return CLLocation(latitude: mlat * 180 / Double.pi, longitude: mlong * 180 / Double.pi)
    }

    func pd_bearing(to destination: CLLocation) -> Double {
        let lat1 = Double.pi * coordinate.latitude / 180.0
        let long1 = Double.pi * coordinate.longitude / 180.0
        let lat2 = Double.pi * destination.coordinate.latitude / 180.0
        let long2 = Double.pi * destination.coordinate.longitude / 180.0

        let rads = atan2(
            sin(long2 - long1) * cos(lat2),
            cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1)
        )
        let degrees = rads * 180 / Double.pi

        return (degrees + 360).truncatingRemainder(dividingBy: 360)
    }

    func pd_reverseGeocode(completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completionHandler)
    }
}

public extension [CLLocation] {

    @available(tvOS 10.0, macOS 10.12, watchOS 3.0, *)
    func pd_distance(unitLength unit: UnitLength) -> Measurement<UnitLength> {
        guard count > 1 else {
            return Measurement(value: 0.0, unit: unit)
        }
        var distance: CLLocationDistance = 0.0
        for idx in 0 ..< count - 1 {
            distance += self[idx].distance(from: self[idx + 1])
        }
        return Measurement(value: distance, unit: UnitLength.meters).converted(to: unit)
    }
}
