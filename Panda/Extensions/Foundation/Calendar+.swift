import Foundation

// MARK: - 方法
public extension Calendar {
    /// 指定`Date`月份的`天数`
    /// - Parameter date: 日期 (默认:`Date.nowDate`)
    /// - Returns: 当月天数
    func pd_daysInMonth(for date: Date = Date()) -> Int {
        return range(of: .day, in: .month, for: date)!.count
    }
}
