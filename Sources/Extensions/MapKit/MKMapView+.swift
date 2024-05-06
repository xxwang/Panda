//
//  MKMapView+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import MapKit

// MARK: - 大头针复用
public extension MKMapView {
    /// 注册大头针
    /// - Parameter name: 继承自`MKAnnotationView`的类型
    @available(iOS 11.0, tvOS 11.0, macOS 10.13, *)
    func pd_register<T: MKAnnotationView>(annotationViewWithClass name: T.Type) {
        self.register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: name))
    }

    /// 获取`可重用`的大头针
    /// - Parameter name: 继承自`MKAnnotationView`的类型
    /// - Returns: 继承自`MKAnnotationView`的对象
    func pd_dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type) -> T? {
        self.dequeueReusableAnnotationView(withIdentifier: String(describing: name)) as? T
    }

    /// 获取`可重用`的大头针
    /// - Parameters:
    ///   - name: 继承自`MKAnnotationView`的类型
    ///   - annotation: 大头针对象
    /// - Returns: 继承自`MKAnnotationView`的对象
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

// MARK: - 方法
public extension MKMapView {
    /// 缩放地图区域
    /// - Parameters:
    ///   - coordinates: 由`CLLocationCoordinate2D`数组构成的区域
    ///   - meter: 缩放单位`米`
    ///   - edgePadding: 边界距离
    ///   - animated: 是否动画
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
