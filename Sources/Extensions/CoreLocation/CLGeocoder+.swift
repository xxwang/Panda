//
//  CLGeocoder+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import CoreLocation

// MARK: - 静态方法
public extension CLGeocoder {
    /// 反地理编码(`坐标转地址`)
    /// - Parameters:
    ///   - completionHandler:回调函数
    static func pd_reverseGeocode(with location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler) {
        return CLGeocoder().reverseGeocodeLocation(location, completionHandler: completionHandler)
    }

    /// 地理编码(`地址转坐标`)
    /// - Parameters:
    ///   - completionHandler:回调函数
    static func pd_locationEncode(with addr: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        return CLGeocoder().geocodeAddressString(addr, completionHandler: completionHandler)
    }
}
