import Foundation

private let calendar = Calendar.current
private let dateFormatter = DateFormatter()

// MARK: - 日期名称格式枚举
public enum DayNameStyle {
    /// 日期名称的 3 个字母日期缩写
    case threeLetters
    /// 日期名称的 1 个字母日期缩写
    case oneLetter
    /// 完整的天名称
    case full
}

// MARK: - 月份名称格式枚举
public enum MonthNameStyle {
    /// 3 个字母月份的月份名称缩写
    case threeLetters
    /// 月份名称的 1 个字母月份缩写
    case oneLetter
    /// 完整的月份名称
    case full
}

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

// MARK: - 日期转换
public extension Date {
    /// `格林威治标准时间`转换为`当地时间`
    /// - Returns: `当地时间`
    func pd_dateFromGMT() -> Date {
        let secondFromGMT = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return addingTimeInterval(secondFromGMT)
    }

    /// `当地时间`转换为`格林威治标准时间`
    /// - Returns: `格林威治标准时间`
    func pd_dateToGMT() -> Date {
        let secondFromGMT = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return addingTimeInterval(-secondFromGMT)
    }
}

// MARK: - 方法
public extension Date {
    /// 日期字符串
    ///
    ///     Date().string(withFormat:"dd/MM/yyyy") -> "1/12/17"
    ///     Date().string(withFormat:"HH:mm") -> "23:50"
    ///     Date().string(withFormat:"dd/MM/yyyy HH:mm") -> "1/12/17 23:50"
    /// - Parameters:
    ///   - format: 日期格式(默认 `yyyy-MM-dd HH:mm:ss`)
    ///   - isGMT: 是否是`格林尼治时区`
    /// - Returns: 日期字符串
    func pd_toString(with dateFormat: String = "yyyy-MM-dd HH:mm:ss",
                     isGMT: Bool = false) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = .current
        dateFormatter.timeZone = isGMT ? TimeZone(secondsFromGMT: 0) : TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self)
    }

    /// 日期字符串
    ///
    ///     Date().toDateString(ofStyle:.short) -> "1/12/17"
    ///     Date().toDateString(ofStyle:.medium) -> "Jan 12, 2017"
    ///     Date().toDateString(ofStyle:.long) -> "January 12, 2017"
    ///     Date().toDateString(ofStyle:.full) -> "Thursday, January 12, 2017"
    ///
    /// - Parameter style:日期格式的样式(默认 `.medium`)
    /// - Returns:日期字符串
    func pd_toDateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    /// 日期和时间字符串
    ///
    ///     Date().toDateTimeString(ofStyle:.short) -> "1/12/17, 7:32 PM"
    ///     Date().toDateTimeString(ofStyle:.medium) -> "Jan 12, 2017, 7:32:00 PM"
    ///     Date().toDateTimeString(ofStyle:.long) -> "January 12, 2017 at 7:32:00 PM GMT+3"
    ///     Date().toDateTimeString(ofStyle:.full) -> "Thursday, January 12, 2017 at 7:32:00 PM GMT+03:00"
    ///
    /// - Parameter style:日期格式的样式(默认 `.medium`)
    /// - Returns:日期和时间字符串
    func pd_toDateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    /// 从日期开始的时间字符串
    ///
    ///     Date().toTimeString(ofStyle:.short) -> "7:37 PM"
    ///     Date().toTimeString(ofStyle:.medium) -> "7:37:02 PM"
    ///     Date().toTimeString(ofStyle:.long) -> "7:37:02 PM GMT+3"
    ///     Date().toTimeString(ofStyle:.full) -> "7:37:02 PM GMT+03:00"
    ///
    /// - Parameter style:日期格式的样式(默认 `.medium`)
    /// - Returns:时间字符串
    func pd_toTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }

    /// 从日期开始的月份名称
    ///
    ///     Date().monthName(ofStyle:.oneLetter) -> "J"
    ///     Date().monthName(ofStyle:.threeLetters) -> "Jan"
    ///     Date().monthName(ofStyle:.full) -> "January"
    ///
    /// - Parameter Style:月份名称的样式(默认 `MonthNameStyle.full`)
    /// - Returns:月份名称字符串(例如:`D、Dec、December`)
    func pd_monthName(ofStyle style: MonthNameStyle = .full) -> String {
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "MMMMM"
            case .threeLetters:
                return "MMM"
            case .full:
                return "MMMM"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    /// 日期名称
    ///
    ///     Date().dayName(ofStyle:.oneLetter) -> "T"
    ///     Date().dayName(ofStyle:.threeLetters) -> "Thu"
    ///     Date().dayName(ofStyle:.full) -> "Thursday"
    ///
    /// - Parameter Style:日期名称的样式(默认 `DayNameStyle.full`)
    /// - Returns:日期名称字符串(例如:`W、Wed、Wednesday`)
    func pd_dayName(ofStyle style: DayNameStyle = .full) -> String {
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "EEEEE"
            case .threeLetters:
                return "EEE"
            case .full:
                return "EEEE"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    /// 获取两个日期之间的天数
    ///
    /// - Parameter date:参与比较的日期
    /// - Returns:self 和给定日期之间的天数
    func pd_daysSince(_ date: Date) -> Double {
        timeIntervalSince(date) / (3600 * 24)
    }

    /// 获取两个日期之间的小时数
    ///
    /// - Parameter date:参与比较的日期
    /// - Returns:self 和给定日期之间的小时数
    func pd_hoursSince(_ date: Date) -> Double {
        timeIntervalSince(date) / 3600
    }

    /// 获取两个日期之间的分钟数
    ///
    /// - Parameter date:参与比较的日期
    /// - Returns:self 和给定日期之间的分钟数
    func pd_minutesSince(_ date: Date) -> Double {
        timeIntervalSince(date) / 60
    }

    /// 获取两个日期之间的秒数
    ///
    /// - Parameter date:参与比较的日期
    /// - Returns:self 和给定日期之间的秒数
    func pd_secondsSince(_ date: Date) -> Double {
        timeIntervalSince(date)
    }

    /// 比较`other`与当前日期之间的距离
    /// - Parameter date: 要比较的日期
    /// - Returns: `TimeInterval`
    func pd_distance(other date: Date) -> TimeInterval {
        timeIntervalSince(date)
    }

    /// 取得与当前时间的间隔差
    /// - Returns:时间差
    func pd_callTimeAfterNow() -> String {
        // 获取时间间隔
        let timeInterval = Date().timeIntervalSince(self)
        // 后缀
        let suffix = timeInterval > 0 ? "前" : "后"

        let interval = fabs(timeInterval) // 秒数
        let minute = interval / 60 // 分钟
        let hour = interval / 3600 // 小时
        let day = interval / 86400 // 天
        let month = interval / 2_592_000 // 月
        let year = interval / 31_104_000 // 年

        var time: String!
        if minute < 1 {
            time = interval > 0 ? "刚刚" : "马上"
        } else if hour < 1 {
            let s = NSNumber(value: minute as Double).intValue
            time = "\(s)分钟\(suffix)"
        } else if day < 1 {
            let s = NSNumber(value: hour as Double).intValue
            time = "\(s)小时\(suffix)"
        } else if month < 1 {
            let s = NSNumber(value: day as Double).intValue
            time = "\(s)天\(suffix)"
        } else if year < 1 {
            let s = NSNumber(value: month as Double).intValue
            time = "\(s)个月\(suffix)"
        } else {
            let s = NSNumber(value: year as Double).intValue
            time = "\(s)年\(suffix)"
        }
        return time
    }

    /// 当前`时区`的`日期`
    func pd_currentZoneDate() -> Date {
        let date = Date()
        let zone = NSTimeZone.system
        let time = zone.secondsFromGMT(for: date)
        let dateNow = date.addingTimeInterval(TimeInterval(time))

        return dateNow
    }

    /// 将日期格式化为`ISO8601`标准的格式`(yyyy-MM-dd'T'HH:mm:ss.SSS)`
    ///
    ///     Date().iso8601String -> "2017-01-12T14:51:29.574Z"
    func pd_iso8601String() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: self).appending("Z")
    }

    /// ` 距离最近`的可以被`五分钟整除`的`时间`
    ///
    ///     func pd_date = Date() // "5:54 PM"
    ///     date.minute = 32 // "5:32 PM"
    ///     date.nearestFiveMinutes() // "5:30 PM"
    ///
    ///     date.minute = 44 // "5:44 PM"
    ///     date.nearestFiveMinutes() // "5:45 PM"
    func pd_nearestFiveMinutes() -> Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// `距离最近`的可以被`十分钟整除`的`时间`
    ///
    ///     func pd_date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestTenMinutes // "5:30 PM"
    ///
    ///     date.minute = 48 // "5:48 PM"
    ///     date.nearestTenMinutes // "5:50 PM"
    func pd_nearestTenMinutes() -> Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self
        )
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// `距离最近`的可以被`十五分钟(一刻钟)`整除的`时间`
    ///
    ///     func pd_date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestQuarterHour // "5:30 PM"
    ///
    ///     date.minute = 40 // "5:40 PM"
    ///     date.nearestQuarterHour // "5:45 PM"
    func pd_nearestQuarterHour() -> Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: self
        )
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// `距离最近`的可以被`三十分钟(半小时)`整除的`时间`
    ///
    ///     func pd_date = Date() // "6:07 PM"
    ///     date.minute = 41 // "6:41 PM"
    ///     date.nearestHalfHour // "6:30 PM"
    ///
    ///     date.minute = 51 // "6:51 PM"
    ///     date.nearestHalfHour // "7:00 PM"
    func pd_nearestHalfHour() -> Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// `距离最近`的可以被`六十分钟(一小时)`整除的`时间`
    ///
    ///     func pd_date = Date() // "6:17 PM"
    ///     date.nearestHour // "6:00 PM"
    ///
    ///     date.minute = 36 // "6:36 PM"
    ///     date.nearestHour // "7:00 PM"
    func pd_nearestHour() -> Date {
        let min = calendar.component(.minute, from: self)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = calendar.date(from: calendar.dateComponents(components, from: self))!

        if min < 30 {
            return date
        }
        return calendar.date(byAdding: .hour, value: 1, to: date)!
    }

    /// `昨天`的`日期`
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
    func pd_yesterday() -> Date {
        calendar.date(byAdding: .day, value: -1, to: self) ?? Date()
    }

    /// `明天`的`日期`
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
    func pd_tomorrow() -> Date {
        calendar.date(byAdding: .day, value: 1, to: self) ?? Date()
    }

    /// 当前年属性哪个`年代`
    func pd_era() -> Int {
        calendar.component(.era, from: self)
    }

    #if !os(Linux)
        /// 本年中的第几个`季度`
        func pd_quarter() -> Int {
            let month = Double(calendar.component(.month, from: self))
            let numberOfMonths = Double(calendar.monthSymbols.count)
            let numberOfMonthsInQuarter = numberOfMonths / 4
            return Int(Darwin.ceil(month / numberOfMonthsInQuarter))
        }
    #endif

    /// 本年中的第几`周`
    func pd_weekOfYear() -> Int {
        calendar.component(.weekOfYear, from: self)
    }

    /// 一个月的第几`周`
    func pd_weekOfMonth() -> Int {
        calendar.component(.weekOfMonth, from: self)
    }

    /// 本`周`中的第几`天`
    func pd_weekday() -> Int {
        calendar.component(.weekday, from: self)
    }

    /// `self`是`星期几`(中文)
    func pd_weekdayAsString() -> String {
        let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        var calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let theComponents = calendar.dateComponents([.weekday], from: self)
        return weekdays[theComponents.weekday! - 1]
    }

    /// `self`是`几月`(英文)
    func pd_monthAsString() -> String {
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}

