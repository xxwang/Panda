import StoreKit

// MARK: - 方法
public extension SKProduct {
    /// 本地化`商品价格`
    /// - Returns: 本地化价格字符串
    func pd_localePrice() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}
