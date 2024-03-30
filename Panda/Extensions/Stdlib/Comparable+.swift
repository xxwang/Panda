//
//  Comparable+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import Foundation

// MARK: - 实例方法
public extension Comparable {
    /// 判断数据是否在指定范围内
    /// - Parameter range: `x...y || x..<y`
    /// - Returns: 是否在范围内
    func isBetween(_ range: ClosedRange<Self>) -> Bool {
        range ~= self
    }

    /// 限制数据在指定范围内
    /// - Parameter range: 值允许的范围
    /// - Returns: `>`返回`range.upperBound`, `<`返回`range.lowerBound`,`==`返回`self
    func clamped(to range: ClosedRange<Self>) -> Self {
        Swift.max(range.lowerBound, Swift.min(self, range.upperBound))
    }
}
