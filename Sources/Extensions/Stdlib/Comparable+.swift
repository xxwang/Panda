import Foundation

public extension Comparable {

    func pd_isBetween(_ range: ClosedRange<Self>) -> Bool {
        range ~= self
    }

    func pd_clamped(to range: ClosedRange<Self>) -> Self {
        Swift.max(range.lowerBound, Swift.min(self, range.upperBound))
    }
}