// MARK: - 静态方法
public extension Date {
    /// `今天`的`日期`
    /// - Returns: `Date`
    static func pd_todayDate() -> Date {
        Date()
    }

    /// `昨天`的`日期`
    /// - Returns: `Date?`
    static func pd_yesterDayDate() -> Date? {
        Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
    }

    /// `明天`的`日期`
    /// - Returns: `Date?`
    static func pd_tomorrowDate() -> Date? {
        Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())
    }

    /// `前天`的`日期`
    /// - Returns: `Date?`
    static func pd_theDayBeforYesterDayDate() -> Date? {
        Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())
    }

    /// `后天`的`日期`
    /// - Returns: `Date?`
    static func pd_theDayAfterYesterDayDate() -> Date? {
        Calendar.current.date(byAdding: DateComponents(day: 2), to: Date())
    }

    /// 获取当前时间戳`秒`(`10位`)
    /// - Returns: `String`
    static func pd_secondStamp() -> String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        return "\(Int(timeInterval))"
    }

    /// 获取当前时间戳`毫秒`(`13位`)
    /// - Returns: `String`
    static func pd_milliStamp() -> String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(Darwin.round(timeInterval * 1000))
        return "\(millisecond)"
    }

    /// 获取`某一年某一月`的`天数`
    /// - Parameters:
    ///   - year:年份
    ///   - month:月份
    /// - Returns:天数
    static func pd_daysCount(year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            return isLeapYear ? 29 : 28
        default:
            fatalError("非法的月份:\(month)")
        }
    }

    /// 获取当前日期`月份`的`天数`
    /// - Returns:当前日期`月份`的`天数`
    static func pd_currentMonthDays() -> Int {
        let date = Date()
        return daysCount(year: date.year, month: date.month)
    }
}

