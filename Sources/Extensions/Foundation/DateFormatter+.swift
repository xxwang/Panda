import Foundation

public extension DateFormatter {
    convenience init(format: String, locale: Locale? = nil, timeZone: TimeZone? = nil) {
        self.init()
        self.dateFormat = format
        if let locale { self.locale = locale }
        if let timeZone { self.timeZone = timeZone }
    }
}

extension DateFormatter: Defaultable {}
extension DateFormatter {
    public typealias Associatedtype = DateFormatter

    @objc open class func `default`() -> Associatedtype {
        let formatter = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss", locale: .current, timeZone: .current)
        return formatter
    }
}

public extension DateFormatter {
    @discardableResult
    func xx_dateFormat(_ dateFormat: String) -> Self {
        self.dateFormat = dateFormat
        return self
    }

    @discardableResult
    func xx_locale(_ locale: Locale) -> Self {
        self.locale = locale
        return self
    }

    @discardableResult
    func xx_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }
}
