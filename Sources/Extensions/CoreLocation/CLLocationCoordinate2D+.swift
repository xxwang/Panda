//
//  CLLocationCoordinate2D+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import CoreLocation

// MARK: - 类型转换
public extension CLLocationCoordinate2D {
    /// `CLLocationCoordinate2D`转`CLLocation`
    /// - Returns: `CLLocation`
    func toLocation() -> CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}

// MARK: - 方法
public extension CLLocationCoordinate2D {
    /// 两个`CLLocationCoordinate2D`之间的`距离`(单位:`米`)
    /// - Parameter second:`CLLocationCoordinate2D`
    /// - Returns: `Double`
    func distance(to second: CLLocationCoordinate2D) -> Double {
        toLocation().distance(from: second.toLocation())
    }
}