// MARK: - 时间戳
public extension Date {
    /// 日期对象转时间戳(支持返回 `13位` 和 `10位`的时间戳)
    /// - Parameter isUnix: 是否是unix格式`
    /// - Returns: `Int`类型时间戳
    func pd_toTimestamp(isUnix: Bool = true) -> Int {
        if isUnix { return Int(timeIntervalSince1970) }
        return Int(timeIntervalSince1970 * 1000)
    }

    /// 时间戳转换为日期字符串
    /// - Parameters:
    ///   - timestamp:时间戳
    ///   - format:格式
    /// - Returns:对应时间的字符串
    static func pd_timestampAsDateString(timestamp: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        // 时间戳转为Date
        let date = timestampAsDate(timestamp: timestamp)
        // 设置 dateFormat
        dateFormatter.dateFormat = format
        // 按照dateFormat把Date转化为String
        return dateFormatter.string(from: date)
    }

    /// 时间戳转换为`Date`
    /// - Parameter timestamp:时间戳
    /// - Returns:返回 Date
    static func pd_timestampAsDate(timestamp: String) -> Date {
        guard timestamp.count == 10 || timestamp.count == 13 else {
            #if DEBUG
                fatalError("时间戳位数不是 10 也不是 13")
            #else
                return Date()
            #endif
        }
        let timestampValue = timestamp.count == 10 ? timestamp.pd_int() : timestamp.pd_int() / 1000
        // 时间戳转为Date
        let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
        return date
    }

