//
//  DateFormatter+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import Foundation

// MARK: - 构造方法
public extension DateFormatter {
    /// `DateFormatter`便利构造方法
    /// - Parameters:
    ///   - format: 格式化样式
    ///   - locale: 地区
    ///   - timeZone: 时区
    convenience init(format: String, locale: Locale? = nil, timeZone: TimeZone? = nil) {
        self.init()
        dateFormat = format
        if let locale {
            self.locale = locale
        }
        if let timeZone {
            self.timeZone = timeZone
        }
    }
}
