import CoreLocation

public extension CLGeocoder {
    static func xx_reverseGeocode(with location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        return CLGeocoder().reverseGeocodeLocation(location, completionHandler: completionHandler)
    }

    static func xx_locationEncode(with addr: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        return CLGeocoder().geocodeAddressString(addr, completionHandler: completionHandler)
    }
}