    /// `Date`转`时间戳`
    /// - Parameter isUnix:是否是`Unix`格式时间戳
    /// - Returns:时间戳
    func pd_dateAsTimestamp(isUnix: Bool = true) -> String {
        // 10位数时间戳 和 13位数时间戳
        let interval = isUnix ? CLongLong(Int(timeIntervalSince1970)) : CLongLong(Darwin.round(timeIntervalSince1970 * 1000))
        return "\(interval)"
    }

    /// 当前时间戳(单位`毫秒`)
    func pd_milliStamp() -> Int {
        Int(timeIntervalSince1970 * 1000)
    }

    /// 当前时间戳(单位`秒`)
    func pd_secondStamp() -> Double {
        timeIntervalSince1970
    }

    /// 格林尼治时间戳(单位`秒`)
    func pd_secondStampFromGMT() -> Int {
        let offset = TimeZone.current.secondsFromGMT(for: self)
        return Int(timeIntervalSince1970) - offset
    }
}

// MARK: - 判断
public extension Date {
    /// 日期`是否在将来`
    func pd_isInFuture() -> Bool {
        self > Date()
    }

    /// 日期`是否过去`
    func pd_isInPast() -> Bool {
        self < Date()
    }

    /// 日期是否在`今天之内`
    func pd_isInToday() -> Bool {
        calendar.isDateInToday(self)
    }

    /// 日期是否在`昨天之内`
    func pd_isInYesterday() -> Bool {
        calendar.isDateInYesterday(self)
    }

