//
//  SKProduct+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import StoreKit

extension SKProduct: Pandaable {}

// MARK: - 方法
public extension PandaEx where Base: SKProduct {
    /// 本地化`商品价格`
    /// - Returns: 本地化价格字符串
    func localePrice() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.base.priceLocale
        return formatter.string(from: price)
    }
}
