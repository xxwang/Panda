import Dispatch
import Foundation

// MARK: - 属性
public extension Collection {
    /// 集合的索引`Range`
    var pd_range: Range<Index> {
        return startIndex ..< endIndex
    }
}

// MARK: - 下标
public extension Collection {

    /// 从集合中安全的读取数据(越界返回`nil`)
    ///
    ///     let arr = [1, 2, 3, 4, 5]
    ///     arr[safe:1] -> 2
    ///     arr[safe:10] -> nil
    ///
    /// - Parameter index: 元素下标索引
    /// - Returns: 下标对应元素
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - 方法
public extension Collection {

    /// 对集合中的每个元素执行`each`闭包
    ///
    ///     array.pd_forEachInParallel { item in
    ///           print(item)
    ///     }
    ///
    /// - Parameter each: 作用于每个元素的闭包
    func pd_forEachInParallel(_ each: (Self.Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: count) {
            each(self[index(startIndex, offsetBy: $0)])
        }
    }

    /// 按指定大小把一维数组分组为多维数组
    ///
    ///     [0, 2, 4, 7].pd_group(by:2) -> [[0, 2], [4, 7]]
    ///     [0, 2, 4, 7, 6].pd_group(by:2) -> [[0, 2], [4, 7], [6]]
    ///
    /// - Parameter size: 子数组的大小
    /// - Returns: 二维数组
    func pd_group(by size: Int) -> [[Element]]? {
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
    ///     [1, 7, 1, 2, 4, 1, 8].pd_indices(where:{ $0 == 1 }) -> [0, 2, 5]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果数组, 没有符合条件的返回`nil`
    func pd_indices(where condition: (Element) throws -> Bool) rethrows -> [Index]? {
        let indices = try indices.filter { try condition(self[$0]) }
        return indices.isEmpty ? nil : indices
    }

    /// 为指定长度的数组切片执行`body`闭包
    ///
    ///     [0, 2, 4, 7].pd_forEach(slice:2) { print($0) } -> // print:[0, 2], [4, 7]
    ///     [0, 2, 4, 7, 6].pd_forEach(slice:2) { print($0) } -> // print:[0, 2], [4, 7], [6]
    ///
    /// - Parameters:
    ///   - slice: 切片大小
    ///   - body: 作用于切片的闭包
    func pd_forEach(slice: Int, body: ([Element]) throws -> Void) rethrows {
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

    /// 获取数组中与指定元素相同的索引
    ///
    ///     [1, 2, 2, 3, 4, 2, 5].pd_indices(of 2) -> [1, 2, 5]
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].pd_indices(of 2.3) -> [1]
    ///     ["h", "e", "l", "l", "o"].pd_indices(of "l") -> [2, 3]
    ///
    /// - Parameter item: 要查找的元素
    /// - Returns: 结果数组
    func pd_indices(of item: Element) -> [Index] {
        self.indices.filter { self[$0] == item }
    }
}

// MARK: - Element:BinaryInteger
public extension Collection where Element: BinaryInteger {

    /// 计算整数数组中元素的平均值
    ///
    ///     [1, 2, 4, 3, 4].pd_average() = 2.8
    ///
    /// - Returns: 平均值
    func pd_average() -> Double {
        guard !isEmpty else { return .zero }
        return Double(reduce(.zero, +)) / Double(count)
    }
}

// MARK: - Element:FloatingPoint
public extension Collection where Element: FloatingPoint {
    
    /// 计算浮点数数组中元素的平均值
    ///
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].pd_average() = 3.18
    ///
    /// - Returns: 平均值
    func pd_average() -> Element {
        guard !isEmpty else { return .zero }
        return reduce(.zero, +) / Element(count)
    }
}