    /// 日期是否在`明天之内`
    func pd_isInTomorrow() -> Bool {
        calendar.isDateInTomorrow(self)
    }

    /// 日期是否在`周末期间`
    func pd_isInWeekend() -> Bool {
        calendar.isDateInWeekend(self)
    }

    /// 日期是否在`工作日期间`
    func pd_isWorkday() -> Bool {
        !calendar.isDateInWeekend(self)
    }

    /// 日期是否在`本周内`
    func pd_isInCurrentWeek() -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// 日期是否在`当前月份内`
    func pd_isInCurrentMonth() -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }

    /// 日期是否在`当年之内`
    func pd_isInCurrentYear() -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }

    /// 当前日期`是不是润年`
    func pd_isLeapYear() -> Bool {
        let year = year
        return (year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0))
    }

    /// 比较是否为`同一天`
    /// - Returns:`Bool`
    func pd_isSameDay(date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }

    /// 比较是否为`同一年``同一月``同一天`
    /// - Parameter date: `date`
    /// - Returns: `Bool`
    func pd_isSameYeaerMountDay(_ date: Date) -> Bool {
        let com = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let comToday = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return com.day == comToday.day
            && com.month == comToday.month
            && com.year == comToday.year
    }

    /// 获取两个日期之间的数据
    /// - Parameters:
    ///   - date:对比的日期
    ///   - unit:对比的类型
    /// - Returns:两个日期之间的数据
    func pd_componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year, .month, .day]) -> DateComponents {
        Calendar.current.dateComponents(unit, from: date, to: self)
    }

    /// 检查日期是否在当前给定的日历组件中
    ///
    ///     Date().isInCurrent(.day) -> true
    ///     Date().isInCurrent(.year) -> true
    ///
    /// - Parameter component:要检查的日历组件
    /// - Returns:如果日期在当前给定的日历组件中,则返回 `true`
    func pd_isInCurrent(_ component: Calendar.Component) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: component)
    }

    /// 检查一个日期是否在另外两个日期之间
    /// - Parameters:
    ///   - startDate:开始日期
    ///   - endDate:结束日期
    ///   - includeBounds:如果应该包括开始和结束日期,则为 true(默认为 false)
    /// - Returns:如果日期在两个给定日期之间,则返回 true
    func pd_isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(self).rawValue * compare(endDate).rawValue >= 0
        }
        return startDate.compare(self).rawValue * compare(endDate).rawValue > 0
    }

    /// 检查指定日历组件的值是否包含在当前日期和指定日期之间
    ///
    /// - Parameters:
    ///   - value:要判断的值
    ///   - component:`Calendar.Component`(要比较的组件)
    ///   - date:结束日期
    /// - Returns:如果`value`在当前日期和指定日期的指定组件之中,则返回`true`
    func pd_isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        let components = calendar.dateComponents([component], from: self, to: date)
        let componentValue = components.value(for: component)!
        return Darwin.abs(Int32(componentValue)) <= value
    }
}

// MARK: - 随机
public extension Date {
    /// 返回指定范围内的随机日期
    ///
    /// - Parameter range:创建随机日期的范围. `range` 不能为空(不包含结束日期)
    /// - Returns:`range` 范围内的随机日期
    static func pd_random(in range: Range<Date>) -> Date {
        Date(timeIntervalSinceReferenceDate:
            TimeInterval
                .random(in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound
                    .timeIntervalSinceReferenceDate))
    }

    /// 返回指定范围内的随机日期
    ///
    /// - Parameter range:创建随机日期的范围(包含结束日期)
    /// - Returns:`range` 范围内的随机日期
    static func pd_random(in range: ClosedRange<Date>) -> Date {
        Date(timeIntervalSinceReferenceDate:
            TimeInterval
                .random(in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound
                    .timeIntervalSinceReferenceDate))
    }

