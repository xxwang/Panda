import Foundation

// MARK: - 方法
public extension Locale {
    /// 是否是12小时制
    /// - Returns: 是否是12小时制
    func pd_is12hour() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = self

        let dateString = dateFormatter.string(from: Date())

        // 判断是否包含"am/pm"
        return dateString.contains(dateFormatter.amSymbol) || dateString.contains(dateFormatter.pmSymbol)
    }
}
