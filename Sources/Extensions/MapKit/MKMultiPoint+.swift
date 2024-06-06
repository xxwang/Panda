
import MapKit

public extension MKMultiPoint {
    var sk_coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        self.getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