    /// 返回指定范围内的随机日期,使用给定的生成器作为随机源
    ///
    /// - Parameters:
    ///   - range:创建随机日期的范围. `range` 不能为空(不包含结束日期)
    ///   - generator:创建新随机日期时使用的随机数生成器
    /// - Returns:`range` 范围内的随机日期
    static func pd_random(in range: Range<Date>,
                          using generator: inout some RandomNumberGenerator) -> Date
    {
        Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(
                in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound.timeIntervalSinceReferenceDate,
                using: &generator
            ))
    }

    /// 返回指定范围内的随机日期,使用给定的生成器作为随机源
    ///
    /// - Parameters:
    ///   - range:创建随机日期的范围(包含结束日期)
    ///   - generator:创建新随机日期时使用的随机数生成器
    /// - Returns:`range` 范围内的随机日期
    static func pd_random(
        in range: ClosedRange<Date>,
        using generator: inout some RandomNumberGenerator
    ) -> Date {
        Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(
                in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound.timeIntervalSinceReferenceDate,
                using: &generator
            ))
    }
}

// MARK: - 操作
public extension Date {
    /// 获取两个日期之间的天数
    /// - Parameter date:对比的日期
    /// - Returns:两个日期之间的天数
    func pd_numberOfDays(from date: Date) -> Int? {
        componentCompare(from: date, unit: [.day]).day
    }

    /// 获取两个日期之间的小时
    /// - Parameter date:对比的日期
    /// - Returns:两个日期之间的小时
    func pd_numberOfHours(from date: Date) -> Int? {
        componentCompare(from: date, unit: [.hour]).hour
    }

    /// 获取两个日期之间的分钟
    /// - Parameter date:对比的日期
    /// - Returns:两个日期之间的分钟
    func pd_numberOfMinutes(from date: Date) -> Int? {
        componentCompare(from: date, unit: [.minute]).minute
    }

    /// 获取两个日期之间的秒数
    /// - Parameter date:对比的日期
    /// - Returns:两个日期之间的秒数
    func pd_numberOfSeconds(from date: Date) -> Int? {
        componentCompare(from: date, unit: [.second]).second
    }

    /// 日期的`加减`操作
    /// - Parameter day:天数变化
    /// - Returns:`date`
    func pd_adding(day: Int) -> Date? {
        Calendar.current.date(byAdding: DateComponents(day: day), to: self)
    }

    /// 添加指定日历组件的值到`Date`
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.adding(.minute, value:-10) // "Jan 12, 2017, 6:57 PM"
    ///     let date3 = date.adding(.day, value:4) // "Jan 16, 2017, 7:07 PM"
    ///     let date4 = date.adding(.month, value:2) // "Mar 12, 2017, 7:07 PM"
    ///     let date5 = date.adding(.year, value:13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component:组件类型
    ///   - value:要添加到Date的组件的值
    /// - Returns:原始日期 + 添加的组件的值
    func pd_adding(_ component: Calendar.Component, value: Int) -> Date {
        Calendar.current.date(byAdding: component, value: value, to: self)!
    }

    /// 添加指定日历组件的值到`Date`
    ///
    ///     var date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     date.add(.minute, value:-10) // "Jan 12, 2017, 6:57 PM"
    ///     date.add(.day, value:4) // "Jan 16, 2017, 7:07 PM"
    ///     date.add(.month, value:2) // "Mar 12, 2017, 7:07 PM"
    ///     date.add(.year, value:13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component:组件类型
    ///   - value:要添加到`Date`的组件的值
    func pd_add(_ component: Calendar.Component, value: Int) -> Date? {
        if let date = calendar.date(byAdding: component, value: value, to: self) {
            return date
        }
        return nil
    }

