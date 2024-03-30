//
//  DateComponents+.swift
//
//
//  Created by xxwang on 2023/5/24.
//

import UIKit

public extension DateComponents {}

// MARK: - Defaultable
extension DateComponents: Defaultable {}
public extension DateComponents {
    typealias Associatedtype = DateComponents

    static func `default`() -> Associatedtype {
        DateComponents()
    }
}

// MARK: - 链式语法
public extension DateComponents {
    /// 日历对象
    /// - Parameter calendar: 日历对象
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_calendar(_ calendar: Calendar) -> Self {
        self.calendar = calendar
        return self
    }

    /// 时区
    /// - Parameter timeZone: 时区
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    /// 时代
    /// - Parameter era: 时代
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_calendar(_ era: Int) -> Self {
        self.era = era
        return self
    }

    /// 年份
    /// - Parameter year: 年份
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_year(_ year: Int) -> Self {
        self.year = year
        return self
    }

    /// 月份
    /// - Parameter month: 月份
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_month(_ month: Int) -> Self {
        self.month = month
        return self
    }

    /// 天数
    /// - Parameter day: 天数
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_day(_ day: Int) -> Self {
        self.day = day
        return self
    }

    /// 小时
    /// - Parameter hour: 小时
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_hour(_ hour: Int) -> Self {
        self.hour = hour
        return self
    }

    /// 分钟
    /// - Parameter minute: 分钟
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_minute(_ minute: Int) -> Self {
        self.minute = minute
        return self
    }

    /// 秒钟
    /// - Parameter second: 秒钟
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_second(_ second: Int) -> Self {
        self.second = second
        return self
    }

    /// 纳秒
    /// - Parameter nanosecond: 纳秒
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_nanosecond(_ nanosecond: Int) -> Self {
        self.nanosecond = nanosecond
        return self
    }
}
