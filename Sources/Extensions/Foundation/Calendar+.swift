import Foundation

public extension Calendar {
    func sk_daysInMonth(for date: Date = Date()) -> Int {
        return range(of: .day, in: .month, for: date)!.count
    }
}
