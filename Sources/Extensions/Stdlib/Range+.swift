import Foundation

public extension Range<String.Index> {

    func xx_nsRange(in string: String) -> NSRange {
        return NSRange(self, in: string)
    }
}