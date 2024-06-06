import UIKit

public extension DateComponents {
    @discardableResult
    mutating func sk_calendar(_ calendar: Calendar) -> Self {
        self.calendar = calendar
        return self
    }

    @discardableResult
    mutating func sk_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    @discardableResult
    mutating func sk_era(_ era: Int) -> Self {
        self.era = era
        return self
    }

    @discardableResult
    mutating func sk_year(_ year: Int) -> Self {
        self.year = year
        return self
    }

    @discardableResult
    mutating func sk_month(_ month: Int) -> Self {
        self.month = month
        return self
    }

    @discardableResult
    mutating func sk_day(_ day: Int) -> Self {
        self.day = day
        return self
    }

    @discardableResult
    mutating func sk_hour(_ hour: Int) -> Self {
        self.hour = hour
        return self
    }

    @discardableResult
    mutating func sk_minute(_ minute: Int) -> Self {
        self.minute = minute
        return self
    }

    @discardableResult
    mutating func sk_second(_ second: Int) -> Self {
        self.second = second
        return self
    }

    @discardableResult
    mutating func sk_nanosecond(_ nanosecond: Int) -> Self {
        self.nanosecond = nanosecond
        return self
    }
}
