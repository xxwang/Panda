import Foundation

public extension Calendar {

    func pd_daysInMonth(for date: Date = Date()) -> Int {
        return range(of: .day, in: .month, for: date)!.count
    }
}
