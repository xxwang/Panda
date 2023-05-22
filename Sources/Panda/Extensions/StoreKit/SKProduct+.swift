//
//  SKProduct+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import StoreKit

// MARK: - 方法
public extension SKProduct {
    /// 本地化`商品价格`
    /// - Returns: 本地化价格字符串
    func localePrice() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }
}
