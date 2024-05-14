import UIKit

public extension NSAttributedString {
    func xx_mutable() -> NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }

    func xx_attributes() -> [NSAttributedString.Key: Any] {
        guard length > 0 else { return [:] }
        return self.attributes(at: 0, effectiveRange: nil)
    }

    func xx_fullNSRange() -> NSRange {
        return NSRange(location: 0, length: length)
    }

    func xx_nsRange(_ subStr: String) -> NSRange {
        return string.xx_nsRange(subStr)
    }

    func xx_nsRanges(with texts: [String]) -> [NSRange] {
        var ranges = [NSRange]()
        for str in texts {
            if string.contains(str) {
                let subStrArr = string.components(separatedBy: str)
                var subStrIndex = 0
                for i in 0 ..< (subStrArr.count - 1) {
                    let subDivisionStr = subStrArr[i]
                    if i == 0 {
                        subStrIndex += (subDivisionStr.lengthOfBytes(using: .unicode) / 2)
                    } else {
                        subStrIndex += (subDivisionStr.lengthOfBytes(using: .unicode) / 2 + str.lengthOfBytes(using: .unicode) / 2)
                    }
                    ranges.append(NSRange(location: subStrIndex, length: str.count))
                }
            }
        }
        return ranges
    }

    func xx_attributedSize(_ lineWidth: CGFloat = sizer.screen.width) -> CGSize {
        let constraint = CGSize(width: lineWidth, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(
            with: constraint,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size
        return CGSize(width: size.width.xx_ceil(), height: size.height.xx_ceil())
    }
}

public extension NSAttributedString {
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        lhs + NSAttributedString(string: rhs)
    }
}
