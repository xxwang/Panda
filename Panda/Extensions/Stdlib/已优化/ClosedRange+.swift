import Foundation

// MARK: - ClosedRange<Int>
public extension ClosedRange<Int> {
    /// 转换为索引数组
    /// - Returns: `[Int]`
    func pd_indexs() -> [Int] {
        var indexs: [Int] = []
        self.forEach { indexs.append($0) }
        return indexs
    }
}