    /// 修改日期对象对应日历组件的值
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.changing(.minute, value:10) // "Jan 12, 2017, 7:10 PM"
    ///     let date3 = date.changing(.day, value:4) // "Jan 4, 2017, 7:07 PM"
    ///     let date4 = date.changing(.month, value:2) // "Feb 12, 2017, 7:07 PM"
    ///     let date5 = date.changing(.year, value:2000) // "Jan 12, 2000, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component:组件类型
    ///   - value:组件对应的新值
    /// - Returns:将指定组件更改为指定值后的原始日期
    func pd_changing(_ component: Calendar.Component, value: Int) -> Date? {
        switch component {
        case .nanosecond:
            #if targetEnvironment(macCatalyst)
                let allowedRange = 0 ..< 1_000_000_000
            #else
                let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
            #endif
            guard allowedRange.contains(value) else { return nil }
            let currentNanoseconds = calendar.component(.nanosecond, from: self)
            let nanosecondsToAdd = value - currentNanoseconds
            return calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self)

        case .second:
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentSeconds = calendar.component(.second, from: self)
            let secondsToAdd = value - currentSeconds
            return calendar.date(byAdding: .second, value: secondsToAdd, to: self)

        case .minute:
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentMinutes = calendar.component(.minute, from: self)
            let minutesToAdd = value - currentMinutes
            return calendar.date(byAdding: .minute, value: minutesToAdd, to: self)

        case .hour:
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentHour = calendar.component(.hour, from: self)
            let hoursToAdd = value - currentHour
            return calendar.date(byAdding: .hour, value: hoursToAdd, to: self)

        case .day:
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = value - currentDay
            return calendar.date(byAdding: .day, value: daysToAdd, to: self)

        case .month:
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(value) else { return nil }
            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = value - currentMonth
            return calendar.date(byAdding: .month, value: monthsToAdd, to: self)

        case .year:
            guard value > 0 else { return nil }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = value - currentYear
            return calendar.date(byAdding: .year, value: yearsToAdd, to: self)

        default:
            return calendar.date(bySetting: component, value: value, of: self)
        }
    }

    #if !os(Linux)
        /// 日历组件开头的数据
        ///
        ///     let date = Date() // "Jan 12, 2017, 7:14 PM"
        ///     let date2 = date.beginning(of:.hour) // "Jan 12, 2017, 7:00 PM"
        ///     let date3 = date.beginning(of:.month) // "Jan 1, 2017, 12:00 AM"
        ///     let date4 = date.beginning(of:.year) // "Jan 1, 2017, 12:00 AM"
        ///
        /// - Parameter component:日历组件在开始时获取日期
        /// - Returns:日历组件开头的日期(如果适用)
        func pd_beginning(of component: Calendar.Component) -> Date? {
            if component == .day { return calendar.startOfDay(for: self) }

            var components: Set<Calendar.Component> {
                switch component {
                case .second:
                    return [.year, .month, .day, .hour, .minute, .second]

                case .minute:
                    return [.year, .month, .day, .hour, .minute]

                case .hour:
                    return [.year, .month, .day, .hour]

                case .weekOfYear, .weekOfMonth:
                    return [.yearForWeekOfYear, .weekOfYear]

                case .month:
                    return [.year, .month]

                case .year:
                    return [.year]

                default:
                    return []
                }
            }

            guard !components.isEmpty else { return nil }
            return calendar.date(from: calendar.dateComponents(components, from: self))
        }
    #endif

    /// 日历组件末尾的日期
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:27 PM"
    ///     let date2 = date.end(of:.day) // "Jan 12, 2017, 11:59 PM"
    ///     let date3 = date.end(of:.month) // "Jan 31, 2017, 11:59 PM"
    ///     let date4 = date.end(of:.year) // "Dec 31, 2017, 11:59 PM"
    ///
    /// - Parameter component:日历组件,用于获取末尾的日期
    /// - Returns:日历组件末尾的日期(如果适用)
    func pd_end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = adding(.second, value: 1)
            date = calendar.date(
                from: calendar.dateComponents(
                    [.year, .month, .day, .hour, .minute, .second],
                    from: date
                ))!
            return date.add(.second, value: -1)
        case .minute:
            var date = adding(.minute, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.adding(.second, value: -1)
            return date
        case .hour:
            var date = adding(.hour, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.adding(.second, value: -1)
            return date
        case .day:
            var date = adding(.day, value: 1)
            date = calendar.startOfDay(for: date)
            return date.add(.second, value: -1)
        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = calendar.date(from:
                calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.adding(.day, value: 7).adding(.second, value: -1)
            return date
        case .month:
            var date = adding(.month, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month], from: date))!
            date = after.adding(.second, value: -1)
            return date

        case .year:
            var date = adding(.year, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year], from: date))!
            date = after.adding(.second, value: -1)
            return date

        default:
            return nil
        }
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
