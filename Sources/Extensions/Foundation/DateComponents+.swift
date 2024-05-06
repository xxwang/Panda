import UIKit

public extension DateComponents {

    @discardableResult
    mutating func pd_calendar(_ calendar: Calendar) -> Self {
        self.calendar = calendar
        return self
    }


    @discardableResult
    mutating func pd_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }


    @discardableResult
    mutating func pd_era(_ era: Int) -> Self {
        self.era = era
        return self
    }

    @discardableResult
    mutating func pd_year(_ year: Int) -> Self {
        self.year = year
        return self
    }

    @discardableResult
    mutating func pd_month(_ month: Int) -> Self {
        self.month = month
        return self
    }

    @discardableResult
    mutating func pd_day(_ day: Int) -> Self {
        self.day = day
        return self
    }

    @discardableResult
    mutating func pd_hour(_ hour: Int) -> Self {
        self.hour = hour
        return self
    }

    @discardableResult
    mutating func pd_minute(_ minute: Int) -> Self {
        self.minute = minute
        return self
    }

    @discardableResult
    mutating func pd_second(_ second: Int) -> Self {
        self.second = second
        return self
    }

    @discardableResult
    mutating func pd_nanosecond(_ nanosecond: Int) -> Self {
        self.nanosecond = nanosecond
        return self
    }
}
