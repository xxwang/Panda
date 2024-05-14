import Foundation

public extension Comparable {

    func xx_isBetween(_ range: ClosedRange<Self>) -> Bool {
        range ~= self
    }

    func xx_clamped(to range: ClosedRange<Self>) -> Self {
        Swift.max(range.lowerBound, Swift.min(self, range.upperBound))
    }
}
