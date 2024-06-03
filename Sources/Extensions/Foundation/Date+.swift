import Foundation

private let calendar = Calendar.current
private let dateFormatter = DateFormatter()

public extension Date {
    var xx_calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier)
    }
}

public extension Date {
    var xx_year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            guard let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) else { return }
            self = date
        }
    }

    var xx_month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            guard let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) else { return }
            self = date
        }
    }

    var xx_day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            guard let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) else { return }
            self = date
        }
    }

    var xx_hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentHours = calendar.component(.hour, from: self)
            let hoursToAdd = newValue - currentHours
            guard let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: self) else { return }
            self = date
        }
    }

    var xx_minute: Int {
        get {
            return calendar.component(.minute, from: self)
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

    var xx_second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = calendar.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            guard let date = calendar.date(byAdding: .second, value: secondsToAdd, to: self) else { return }
            self = date
        }
    }

    var xx_millisecond: Int {
        get {
            return calendar.component(.nanosecond, from: self) / 1_000_000
        }
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

    var xx_nanosecond: Int {
        get {
            return calendar.component(.nanosecond, from: self)
        }
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

public extension Date {
    init?(calendar: Calendar? = .current, components: DateComponents) {
        guard let date = calendar?.date(from: components) else { return nil }
        self = date
    }

    init?(string: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }

    init(timestamp: TimeInterval, isUnix: Bool = true) {
        self.init(timeIntervalSince1970: isUnix ? timestamp : timestamp / 1000.0)
    }
}

public extension Date {
    func xx_dateFromGMT() -> Date {
        let secondFromGMT = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return self.addingTimeInterval(secondFromGMT)
    }

    func xx_dateToGMT() -> Date {
        let secondFromGMT = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return self.addingTimeInterval(-secondFromGMT)
    }
}

public extension Date {
    func xx_string(with format: String = "yyyy-MM-dd HH:mm:ss",
                   isGMT: Bool = false) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = .current
        dateFormatter.timeZone = isGMT ? TimeZone(secondsFromGMT: 0) : TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self)
    }

    func xx_dateString(of style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    func xx_timeString(of style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }

    func xx_dateTimeString(of style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    enum MonthNameStyle {
        case threeLetters
        case oneLetter
        case full
    }

    func xx_monthName(of style: Date.MonthNameStyle = .full) -> String {
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

    enum DayNameStyle {
        case threeLetters
        case oneLetter
        case full
    }

    func xx_dayName(of style: Date.DayNameStyle = .full) -> String {
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

    func xx_daysSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date) / (3600 * 24)
    }

    func xx_hoursSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date) / 3600
    }

    func xx_minutesSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date) / 60
    }

    func xx_secondsSince(_ date: Date) -> Double {
        return self.timeIntervalSince(date)
    }

    func xx_distance(_ date: Date) -> TimeInterval {
        return self.timeIntervalSince(date)
    }

    func xx_currentZoneDate() -> Date {
        let date = Date()
        let zone = NSTimeZone.system
        let time = zone.secondsFromGMT(for: date)
        let dateNow = date.addingTimeInterval(TimeInterval(time))

        return dateNow
    }

    func xx_iso8601String() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: self).appending("Z")
    }

    func xx_nearestFiveMinutes() -> Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    func xx_nearestTenMinutes() -> Date {
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

    func xx_nearestQuarterHour() -> Date {
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

    func xx_nearestHalfHour() -> Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    func xx_nearestHour() -> Date {
        let min = calendar.component(.minute, from: self)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = calendar.date(from: calendar.dateComponents(components, from: self))!

        if min < 30 {
            return date
        }
        return calendar.date(byAdding: .hour, value: 1, to: date)!
    }

    func xx_yesterday() -> Date {
        return calendar.date(byAdding: .day, value: -1, to: self) ?? Date()
    }

    func xx_tomorrow() -> Date {
        return calendar.date(byAdding: .day, value: 1, to: self) ?? Date()
    }

    func xx_era() -> Int {
        return calendar.component(.era, from: self)
    }

    #if !os(Linux)
        func xx_quarter() -> Int {
            let month = Double(calendar.component(.month, from: self))
            let numberOfMonths = Double(calendar.monthSymbols.count)
            let numberOfMonthsInQuarter = numberOfMonths / 4
            return Int(Darwin.ceil(month / numberOfMonthsInQuarter))
        }
    #endif

    func xx_weekOfYear() -> Int {
        return calendar.component(.weekOfYear, from: self)
    }

    func xx_weekOfMonth() -> Int {
        return calendar.component(.weekOfMonth, from: self)
    }

    func xx_weekday() -> Int {
        return calendar.component(.weekday, from: self)
    }

    func xx_monthAsString() -> String {
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}

public extension Date {
    static func xx_now() -> Date {
        if #available(iOS 15, *) {
            return Date.now
        } else {
            return Date()
        }
    }

    static func xx_todayDate() -> Date {
        return Date()
    }

    static func xx_yesterDayDate() -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
    }

    static func xx_tomorrowDate() -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())
    }

    static func xx_theDayBeforYesterDayDate() -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: -2), to: Date())
    }

    static func xx_theDayAfterYesterDayDate() -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: 2), to: Date())
    }

    static func xx_secondStamp() -> String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        return "\(Int(timeInterval))"
    }

    static func xx_milliStamp() -> String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(Darwin.round(timeInterval * 1000))
        return "\(millisecond)"
    }

    static func xx_daysCount(year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            return isLeapYear ? 29 : 28
        default:
            return 0
        }
    }

    static func xx_currentMonthDays() -> Int {
        let date = Date()
        return xx_daysCount(year: date.xx_year, month: date.xx_month)
    }
}

