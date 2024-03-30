//
//  Collection+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import Dispatch
import Foundation

// MARK: - 属性
public extension Collection {
    /// 集合的索引`Range`
    var range: Range<Index> { startIndex ..< endIndex }
}

// MARK: - 下标
public extension Collection {
    /// 从集合中安全的读取数据(下标不存在返回`nil`)
    ///
    ///     let arr = [1, 2, 3, 4, 5]
    ///     arr[safe:1] -> 2
    ///     arr[safe:10] -> nil
    /// - Parameters index:要读取数据的下标
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - 方法
public extension Collection {
    /// 对集合每个元素并行执行`each`闭包
    ///
    ///     array.forEachInParallel { item in
    ///           print(item)
    ///     }
    /// - Parameters each:要执行的闭包
    func forEachInParallel(_ each: (Self.Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: count) {
            each(self[index(startIndex, offsetBy: $0)])
        }
    }

    /// 把集合分割成指定大小的切片(如果剩余元素个数小于指定大小则返回剩余的元素)
    ///
    ///     [0, 2, 4, 7].group(by:2) -> [[0, 2], [4, 7]]
    ///     [0, 2, 4, 7, 6].group(by:2) -> [[0, 2], [4, 7], [6]]
    /// - Parameters size:切片大小
    /// - Returns:切片数组
    func group(by size: Int) -> [[Element]]? {
        guard size > 0, !isEmpty else { return nil }
        var start = startIndex
        var slices = [[Element]]()
        while start != endIndex {
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            slices.append(Array(self[start ..< end]))
            start = end
        }
        return slices
    }

    /// 获取满足条件的元素索引
    ///
    ///     [1, 7, 1, 2, 4, 1, 8].indices(where:{ $0 == 1 }) -> [0, 2, 5]
    /// - Parameter condition: 条件闭包
    /// - Returns: 索引数组(如果没有返回`nil`)
    func indices(where condition: (Element) throws -> Bool) rethrows -> [Index]? {
        let indices = try indices.filter { try condition(self[$0]) }
        return indices.isEmpty ? nil : indices
    }

    /// 把集合分割成指定大小的切片并执行`body`闭包
    ///
    ///     [0, 2, 4, 7].forEach(slice:2) { print($0) } -> // print:[0, 2], [4, 7]
    ///     [0, 2, 4, 7, 6].forEach(slice:2) { print($0) } -> // print:[0, 2], [4, 7], [6]
    /// - Parameters:
    ///   - slice:切片大小
    ///   - body:要执行的指定闭包
    func forEach(slice: Int, body: ([Element]) throws -> Void) rethrows {
        var start = startIndex
        while case let end = index(start, offsetBy: slice, limitedBy: endIndex) ?? endIndex,
              start != end
        {
            try body(Array(self[start ..< end]))
            start = end
        }
    }
}

// MARK: - Element:Equatable
public extension Collection where Element: Equatable {
    /// 获取指定元素的索引数组
    ///
    ///     [1, 2, 2, 3, 4, 2, 5].indices(of 2) -> [1, 2, 5]
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].indices(of 2.3) -> [1]
    ///     ["h", "e", "l", "l", "o"].indices(of "l") -> [2, 3]
    /// - Parameters item:要查找的元素
    /// - Returns:索引数组
    func indices(of item: Element) -> [Index] {
        indices.filter { self[$0] == item }
    }
}

// MARK: - Element:BinaryInteger
public extension Collection where Element: BinaryInteger {
    /// 计算集合中元素的平均值
    ///
    /// - Returns:平均值
    func average() -> Double {
        guard !isEmpty else { return .zero }
        return Double(reduce(.zero, +)) / Double(count)
    }
}

// MARK: - Element:FloatingPoint
public extension Collection where Element: FloatingPoint {
    /// 计算集合中元素的平均值
    ///
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].average() = 3.18
    /// - Returns:平均值
    func average() -> Element {
        guard !isEmpty else { return .zero }
        return reduce(.zero, +) / Element(count)
    }
}
