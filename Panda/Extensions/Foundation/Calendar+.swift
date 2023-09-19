//
//  Calendar+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import Foundation

// MARK: - 方法
public extension Calendar {
    /// 指定`Date`月份的`天数`
    /// - Parameter date: 日期 (默认:`Date.nowDate`)
    /// - Returns: 当月天数
    func daysInMonth(for date: Date = Date()) -> Int {
        range(of: .day, in: .month, for: date)!.count
    }
}