public extension Date {
    func xx_timestamp(isUnix: Bool = true) -> Int {
        if isUnix { return Int(timeIntervalSince1970) }
        return Int(timeIntervalSince1970 * 1000)
    }

    static func xx_timestampAsDateString(timestamp: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = xx_timestampAsDate(timestamp: timestamp)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    static func xx_timestampAsDate(timestamp: String) -> Date {
        guard timestamp.count == 10 || timestamp.count == 13 else {
            return Date()
        }
        let timestampValue = timestamp.count == 10 ? timestamp.xx_int() : timestamp.xx_int() / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
        return date
    }

    func xx_dateAsTimestamp(isUnix: Bool = true) -> String {
        let interval = isUnix ? CLongLong(Int(timeIntervalSince1970)) : CLongLong(Darwin.round(timeIntervalSince1970 * 1000))
        return "\(interval)"
    }

    func xx_secondStampFromGMT() -> Int {
        let offset = TimeZone.current.secondsFromGMT(for: self)
        return Int(timeIntervalSince1970) - offset
    }

    func xx_secondStamp() -> Double {
        return timeIntervalSince1970
    }

    func xx_milliStamp() -> Int {
        return Int(timeIntervalSince1970 * 1000)
    }
}

public extension Date {
    func xx_isInFuture() -> Bool {
        return self > Date()
    }

    func xx_isInPast() -> Bool {
        return self < Date()
    }

    func xx_isInToday() -> Bool {
        return calendar.isDateInToday(self)
    }

    func xx_isInYesterday() -> Bool {
        return calendar.isDateInYesterday(self)
    }

    func xx_isInTomorrow() -> Bool {
        return calendar.isDateInTomorrow(self)
    }

    func xx_isInWeekend() -> Bool {
        return calendar.isDateInWeekend(self)
    }

    func xx_isWorkday() -> Bool {
        return !calendar.isDateInWeekend(self)
    }

    func xx_isInCurrentWeek() -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    func xx_isInCurrentMonth() -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }

    func xx_isInCurrentYear() -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }

    func xx_isLeapYear() -> Bool {
        let year = self.xx_year
        return (year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0))
    }

    func xx_isSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }

    func xx_isSameYeaerMountDay(_ date: Date) -> Bool {
        let com = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let comToday = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return com.day == comToday.day
            && com.month == comToday.month
            && com.year == comToday.year
    }

    func xx_componentCompare(from date: Date, unit: Set<Calendar.Component> = [.year, .month, .day]) -> DateComponents {
        return Calendar.current.dateComponents(unit, from: date, to: self)
    }

    func xx_isInCurrent(_ component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: component)
    }

    func xx_isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(self).rawValue * compare(endDate).rawValue >= 0
        }
        return startDate.compare(self).rawValue * compare(endDate).rawValue > 0
    }

    func xx_isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        let components = calendar.dateComponents([component], from: self, to: date)
        let componentValue = components.value(for: component)!
        return Darwin.abs(Int32(componentValue)) <= value
    }
}

