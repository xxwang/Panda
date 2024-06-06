import Foundation

public extension Comparable {

    func sk_isBetween(_ range: ClosedRange<Self>) -> Bool {
        range ~= self
    }

    func sk_clamped(to range: ClosedRange<Self>) -> Self {
        Swift.max(range.lowerBound, Swift.min(self, range.upperBound))
    }
}
