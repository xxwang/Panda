
import UIKit

public extension UIDatePicker {
    typealias Associatedtype = UIDatePicker

    override class func `default`() -> Associatedtype {
        let datePicker = UIDatePicker()
        return datePicker
    }
}

public extension UIDatePicker {

    @discardableResult
    func pd_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    @discardableResult
    func pd_datePickerMode(_ datePickerMode: Mode) -> Self {
        self.datePickerMode = datePickerMode
        return self
    }

    @discardableResult
    @available(iOS 13.4, *)
    func pd_preferredDatePickerStyle(_ preferredDatePickerStyle: UIDatePickerStyle) -> Self {
        self.preferredDatePickerStyle = preferredDatePickerStyle
        return self
    }

    @discardableResult
    func pd_highlightsToday(_ highlightsToday: Bool) -> Self {
        setValue(highlightsToday, forKey: "highlightsToday")
        return self
    }

    @discardableResult
    func pd_textColor(_ textColor: UIColor) -> Self {
        setValue(textColor, forKeyPath: "textColor")
        return self
    }
}
