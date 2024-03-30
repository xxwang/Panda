//
//  UIDatePicker+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import UIKit

// MARK: - Defaultable
public extension UIDatePicker {
    typealias Associatedtype = UIDatePicker

    override class func `default`() -> Associatedtype {
        let datePicker = UIDatePicker()
        return datePicker
    }
}

// MARK: - 链式语法
public extension UIDatePicker {
    /// 设置时区
    /// - Parameter timeZone:时区
    /// - Returns:`Self`
    @discardableResult
    func pd_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    /// 设置模式
    /// - Parameter datePickerMode:模式
    /// - Returns:`Self`
    @discardableResult
    func pd_datePickerMode(_ datePickerMode: Mode) -> Self {
        self.datePickerMode = datePickerMode
        return self
    }

    /// 设置样式
    /// - Parameter preferredDatePickerStyle:样式
    /// - Returns:`Self`
    @discardableResult
    @available(iOS 13.4, *)
    func pd_preferredDatePickerStyle(_ preferredDatePickerStyle: UIDatePickerStyle) -> Self {
        self.preferredDatePickerStyle = preferredDatePickerStyle
        return self
    }

    /// 是否高亮今天
    /// - Parameter highlightsToday:是否高亮今天
    /// - Returns:`Self`
    @discardableResult
    func pd_highlightsToday(_ highlightsToday: Bool) -> Self {
        setValue(highlightsToday, forKey: "highlightsToday")
        return self
    }

    /// 设置文字颜色
    /// - Parameter textColor:文字颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_textColor(_ textColor: UIColor) -> Self {
        setValue(textColor, forKeyPath: "textColor")
        return self
    }
}
