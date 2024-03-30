//
//  ClosedRange+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import Foundation

// MARK: - ClosedRange<Int>
public extension ClosedRange<Int> {
    /// 转换为索引数组
    var indexs: [Int] {
        var indexs: [Int] = []
        forEach { indexs.append($0) }
        return indexs
    }
}
