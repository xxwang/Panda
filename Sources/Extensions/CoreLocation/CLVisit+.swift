//
//  CLVisit+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import CoreLocation
import Foundation

// MARK: - 类型转换
public extension CLVisit {
    /// `CLVisit`转`CLLocation`
    /// - Returns: `CLLocation`
    func pd_location() -> CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