public extension Date {
    static func xx_random(in range: Range<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval
                .random(in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound
                    .timeIntervalSinceReferenceDate))
    }

    static func xx_random(in range: ClosedRange<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval
                .random(in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound
                    .timeIntervalSinceReferenceDate))
    }

    static func xx_random(in range: Range<Date>,
                          using generator: inout some RandomNumberGenerator) -> Date
    {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(
                in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound.timeIntervalSinceReferenceDate,
                using: &generator
            ))
    }

    static func xx_random(
        in range: ClosedRange<Date>,
        using generator: inout some RandomNumberGenerator
    ) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(
                in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound.timeIntervalSinceReferenceDate,
                using: &generator
            ))
    }
}

public extension Date {
    func xx_numberOfDays(from date: Date) -> Int? {
        return xx_componentCompare(from: date, unit: [.day]).day
    }

    func xx_numberOfHours(from date: Date) -> Int? {
        return xx_componentCompare(from: date, unit: [.hour]).hour
    }

    func xx_numberOfMinutes(from date: Date) -> Int? {
        return xx_componentCompare(from: date, unit: [.minute]).minute
    }

    func xx_numberOfSeconds(from date: Date) -> Int? {
        return xx_componentCompare(from: date, unit: [.second]).second
    }

    func xx_adding(day: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day: day), to: self)
    }

    func xx_adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }

    func xx_changing(_ component: Calendar.Component, value: Int) -> Date? {
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

        func xx_beginning(of component: Calendar.Component) -> Date? {
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

    func xx_end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = xx_adding(.second, value: 1)
            date = calendar.date(
                from: calendar.dateComponents(
                    [.year, .month, .day, .hour, .minute, .second],
                    from: date
                ))!
            return date.xx_adding(.second, value: -1)
        case .minute:
            var date = xx_adding(.minute, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.xx_adding(.second, value: -1)
            return date
        case .hour:
            var date = xx_adding(.hour, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.xx_adding(.second, value: -1)
            return date
        case .day:
            var date = xx_adding(.day, value: 1)
            date = calendar.startOfDay(for: date)
            return date.xx_adding(.second, value: -1)
        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = calendar.date(from:
                calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.xx_adding(.day, value: 7).xx_adding(.second, value: -1)
            return date
        case .month:
            var date = xx_adding(.month, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year, .month], from: date))!
            date = after.xx_adding(.second, value: -1)
            return date

        case .year:
            var date = xx_adding(.year, value: 1)
            let after = calendar.date(from:
                calendar.dateComponents([.year], from: date))!
            date = after.xx_adding(.second, value: -1)
            return date

        default:
            return nil
        }
    }
}

extension Date {
    @discardableResult
    mutating func xx_year(_ year: Int) -> Self {
        self.xx_year = year
        return self
    }

    mutating func xx_month(_ month: Int) -> Self {
        self.xx_month = month
        return self
    }

    mutating func xx_day(_ day: Int) -> Self {
        self.xx_day = day
        return self
    }

    @discardableResult
    mutating func xx_hour(_ hour: Int) -> Self {
        self.xx_hour = hour
        return self
    }

    @discardableResult
    mutating func xx_minute(_ minute: Int) -> Self {
        self.xx_minute = minute
        return self
    }

    @discardableResult
    mutating func xx_second(_ second: Int) -> Self {
        self.xx_second = second
        return self
    }

    @discardableResult
    mutating func xx_millisecond(_ millisecond: Int) -> Self {
        self.xx_millisecond = millisecond
        return self
    }

    @discardableResult
    mutating func xx_nanosecond(_ nanosecond: Int) -> Self {
        self.xx_nanosecond = nanosecond
        return self
    }
}