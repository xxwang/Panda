
import MapKit

public extension MKMapView {
    @available(iOS 11.0, tvOS 11.0, macOS 10.13, *)
    func pd_register<T: MKAnnotationView>(annotationViewWithClass name: T.Type) {
        self.register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: name))
    }

    func pd_dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type) -> T? {
        self.dequeueReusableAnnotationView(withIdentifier: String(describing: name)) as? T
    }

    @available(iOS 11.0, tvOS 11.0, macOS 10.13, *)
    func pd_dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type, for annotation: MKAnnotation) -> T? {
        guard let annotationView = self.dequeueReusableAnnotationView(
            withIdentifier: String(describing: name),
            for: annotation
        ) as? T else {
            fatalError("Couldn't find MKAnnotationView for \(String(describing: name))")
        }
        return annotationView
    }
}

public extension MKMapView {
    func pd_zoom(to coordinates: [CLLocationCoordinate2D], meter: Double, edgePadding: UIEdgeInsets, animated: Bool) {
        guard !coordinates.isEmpty else { return }

        guard coordinates.count == 1 else {
            let mkPolygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            self.setVisibleMapRect(mkPolygon.boundingMapRect, edgePadding: edgePadding, animated: animated)
            return
        }

        let coordinateRegion = MKCoordinateRegion(
            center: coordinates.first!,
            latitudinalMeters: meter,
            longitudinalMeters: meter
        )
        self.setRegion(coordinateRegion, animated: true)
    }
}
