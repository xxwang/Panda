//
//  MKPolyline+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import MapKit

// MARK: - 构造方法
public extension MKPolyline {
    /// 根据提供的`CLLocationCoordinate2D`数组创建一条新的线段
    /// - Parameter coordinates: `CLLocationCoordinate2D`数组
    convenience init(coordinates: [CLLocationCoordinate2D]) {
        var refCoordinates = coordinates
        self.init(coordinates: &refCoordinates, count: refCoordinates.count)
    }
}
