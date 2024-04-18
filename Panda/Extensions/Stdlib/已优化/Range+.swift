import Foundation

// MARK: - Range<String.Index>
public extension Range<String.Index> {
    
    /// `Range<String.Index>`转`NSRange`
    /// - Parameter string: `Range`所在字符串
    /// - Returns: `NSRange`
    func pd_NSRange(in string: String) -> NSRange {
        return NSRange(self, in: string)
    }
}
