import Foundation

public extension ClosedRange<Int> {

    func pd_indexs() -> [Int] {
        var indexs: [Int] = []
        self.forEach { indexs.append($0) }
        return indexs
    }
}
