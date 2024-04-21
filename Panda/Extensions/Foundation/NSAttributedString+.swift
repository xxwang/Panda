//
//  NSAttributedString+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import UIKit

// MARK: - 方法
public extension NSAttributedString {
    /// `NSAttributedString`转`NSMutableAttributedString`
    /// - Returns: `NSMutableAttributedString`
    func toMutable() -> NSMutableAttributedString {
        NSMutableAttributedString(attributedString: self)
    }

    /// `NSAttributedString`上的`属性字典`
    /// - Returns: `[NSAttributedString.Key: Any]`
    func attributes() -> [NSAttributedString.Key: Any] {
        guard length > 0 else { return [:] }
        return attributes(at: 0, effectiveRange: nil)
    }

    /// 整个`NSAttributedString`的`NSRange`
    /// - Returns: `NSRange`
    func pd_fullNSRange() -> NSRange {
        return NSRange(location: 0, length: length)
    }

    /// 获取`subStr`在`self`中的`NSRange`
    /// - Parameter subStr:用于查找的字符串
    /// - Returns:`NSRange`
    func subNSRange(_ subStr: String) -> NSRange {
        return string.pd_nsRange(subStr)
    }

    /// 获取`texts`在`self`中的`[NSRange]`
    /// - Parameter texts:`[String]`
    /// - Returns:`[NSRange]`
    func subNSRanges(with texts: [String]) -> [NSRange] {
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

    /// 计算`NSAttributedString`的`CGSize`
    /// - Parameter maxWidth:最大宽度
    /// - Returns:`CGSize`
    func strSize(_ maxWidth: CGFloat = sizer.screen.width) -> CGSize {
        let result = boundingRect(
            with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine],
            context: nil
        ).size
        return CGSize(width: Darwin.ceil(result.width), height: Darwin.ceil(result.height))
    }
}

// MARK: - 运算符
public extension NSAttributedString {
    /// 将`NSAttributedString`追加到另一个`NSAttributedString`
    /// - Parameters:
    ///   - lhs:目标`NSAttributedString`
    ///   - rhs:待追加`NSAttributedString`
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// 将`String`追加到`NSAttributedString`
    /// - Parameters:
    ///   - lhs:目标`NSAttributedString`
    ///   - rhs:要添加的`String`
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// 合并两个`NSAttributedString`,生成新的`NSAttributedString`
    /// - Parameters:
    ///   - lhs:参与合并的第一个`NSAttributedString`
    ///   - rhs:参与合并的第二个`NSAttributedString`
    /// - Returns:`NSAttributedString`
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    /// 将`String`添加到`NSAttributedString`,返回新的`NSAttributedString`
    /// - Parameters:
    ///   - lhs:目标`NSAttributedString`
    ///   - rhs:要添加的`String`
    /// - Returns:新`NSAttributedString`
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        lhs + NSAttributedString(string: rhs)
    }
}
