import Foundation

// MARK: - 下标
public extension BidirectionalCollection {
    /// 返回指定位置的元素.如果`distance`为负数,则将返回结尾处的第`n`个元素
    ///
    ///     let arr = [1, 2, 3, 4, 5]
    ///     arr[offset:1] -> 2
    ///     arr[offset:-2] -> 4
    /// - Parameters distance:要偏移的距离
    subscript(offset distance: Int) -> Element {
        let index = distance >= 0 ? startIndex : endIndex
        return self[indices.index(index, offsetBy: distance)]
    }
}
