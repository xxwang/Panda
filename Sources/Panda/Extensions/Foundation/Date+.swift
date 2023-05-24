//
//  Date+.swift
//
//
//  Created by 王斌 on 2023/5/24.
//

import Foundation

private let calendar = Calendar.current
private let dateFormatter = DateFormatter()

// MARK: - 属性
public extension Date {
    /// 获取一个日历对象
    var calendar: Calendar {
        Calendar(identifier: Calendar.current.identifier)
    }
}

// MARK: - 时间单位
public extension Date {
    /// 日期中的`年份`
    ///
    ///     Date().year -> 2017
    ///     var someDate = Date()
    ///     someDate.year = 2000
    var year: Int {
        get { calendar.component(.year, from: self) }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            guard let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) else { return }
            self = date
        }
    }

    /// 日期中的`月份`
    ///
    ///     Date().month -> 1
    ///     var someDate = Date()
    ///     someDate.month = 10
    var month: Int {
        get { calendar.component(.month, from: self) }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            guard let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) else { return }
            self = date
        }
    }

    /// 日期中的`天`
    ///
    ///     Date().day -> 12
    ///     var someDate = Date()
    ///     someDate.day = 1
    var day: Int {
        get { calendar.component(.day, from: self) }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            guard let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) else { return }
            self = date
        }
    }

    /// 日期中的`小时`
    ///
    ///     Date().hour -> 17 // 5 pm
    ///     var someDate = Date()
    ///     someDate.hour = 13
    var hour: Int {
        get { calendar.component(.hour, from: self) }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentHours = calendar.component(.hour, from: self)
            let hoursToAdd = newValue - currentHours
            guard let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: self) else { return }
            self = date
        }
    }

    /// 日期中的`分钟`
    ///
    ///     Date().minute -> 39
    ///     var someDate = Date()
    ///     someDate.minute = 10
    var minute: Int {
        get {
            calendar.component(.minute, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = calendar.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }

    /// 日期中的`秒`
    ///
    ///     Date().second -> 55
    ///     var someDate = Date()
    ///     someDate.second = 15
    var second: Int {
        get { calendar.component(.second, from: self) }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = calendar.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            guard let date = calendar.date(byAdding: .second, value: secondsToAdd, to: self) else { return }
            self = date
        }
    }

    /// 日期中的`毫秒`
    ///
    ///     Date().millisecond -> 68
    ///
    ///     var someDate = Date()
    ///     someDate.millisecond = 68
    var millisecond: Int {
        get { calendar.component(.nanosecond, from: self) / 1_000_000 }
        set {
            let nanoSeconds = newValue * 1_000_000
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
            #endif
            guard allowedRange.contains(nanoSeconds) else { return }
            guard let date = calendar.date(bySetting: .nanosecond, value: nanoSeconds, of: self) else { return }
            self = date
        }
    }

    /// 日期中的`纳秒`
    ///
    ///     Date().nanosecond -> 981379985
    ///     var someDate = Date()
    ///     someDate.nanosecond = 981379985
    var nanosecond: Int {
        get { calendar.component(.nanosecond, from: self) }
        set {
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
            #endif
            guard allowedRange.contains(newValue) else { return }

            let currentNanoseconds = calendar.component(.nanosecond, from: self)
            let nanosecondsToAdd = newValue - currentNanoseconds

            guard let date = calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self) else { return }
            self = date
        }
    }
}

// MARK: - 构造方法
public extension Date {
    /// 根据`Calendar`和`DateComponents`创建`Date`
    /// - Parameters:
    ///   - calendar: 日历对象
    ///   - components: 日期组件
    init?(calendar: Calendar? = .current, components: DateComponents) {
        guard let date = calendar?.date(from: components) else { return nil }
        self = date
    }

    /// 根据日期字符串创建`Date`
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - formatter: 格式
    init?(string: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }

    /// 根据时间戳创建`Date`
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - isUnix: 是否是unix格式
    init(timestamp: TimeInterval, isUnix: Bool = true) {
        self.init(timeIntervalSince1970: isUnix ? timestamp : timestamp / 1000.0)
    }
}

// MARK: - Defaultable
extension Date: Defaultable {}
public extension Date {
    typealias Associatedtype = Date
    static func `default`() -> Associatedtype {
        if #available(iOS 15, *) {
            return Date.now
        } else {
            return Date()
        }
    }
}

// MARK: - 链式语法
extension Date {
    /// 修改年份
    /// - Parameter year: 年份
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_year(_ year: Int) -> Self {
        self.year = year
        return self
    }

    /// 修改月份
    /// - Parameter month: 月份
    /// - Returns: `Self`
    mutating func pd_month(_ month: Int) -> Self {
        self.month = month
        return self
    }

    /// 修改天
    /// - Parameter day: 天
    /// - Returns: `Self`
    mutating func pd_day(_ day: Int) -> Self {
        self.day = day
        return self
    }

    /// 修改小时
    /// - Parameter hour: 小时
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_hour(_ hour: Int) -> Self {
        self.hour = hour
        return self
    }

    /// 修改分钟
    /// - Parameter minute: 分钟
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_minute(_ minute: Int) -> Self {
        self.minute = minute
        return self
    }

    /// 修改秒
    /// - Parameter second: 秒
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_second(_ second: Int) -> Self {
        self.second = second
        return self
    }

    /// 修改毫秒
    /// - Parameter millisecond: 毫秒
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_millisecond(_ millisecond: Int) -> Self {
        self.millisecond = millisecond
        return self
    }

    /// 修改纳秒
    /// - Parameter nanosecond: 纳秒
    /// - Returns: `Self`
    @discardableResult
    mutating func pd_nanosecond(_ nanosecond: Int) -> Self {
        self.nanosecond = nanosecond
        return self
    }
}
