import Dispatch
import Foundation

public extension Collection {
    var pd_range: Range<Index> {
        return startIndex ..< endIndex
    }
}

public extension Collection {

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Collection {

    func pd_forEachInParallel(_ each: (Self.Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: count) {
            each(self[index(startIndex, offsetBy: $0)])
        }
    }

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

    func pd_indices(where condition: (Element) throws -> Bool) rethrows -> [Index]? {
        let indices = try indices.filter { try condition(self[$0]) }
        return indices.isEmpty ? nil : indices
    }

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

public extension Collection where Element: Equatable {

    func pd_indices(of item: Element) -> [Index] {
        self.indices.filter { self[$0] == item }
    }
}

public extension Collection where Element: BinaryInteger {

    func pd_average() -> Double {
        guard !isEmpty else { return .zero }
        return Double(reduce(.zero, +)) / Double(count)
    }
}

public extension Collection where Element: FloatingPoint {

    func pd_average() -> Element {
        guard !isEmpty else { return .zero }
        return reduce(.zero, +) / Element(count)
    }
}
