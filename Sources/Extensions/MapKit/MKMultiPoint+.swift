//
//  MKMultiPoint+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import MapKit

// MARK: - 属性
public extension MKMultiPoint {
    /// 表示`MKMultiPoint`的坐标数组
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
