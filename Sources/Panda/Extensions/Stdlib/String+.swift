//
//  String+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import CoreGraphics
import CoreLocation
import UIKit

// MARK: - 属性
public extension String {
    /// 返回一个本地化的字符串,带有可选的翻译注释
    /// - Returns: `String`
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

// MARK: - 构造方法
public extension String {
    /// 从`base64`字符串创建一个新字符串(`base64`解码)
    ///
    ///     String(base64:"SGVsbG8gV29ybGQh") = "Hello World!"
    ///     String(base64:"hello") = nil
    /// - Parameters base64:`base64`字符串
    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
}

// MARK: - 下标
public extension String {
    /// 使用索引下标安全地获取字符串中对应的字符
    ///
    ///     "Hello World!"[safe:3] -> "l"
    ///     "Hello World!"[safe:20] -> nil
    /// - Parameters index:索引下标
    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }

    /// 获取某个字符,如果不在范围内,返回`nil`
    subscript(index: Int) -> String? {
        get {
            if index > count - 1 || index < 0 { return nil }
            return String(self[self.index(startIndex, offsetBy: index)])
        }
        set {
            let startIndex = self.index(startIndex, offsetBy: index)
            let endIndex = self.index(after: startIndex)
            replaceSubrange(startIndex ..< endIndex, with: "\(newValue ?? "")")
        }
    }

    /// 在给定范围内安全地获取子字符串
    ///
    ///     "Hello World!"[safe:6..<11] -> "World"
    ///     "Hello World!"[safe:21..<110] -> nil
    ///
    ///     "Hello World!"[safe:6...11] -> "World!"
    ///     "Hello World!"[safe:21...110] -> nil
    /// - Parameters range:范围表达式
    subscript<R>(safe range: R) -> String? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min ..< Int.max)
        guard range.lowerBound >= 0,
              let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
              let upperIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex)
        else { return nil }

        return String(self[lowerIndex ..< upperIndex])
    }

    /// 字符串下标方法 获取指定range字符串/替换指定范围字符串
    subscript(range: Range<Int>) -> String {
        get {
            let startIndex = index(startIndex, offsetBy: range.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: range.upperBound)
            return String(self[startIndex ..< endIndex])
        } set {
            let startIndex = index(startIndex, offsetBy: range.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: range.upperBound)
            replaceSubrange(startIndex ..< endIndex, with: newValue)
        }
    }

    /// 获取字符串指定`NSRange`的子字符串
    /// - Parameter bounds:子字符串的范围,范围的边界必须是集合的有效索引
    /// - Returns:字符串的一部分
    subscript(bounds: NSRange) -> Substring {
        guard let range = Range(bounds, in: self) else { fatalError("Failed to find range \(bounds) in \(self)") }
        return self[range]
    }
}

// MARK: - 类型转换
public extension String {
    /// 转换为`Int`
    func toInt() -> Int {
        Int(self) ?? 0
    }

    /// 转换为`Int64`
    func toInt64() -> Int64 {
        Int64(self) ?? 0
    }

    /// 转换为`UInt`
    func toUInt() -> UInt {
        UInt(self) ?? 0
    }

    /// 转换为`UInt64`
    func toUInt64() -> UInt64 {
        UInt64(self) ?? 0
    }

    /// 转换为`Float`
    func toFloat() -> Float {
        Float(self) ?? 0
    }

    /// 转换为`Double`
    func toDouble() -> Double {
        Double(self) ?? 0
    }

    /// 转换为`CGFloat`
    func toCGFloat() -> CGFloat {
        CGFloat(toDouble())
    }

    /// 转换为`NSNumber`
    func toNSNumber() -> NSNumber {
        NSNumber(value: toDouble())
    }

    /// 转换为`Bool`
    func toBool() -> Bool {
        let trimmed = trim().lowercased()
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    /// 转换为`Character?`
    func toCharacter() -> Character? {
        guard let n = Int(self), let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    /// 转换为`[Character]`
    func toCharacters() -> [Character] {
        Array(self)
    }

    /// 转换为`NSString`
    func toNSString() -> NSString {
        NSString(string: self)
    }

    /// 转换为`16进制Int`
    func toHexInt() -> Int {
        Int(self, radix: 16) ?? 0
    }

    /// 转`utf8`格式`Data`
    /// - Returns: `Data?`
    func toData() -> Data? {
        data(using: .utf8)
    }

    /// `16进制颜色值`字符串转`UIColor`对象
    /// - Returns: `UIColor`
    func toHexColor() -> UIColor {
        UIColor(hex: self)
    }

    /// 图片资源名称转图片对象
    /// - Returns: `UIImage?`
    func toImage() -> UIImage? {
        UIImage(named: self)
    }

    /// 把字符串转为`URL`(失败返回`nil`)
    /// - Returns: `URL?`
    func toURL() -> URL? {
        if hasPrefix("http://") || hasPrefix("https://") {
            return URL(string: self)
        }
        return URL(fileURLWithPath: self)
    }

    /// 字符串转`URLRequest`
    /// - Returns: `URLRequest?`
    func toURLRequest() -> URLRequest? {
        guard let url = toURL() else {
            return nil
        }
        return URLRequest(url: url)
    }

    ///  字符串转`通知名称`
    /// - Returns: `Notification.Name`
    func toNotificationName() -> Notification.Name {
        Notification.Name(self)
    }

    /// 字符串转属性字符串
    /// - Returns: `NSAttributedString`
    func toAttributedString() -> NSAttributedString {
        NSAttributedString(string: self)
    }

    /// 字符串转可变属性字符串
    /// - Returns: `NSMutableAttributedString`
    func toMutableAttributedString() -> NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }
}

// MARK: - 类/实例
public extension String {
    /// `字符串`转指定类类型默认:`AnyClass`
    /// - Parameter name:指定的目标类类型
    /// - Returns:T.Type
    func classNameToClass<T>(for name: T.Type = AnyClass.self) -> T.Type? {
        guard let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else { return nil }
        let classNameString = "\(namespace.removeSomeStringUseSomeString(removeString: " ", replacingString: "_")).\(self)"
        guard let nameClass = NSClassFromString(classNameString) as? T.Type else { return nil }
        return nameClass
    }

    /// `类名字符串`转`类实例`(类需要是继承自`NSObject`)
    /// - Parameter name: 指定的目标类类型
    /// - Returns:指定类型对象
    func classNameToInstance<T>(for name: T.Type = NSObject.self) -> T? where T: NSObject {
        guard let nameClass = classNameToClass(for: name) else {
            return nil
        }
        let object = nameClass.init()
        return object
    }
}

// MARK: - 转字典/字典数组
public extension String {
    /// 字符串转`字典`
    func toJSONObject() -> [String: Any]? {
        guard let data = toData() else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }

    /// 字符串转`字典数组`
    func toJSONObjects() -> [[String: Any]]? {
        guard let data = toData() else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    }
}

// MARK: - Range
public extension String {
    /// 字符串的完整 `Range`
    /// - Returns: `Range<String.Index>?`
    func fullRange() -> Range<String.Index>? {
        startIndex ..< endIndex
    }

    /// 将 `NSRange` 转换为 `Range<String.Index>`
    /// - Parameter NSRange:要转换的`NSRange`
    /// - Returns:在字符串中找到的 `NSRange` 的等效 `Range<String.Index>`
    func range(_ nsRange: NSRange) -> Range<String.Index> {
        guard let range = Range(nsRange, in: self) else { fatalError("Failed to find range \(nsRange) in \(self)") }
        return range
    }

    /// 获取某个`子串`在`父串`中的范围->`Range`
    /// - Parameter str:子串
    /// - Returns:某个子串在父串中的范围
    func range(_ subString: String) -> Range<String.Index>? {
        range(of: subString)
    }

    /// 字符串的完整 `NSRange`
    /// - Returns: `NSRange`
    func fullNSRange() -> NSRange {
        NSRange(startIndex ..< endIndex, in: self)
    }

    /// 将 `Range<String.Index>` 转换为 `NSRange`
    /// - Parameter range:要转换的`Range<String.Index>`
    /// - Returns:在字符串中找到的 `Range` 的等效 `NSRange`
    func nsRange(_ range: Range<String.Index>) -> NSRange {
        NSRange(range, in: self)
    }

    /// 获取指定字符串在属性字符串中的范围
    /// - Parameter subStr:子串
    /// - Returns:某个子串在父串中的范围
    func subNSRange(_ subStr: String) -> NSRange {
        guard let range = range(of: subStr) else {
            return NSRange(location: 0, length: 0)
        }
        return NSRange(range, in: self)
    }
}

// MARK: - 静态方法
public extension String {
    /// 给定长度的`乱数假文`字符串
    /// - Parameters count:限制`乱数假文`字符数(默认为` 445 - 完整`的`乱数假文`)
    /// - Returns:指定长度的`乱数假文`字符串
    static func loremIpsum(of length: Int = 445) -> String {
        guard length > 0 else { return "" }

        // https://www.lipsum.com/
        let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        if loremIpsum.count > length {
            return String(loremIpsum[loremIpsum.startIndex ..< loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
        }
        return loremIpsum
    }

    /// 给定长度的随机字符串
    ///
    ///     String.random(ofLength:18) -> "u7MMZYvGo9obcOcPj8"
    /// - Parameters length:字符串中的字符数
    /// - Returns:给定长度的随机字符串
    static func random(of length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1 ... length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }
}

// MARK: - 位置相关
public extension String {
    /// `子字符串``第一次`出现的位置
    /// - Parameter sub:子字符串
    /// - Returns:返回字符串的位置(如果不存在该字符串则返回 `-1`)
    func positionFirst(of sub: String) -> Int {
        position(of: sub)
    }

    /// `子字符串``最后一次`出现的位置
    /// - Parameter sub:子字符串
    /// - Returns:返回字符串的位置(如果不存在该字符串则返回 `-1`)
    func positionLast(of sub: String) -> Int {
        position(of: sub, backwards: true)
    }

    /// 返回字符串`第一次/最后一次`出现的`位置索引`,不存在返回`-1`
    /// - Parameters:
    ///   - sub:子字符串
    ///   - backwards:如果`backwards`参数设置为`true`,则返回最后一次出现的位置
    /// - Returns: `Int`
    func position(of sub: String, backwards: Bool = false) -> Int {
        var pos = -1
        if let range = range(of: sub, options: backwards ? .backwards : .literal) {
            if !range.isEmpty { pos = distance(from: startIndex, to: range.lowerBound) }
        }
        return pos
    }
}

// MARK: - 字符串截取
public extension String {
    /// 使用指定开始索引和长度切片字符串并赋值给`self`
    /// - Parameters:
    ///   - index:给定索引后要切片的字符数
    ///   - length:给定索引后要切片的字符数
    /// - Returns: `String`
    @discardableResult
    mutating func slice(from index: Int, length: Int) -> String {
        if let str = slicing(from: index, length: length) {
            self = String(str)
        }
        return self
    }

    /// 将给定的字符串从开始索引切片到结束索引(如果适用)
    /// - Parameters:
    ///   - start:切片应该从的字符串索引
    ///   - end:切片应该结束的字符串索引
    /// - Returns: `String`
    @discardableResult
    mutating func slice(from start: Int, to end: Int) -> String {
        guard end >= start else { return self }
        if let str = self[safe: start ..< end] {
            self = str
        }
        return self
    }

    /// 从指定起始索引切片到字符串结束
    /// - Parameter index: 切片应该开始的字符串索引
    /// - Returns: `String`
    @discardableResult
    mutating func slice(at index: Int) -> String {
        guard index < count else { return self }
        if let str = self[safe: index ..< count] {
            self = str
        }
        return self
    }

    /// 从字符串中获取指定开始位置到指定长度的子字符串
    /// - Parameters:
    ///   - index:字符串索引开始
    ///   - length:给定索引后要切片的字符数
    /// - Returns: `String?`
    func slicing(from index: Int, length: Int) -> String? {
        guard length >= 0, index >= 0, index < count else { return nil }
        guard index.advanced(by: length) <= count else {
            return self[safe: index ..< count]
        }
        guard length > 0 else { return "" }
        return self[safe: index ..< index.advanced(by: length)]
    }

    /// 切割字符串(区间范围 前闭后开)
    ///
    ///     CountableClosedRange:可数的闭区间,如 0...2
    ///     CountableRange:可数的开区间,如 0..<2
    ///     ClosedRange:不可数的闭区间,如 0.1...2.1
    ///     Range:不可数的开居间,如 0.1..<2.1
    /// - Parameter range:范围
    /// - Returns:切割后的字符串
    func slice(_ range: CountableRange<Int>) -> String {
        let startIndex = validIndex(original: range.lowerBound)
        let endIndex = validIndex(original: range.upperBound)
        guard startIndex < endIndex else {
            return ""
        }
        return String(self[startIndex ..< endIndex])
    }

    /// 截取子字符串(从`from`开始到`字符串结尾`)
    /// - Parameter from:开始位置
    /// - Returns: `String`
    func subString(from: Int) -> String {
        let end = count
        return self[from ..< end]
    }

    /// 截取子字符串(从`开头`到`to`)
    /// - Parameter to:停止位置
    /// - Returns: `String`
    func subString(to: Int) -> String {
        self[0 ..< to]
    }

    /// 截取子字符串(从`from`开始截取`length`个字符)
    /// - Parameters:
    ///   - from:开始截取位置
    ///   - length:长度
    /// - Returns: `String`
    func subString(from: Int, length: Int) -> String {
        let end = from + length
        return self[from ..< end]
    }

    /// 截取子字符串(从`from`开始截取到`to`)
    /// - Parameters:
    ///   - from:开始位置
    ///   - to:结束位置
    /// - Returns: `String`
    func subString(from: Int, to: Int) -> String {
        self[from ..< to]
    }

    /// 根据`NSRange`截取子字符串
    /// - Parameter range:`NSRange`
    /// - Returns: `String`
    func subString(range: NSRange) -> String {
        toNSString().substring(with: range)
    }

    /// 根据`Range`截取子字符串
    /// - Parameter range:`Range<Int>`
    /// - Returns: `String`
    func subString(range: Range<Int>) -> String {
        self[range]
    }

    /// 根据`Range`截取子字符串
    /// - Parameter range:`Range<String.Index>`
    /// - Returns: `String`
    func subString(range: Range<String.Index>) -> String {
        let subString = self[range]
        return String(subString)
    }

    /// 获取某个位置的字符串
    /// - Parameter index:位置
    /// - Returns:`String`
    func indexString(index: Int) -> String {
        slice(index ..< index + 1)
    }
}

// MARK: - 判断
public extension String {
    /// 检查字符串是否包含一个或多个字母
    ///
    ///     "123abc".hasLetters -> true
    ///     "123".hasLetters -> false
    /// - Returns: `Bool`
    func hasLetters() -> Bool {
        rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    /// 检查字符串是否只包含字母
    ///
    ///     "abc".isAlphabetic -> true
    ///     "123abc".isAlphabetic -> false
    ///
    /// - Returns: `Bool`
    func isAlphabetic() -> Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    /// 检查字符串是否包含一个或多个数字
    ///
    ///     "abcd".hasNumbers -> false
    ///     "123abc".hasNumbers -> true
    ///
    /// - Returns: `Bool`
    func hasNumbers() -> Bool {
        rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    /// 检查字符串是否至少包含一个字母和一个数字
    ///
    ///     "123abc".isAlphaNumeric -> true
    ///     "abc".isAlphaNumeric -> false
    ///
    /// - Returns: `Bool`
    func isAlphaNumeric() -> Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }

    /// 检查字符串是否为有效的`Swift`数字
    ///
    ///     "123".isNumeric -> true
    ///     "1.3".isNumeric -> true (en_US)
    ///     "1,3".isNumeric -> true (fr_FR)
    ///     "abc".isNumeric -> false
    ///
    /// - Returns: `Bool`
    func isSwiftNumeric() -> Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        if #available(iOS 13.0, *) {
            return scanner.scanDecimal() != nil && scanner.isAtEnd
        } else {
            return scanner.scanDecimal(nil) && scanner.isAtEnd
        }
    }

    /// 判断是否是整数
    /// - Returns: `Bool`
    func isPureInt() -> Bool {
        let scan = Scanner(string: self)
        if #available(iOS 13.0, *) {
            return (scan.scanInt() != nil) && scan.isAtEnd
        } else {
            return scan.scanInt(nil) && scan.isAtEnd
        }
    }

    /// 检查字符串是否只包含数字
    ///
    ///     "123".isDigits -> true
    ///     "1.3".isDigits -> false
    ///     "abc".isDigits -> false
    ///
    /// - Returns: `Bool`
    func isDigits() -> Bool {
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    /// 检查给定的字符串是否只包含空格
    /// - Returns: `Bool`
    func isWhitespace() -> Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 检查给定的字符串是否拼写正确
    /// - Returns: `Bool`
    func isSpelledCorrectly() -> Bool {
        let checker = UITextChecker()
        let range = NSRange(startIndex ..< endIndex, in: self)

        let misspelledRange = checker.rangeOfMisspelledWord(
            in: self,
            range: range,
            startingAt: 0,
            wrap: false,
            language: Locale.preferredLanguages.first ?? "en"
        )
        return misspelledRange.location == NSNotFound
    }

    /// 检查字符串是否为回文
    ///
    ///     "abcdcba".isPalindrome -> true
    ///     "Mom".isPalindrome -> true
    ///     "A man a plan a canal, Panama!".isPalindrome -> true
    ///     "Mama".isPalindrome -> false
    ///
    /// - Returns: `Bool`
    func isPalindrome() -> Bool {
        let letters = filter(\.isLetter)
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex ..< midIndex]
        let secondHalf = letters[midIndex ..< letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }

    /// 检查字符串是否只包含唯一字符(没有重复字符)
    /// - Returns: `Bool`
    func hasUniqueCharacters() -> Bool {
        guard count > 0 else { return false }
        var uniqueChars = Set<String>()
        for char in self {
            if uniqueChars.contains(String(char)) { return false }
            uniqueChars.insert(String(char))
        }
        return true
    }

    /// 判断是不是九宫格键盘
    /// - Returns: `Bool`
    func isNineKeyBoard() -> Bool {
        let other: NSString = "➋➌➍➎➏➐➑➒"
        let len = count
        for _ in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        return true
    }

    /// 利用正则表达式判断是否是手机号码
    /// - Returns: `Bool`
    func isTelNumber() -> Bool {
        let pattern = "^1[3456789]\\d{9}$"
        return regexp(pattern)
    }

    /// 是否是字母数字(指定范围)
    /// - Returns: `Bool`
    func isAlphanueric(minLen: Int, maxLen: Int) -> Bool {
        let pattern = "^[0-9a-zA-Z_]{\(minLen),\(maxLen)}$"
        return regexp(pattern)
    }

    /// 是否是字母与数字
    /// - Returns: `Bool`
    func isAlphanueric() -> Bool {
        let pattern = "^[A-Za-z0-9]+$"
        return isMatchRegexp(pattern)
    }

    /// 是否是纯汉字
    /// - Returns: `Bool`
    func isChinese() -> Bool {
        let pattern = "(^[\u{4e00}-\u{9fef}]+$)"
        return regexp(pattern)
    }

    /// 是否是邮箱格式
    /// - Returns: `Bool`
    func isEmail2() -> Bool {
        //     let pattern = "^([a-z0-9A-Z]+[-_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$"
        let pattern = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?"
        return regexp(pattern)
    }

    /// 检查字符串是否为有效的电子邮件格式
    ///
    /// - Note:请注意,此属性不会针对电子邮件服务器验证电子邮件地址.它只是试图确定其格式是否适合电子邮件地址
    ///
    ///     "john@doe.com".isValidEmail -> true
    ///
    /// - Returns: `Bool`
    func isEmail() -> Bool {
        // http://emailregex.com/
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 是否是有效昵称,即允许`中文`、`英文`、`数字`
    /// - Returns: `Bool`
    func isNickName() -> Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        return regexp(rgex)
    }

    /// 是否为合法用户名
    func validateUserName() -> Bool {
        let rgex = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        return regexp(rgex)
    }

    /// 设置密码必须符合由`数字`、`大写字母`、`小写字母`、`特殊符`
    /// - Parameter complex:是否复杂密码 至少其中(两种/三种)组成密码
    /// - Returns: `Bool`
    func password(_ complex: Bool = false) -> Bool {
        var pattern = "^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{8,20}$"
        if complex {
            pattern = "^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\\W_]+$)(?![a-z0-9]+$)(?![a-z\\W_]+$)(?![0-9\\W_]+$)[a-zA-Z0-9\\W_]{8,20}$"
        }
        return regexp(pattern)
    }

    /// 是否为`0-9`之间的数字(字符串的组成是:`0-9`之间的`数字`)
    /// - Returns:返回结果
    func isNumberValue() -> Bool {
        guard !isEmpty else {
            return false
        }
        let rgex = "^[\\d]*$"
        return regexp(rgex)
    }

    /// 是否为`数字`或者`小数点`(字符串的组成是:`0-9之间`的`数字`或者`小数点`即可)
    /// - Returns:返回结果
    func isValidNumberAndDecimalPoint() -> Bool {
        guard !isEmpty else {
            return false
        }
        let rgex = "^[\\d.]*$"
        return regexp(rgex)
    }

    /// 正则匹配用户身份证号15或18位
    /// - Returns:返回结果
    func isIDNumber() -> Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
        return regexp(pattern)
    }

    /// 严格判断是否有效的身份证号码,检验了省份,生日,校验位,不过没检查市县的编码
    var isValidIDNumber: Bool {
        let str = trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let len = str.count
        if !str.isIDNumber() {
            return false
        }
        // 省份代码
        let areaArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        if !areaArray.contains(str.subString(to: 2)) {
            return false
        }
        var regex = NSRegularExpression()
        var numberOfMatch = 0
        var year = 0
        switch len {
        case 15:
            // 15位身份证
            // 这里年份只有两位,00被处理为闰年了,对2000年是正确的,对1900年是错误的,不过身份证是1900年的应该很少了
            year = Int(str.subString(from: 6, length: 2))!
            if isLeapYear(year: year) { // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: len))

            if numberOfMatch > 0 { return true } else { return false }
        case 18:
            // 18位身份证
            year = Int(str.subString(from: 6, length: 4))!
            if isLeapYear(year: year) {
                // 闰年
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    // 检测出生日期的合法性
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: len))
            if numberOfMatch > 0 {
                var s = 0
                let jiaoYan = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3]
                for i in 0 ..< 17 {
                    if let d = Int(str.slice(i ..< (i + 1))) {
                        s += d * jiaoYan[i % 10]
                    } else {
                        return false
                    }
                }
                let Y = s % 11
                let JYM = "10X98765432"
                let M = JYM.subString(from: Y, length: 1)
                if M == str.subString(from: 17, length: 1) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        default:
            return false
        }
    }

    /// 是否是闰年
    /// - Parameter year:年份
    /// - Returns:返回是否是闰年
    private func isLeapYear(year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        } else if year % 100 == 0 {
            return false
        } else if year % 4 == 0 {
            return true
        } else {
            return false
        }
    }

    /// 检查字符串是否是有效的URL
    ///
    ///     "https://google.com".isValidURL -> true
    ///
    /// - Returns: `Bool`
    func isURL() -> Bool {
        URL(string: self) != nil
    }

    /// 检查字符串是否是有效带协议头的URL
    ///
    ///     "https://google.com".isValidSchemedURL -> true
    ///     "google.com".isValidSchemedURL -> false
    ///
    /// - Returns: `Bool`
    func isSchemedURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// 检查字符串是否是有效的https URL
    ///
    ///     "https://google.com".isValidHttpsURL -> true
    ///
    /// - Returns: `Bool`
    func isHTTPSURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }

    /// 检查字符串是否是有效的http URL
    ///
    ///     "http://google.com".isValidHttpURL -> true
    ///
    /// - Returns: `Bool`
    func isHTTPURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }

    /// 检查字符串是否是有效的文件URL
    ///
    ///     "file://Documents/file.txt".isValidFileURL -> true
    ///
    /// - Returns: `Bool`
    func isFileURL() -> Bool {
        URL(string: self)?.isFileURL ?? false
    }

    /// 判断是否包含某个子串`区分大小写`
    /// - Parameter find:子串
    /// - Returns:`Bool`
    func contains(find: String) -> Bool {
        contains(find, caseSensitive: true)
    }

    /// 检查字符串是否包含子字符串的一个或多个实例
    ///
    ///     "Hello World!".contain("O") -> false
    ///     "Hello World!".contain("o", caseSensitive:false) -> true
    /// - Parameters:
    ///   - string:要搜索的子字符串
    ///   - caseSensitive:是否区分大小写(默认值为`true`)
    /// - Returns:如果字符串包含一个或多个子字符串实例,则为`true`
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }

    ///  判断是否包含某个子串`忽略大小写`
    /// - Parameter find:子串
    /// - Returns:`Bool`
    func containsIgnoringCase(find: String) -> Bool {
        contains(find, caseSensitive: false)
    }

    /// 检查字符串是否以子字符串开头
    ///
    ///     "hello World".starts(with:"h") -> true
    ///     "hello World".starts(with:"H", caseSensitive:false) -> true
    /// - Parameters:
    ///   - suffix:搜索字符串是否以开头的子字符串
    ///   - caseSensitive:是否区分大小写(默认为`true`)
    /// - Returns:`true`
    func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }

    /// 检查字符串是否以子字符串结尾
    ///
    ///     "Hello World!".ends(with:"!") -> true
    ///     "Hello World!".ends(with:"WoRld!", caseSensitive:false) -> true
    /// - Parameters:
    ///   - suffix:用于搜索字符串是否以结尾的子字符串
    ///   - caseSensitive:是否区分大小写(默认为`true`)
    /// - Returns:`Bool`
    func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
}

// MARK: - 正则相关运算符
/// 定义操作符
infix operator =~: RegPrecedence
precedencegroup RegPrecedence {
    associativity: none
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

/// 正则匹配操作符
public func =~ (lhs: String, rhs: String) -> Bool {
    lhs.regexp(rhs)
}

// MARK: - 正则
public extension String {
    /// 验证`字符串`是否匹配`正则表达式`匹配
    /// - Parameters pattern:正则表达式
    /// - Returns:如果字符串与模式匹配,则返回:`true`
    func matches(pattern: String) -> Bool {
        range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 验证`字符串`是否与`正则表达式`匹配
    /// - Parameters:
    ///   - regex:进行验证的正则表达式
    ///   - options:要使用的匹配选项
    /// - Returns:如果字符串与正则表达式匹配,则返回:`true`
    func matches(regex: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        let range = NSRange(startIndex ..< endIndex, in: self)
        return regex.firstMatch(in: self, options: options, range: range) != nil
    }

    /// 正则校验
    /// - Parameter pattern:要校验的正则表达式
    /// - Returns:是否通过
    func regexp(_ pattern: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }

    /// 返回指定表达式的值
    /// - Parameters:
    ///   - pattern:正则表达式
    ///   - count:匹配数量
    func regexpText(_ pattern: String, count: Int = 1) -> [String]? {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))
        else { return nil }
        var texts = [String]()
        for idx in 1 ... count {
            let text = toNSString().substring(with: result.range(at: idx))
            texts.append(text)
        }
        return texts
    }

    /// 是否有与正则匹配的项
    /// - Parameter pattern:正则表达式
    /// - Returns:是否匹配
    func isMatchRegexp(_ pattern: String) -> Bool {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        let result = regx.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: utf16.count))
        return !result.isEmpty
    }

    /// 获取匹配的`NSRange`
    /// - Parameters:
    ///   - pattern:匹配规则
    /// - Returns:返回匹配的[NSRange]结果
    func matchRange(_ pattern: String) -> [NSRange] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return []
        }
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))
        guard !matches.isEmpty else {
            return []
        }
        return matches.map { value in
            value.range
        }
    }
}

// MARK: - HTML字符引用
public extension String {
    /// `字符串`转为`HTML字符引用`
    /// - Returns:字符引用
    func stringAsHtmlCharacterEntityReferences() -> String {
        var result = ""
        for scalar in utf16 {
            // 将十进制转成十六进制,不足4位前面补0
            let tem = String().appendingFormat("%04x", scalar)
            result += "&#x\(tem);"
        }
        return result
    }

    /// `HTML字符引用`转`字符串`
    /// - Returns:普通字符串
    func htmlCharacterEntityReferencesAsString() -> String? {
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                                                     NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
        guard let encodedData = data(using: String.Encoding.utf8) else { return nil }
        guard let attributedString = try? NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil) else { return nil }
        return attributedString.string
    }
}

// MARK: - 属性字符串相关
public extension String {
    /// `HTML源码`转`属性字符串`
    /// - Parameters:
    ///   - font:字体
    ///   - lineSpacing:行间距
    /// - Returns:属性字符串
    func htmlCodeToAttributedString(font: UIFont? = UIFont.systemFont(ofSize: 12),
                                    lineSpacing: CGFloat? = 10) -> NSMutableAttributedString
    {
        var htmlString: NSMutableAttributedString?
        do {
            if let data = replacingOccurrences(of: "\n", with: "<br/>").data(using: .utf8) {
                htmlString = try NSMutableAttributedString(data: data, options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue),
                ], documentAttributes: nil)
                let wrapHtmlString = NSMutableAttributedString(string: "\n")
                // 判断尾部是否是换行符
                if let weakHtmlString = htmlString, weakHtmlString.string.hasSuffix("\n") {
                    htmlString?.deleteCharacters(in: NSRange(location: weakHtmlString.length - wrapHtmlString.length, length: wrapHtmlString.length))
                }
            }
        } catch {}
        // 设置属性字符串字体的大小
        if let font { htmlString?.addAttributes([.font: font], range: fullNSRange()) }

        // 设置行间距
        if let weakLineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle.default().pd_lineSpacing(weakLineSpacing)
            htmlString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullNSRange())
        }
        return htmlString ?? toMutableAttributedString()
    }

    /// 高亮显示关键字(返回属性字符串)
    /// - Parameters:
    ///   - keyword:要高亮的关键词
    ///   - keywordCololor:关键高亮字颜色
    ///   - otherColor:非高亮文字颜色
    ///   - options:匹配选项
    /// - Returns:返回匹配后的属性字符串
    func highlightSubString(keyword: String,
                            keywordCololor: UIColor,
                            otherColor: UIColor,
                            options: NSRegularExpression.Options = []) -> NSMutableAttributedString
    {
        // 整体字符串
        let fullString = self
        // 整体属性字符串
        let attributedString = fullString.toMutableAttributedString().pd_addAttributes([
            NSAttributedString.Key.foregroundColor: otherColor,
        ])

        // 与关键词匹配的range数组
        let ranges = fullString.matchRange(keyword)

        // 设置高亮颜色
        for range in ranges {
            attributedString.addAttributes([.foregroundColor: keywordCololor], range: range)
        }
        return attributedString
    }
}

// MARK: - `NSDecimalNumber`苹果针对浮点类型计算精度问题提供出来的计算类 四则运算
public extension String {
    /// `＋` 加法运算
    /// - Parameter strNumber:加数字符串
    /// - Returns:结果数字串
    func adding(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .zero }
        let final = ln.adding(rn)
        return final.stringValue
    }

    /// `－` 减法运算
    /// - Parameter strNumber:减数字符串
    /// - Returns:结果
    func subtracting(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .zero }
        let final = ln.subtracting(rn)
        return final.stringValue
    }

    /// `*` 乘法运算
    /// - Parameter strNumber:乘数字符串
    /// - Returns:结果
    func multiplying(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .zero }
        let final = ln.multiplying(by: rn)
        return final.stringValue
    }

    /// `/`除法运算
    /// - Parameter strNumber:除数
    /// - Returns:结果
    func dividing(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .one }
        if rn.doubleValue == 0 { rn = .one }
        let final = ln.dividing(by: rn)
        return final.stringValue
    }
}

// MARK: - 数字字符串
public extension String {
    /// 金额字符串转化为带逗号的金额, 按照千分位表示
    ///
    ///     "1234567" => 1,234,567
    ///     "1234567.56" => 1,234,567.56
    /// - Returns:千分位表示字符串
    func amountAsThousands() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        if contains(".") {
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.minimumIntegerDigits = 1
        }
        var num = NSDecimalNumber(string: self)
        if num.doubleValue.isNaN { num = NSDecimalNumber(string: "0") }
        let result = formatter.string(from: num)
        return result
    }

    /// 删除小数点后面多余的0
    /// - Returns:删除小数点后多余0的数字字符串
    func deleteMoreThanZeroFromAfterDecimalPoint() -> String {
        var rst = self
        var i = 1
        if contains(".") {
            while i < count {
                if rst.hasSuffix("0") {
                    rst.removeLast()
                    i = i + 1
                } else { break }
            }
            if rst.hasSuffix(".") { rst.removeLast() }
            return rst
        } else { return self }
    }

    /// 保留小数点后面指定位数
    /// - Parameters:
    ///   - numberDecimal:保留几位小数
    ///   - mode:模式
    /// - Returns:返回保留后的小数(非数字字符串,返回0或0.0)
    func keepDecimalPlaces(decimalPlaces: Int = 0, mode: NumberFormatter.RoundingMode = .floor) -> String {
        // 转为小数对象
        var decimalNumber = NSDecimalNumber(string: self)

        // 如果不是数字,设置为0值
        if decimalNumber.doubleValue.isNaN {
            decimalNumber = NSDecimalNumber.zero
        }
        // 数字格式化对象
        let formatter = NumberFormatter()
        // 模式
        formatter.roundingMode = mode
        // 小数位最多位数
        formatter.maximumFractionDigits = decimalPlaces
        // 小数位最少位数
        formatter.minimumFractionDigits = decimalPlaces
        // 整数位最少位数
        formatter.minimumIntegerDigits = 1
        // 整数位最多位数
        formatter.maximumIntegerDigits = 100

        // 获取结果
        guard let result = formatter.string(from: decimalNumber) else {
            // 异常处理
            if decimalPlaces == 0 { return "0" } else {
                var zero = ""
                for _ in 0 ..< decimalPlaces { zero += zero }
                return "0." + zero
            }
        }
        return result
    }
}

// MARK: - URL编解码(属性)
public extension String {
    /// 编码`URL`字符串(`URL`转义字符串)
    ///
    ///     "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    /// - Returns: `String`
    func urlEncoded() -> String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    /// 把编码过的`URL`字符串解码成可读格式(`URL`字符串解码)
    ///
    ///     "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    /// - Returns: `String`
    func urlDecoded() -> String {
        removingPercentEncoding ?? self
    }

    /// 转义字符串(`URL`编码)
    ///
    ///     var str = "it's easy to encode strings"
    ///     str.urlEncode()
    ///     print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    /// - Returns: `String`
    @discardableResult
    mutating func urlEncode() -> String {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            self = encoded
        }
        return self
    }

    /// `URL`字符串转换为可读字符串(`URL`转义字符串解码)
    ///
    ///     var str = "it's%20easy%20to%20decode%20strings"
    ///     str.urlDecode()
    ///     print(str) // prints "it's easy to decode strings"
    ///
    /// - Returns: `String`
    @discardableResult
    mutating func urlDecode() -> String {
        if let decoded = removingPercentEncoding { self = decoded }
        return self
    }
}

// MARK: - base64(属性)
public extension String {
    /// `Base64` 编解码
    /// - Parameter encode:`true`:编码 `false`:解码
    /// - Returns: 编解码结果
    func base64String(encode: Bool) -> String? {
        encode ? base64Encoded() : base64Decoded()
    }

    /// `base64`加密
    ///
    ///     "Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
    ///
    func base64Encoded() -> String? {
        let plainData = toData()
        return plainData?.base64EncodedString()
    }

    /// `base64`解密
    ///
    ///     "SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
    ///
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }

        let remainder = count % 4

        var padding = ""
        if remainder > 0 { padding = String(repeating: "=", count: 4 - remainder) }

        guard let data = Data(base64Encoded: self + padding, options: .ignoreUnknownCharacters) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}

// MARK: - unicode编码和解码
public extension String {
    /// `Unicode`编码
    /// - Returns:`unicode`编码后的字符串
    func unicodeEncode() -> String {
        var tempStr = String()
        for v in utf16 {
            if v < 128 {
                tempStr.append(Unicode.Scalar(v)!.escaped(asASCII: true))
                continue
            }
            let codeStr = String(v, radix: 16, uppercase: false)
            tempStr.append("\\u" + codeStr)
        }

        return tempStr
    }

    /// `Unicode`解码
    /// - Returns:`unicode`解码后的字符串
    func unicodeDecode() -> String {
        let tempStr1 = replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print("😭出错啦! \(error.localizedDescription)")
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}

// MARK: - Date
public extension String {
    /// `格式日期字符串`成`日期对象`
    /// - Parameters format:日期格式
    /// - Returns:`Date?`
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    /// `日期格式字符串`转`时间戳(秒)`
    /// - Parameter format:日期格式
    /// - Returns:`Double`(秒)
    func toUnixTimestamp(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Double {
        let date = toDate(withFormat: format)
        return date?.timeIntervalSince1970 ?? 0
    }
}

// MARK: - 位置
public extension String {
    /// 地理编码(`地址转坐标`)
    /// - Parameter completionHandler: 回调函数
    func locationEncode(completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().geocodeAddressString(self, completionHandler: completionHandler)
    }
}

// MARK: - URL
public extension String {
    /// 提取出字符串中所有的`URL`链接
    /// - Returns: `[String]?`
    func urls() -> [String]? {
        var urls = [String]()
        // 创建一个正则表达式对象
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue)) else { return nil }
        // 匹配字符串,返回结果集
        let res = dataDetector.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: count))
        // 取出结果
        for checkingRes in res { urls.append(toNSString().substring(with: checkingRes.range)) }
        return urls
    }

    /// 截取参数列表
    /// - Returns: `[String: Any]`
    func urlParamters() -> [String: Any] {
        guard let urlComponents = NSURLComponents(string: self),
              let queryItems = urlComponents.queryItems else { return [:] }

        var parameters = [String: Any]()
        for item in queryItems {
            guard let value = item.value else { continue }
            if let exist = parameters[item.name] {
                if var exist = exist as? [String] {
                    exist.append(value)
                } else {
                    parameters[item.name] = [exist as! String, value]
                }
            } else { parameters[item.name] = value }
        }
        return parameters
    }
}

// MARK: - Path
public extension String {
    /// 路径字符串的最后一个路径组件
    /// - Returns: `String`
    func lastPathComponent() -> String {
        toNSString().lastPathComponent
    }

    /// 路径的扩展名
    /// - Returns: `String`
    func pathExtension() -> String {
        toNSString().pathExtension
    }

    /// 返回删除了最后一个路径组件之后的字符串
    /// - Returns: `String`
    func deletingLastPathComponent() -> String {
        toNSString().deletingLastPathComponent
    }

    /// 返回删除了路径扩展之后的字符串
    /// - Returns: `String`
    func deletingPathExtension() -> String {
        toNSString().deletingPathExtension
    }

    /// 获取路径组件数组
    /// - Returns: `[String]`
    func pathComponents() -> [String] {
        toNSString().pathComponents
    }

    /// 添加路径组件类似`NSString=>appendingPathComponent(str:String)`
    ///
    /// - Note:此方法仅适用于文件路径(例如,URL 的字符串表示形式
    /// - Parameter str:要添加的路径组件(如果需要可以在前面添加分隔符`/`)
    /// - Returns:添加路径组件后而生成的新字符串
    func appendingPathComponent(_ str: String) -> String {
        toNSString().appendingPathComponent(str)
    }

    /// 添加路径扩展类似`NSString=>appendingPathExtension(str:String)`
    /// - Parameters str:要添加的扩展
    /// - Returns:添加路径扩展后而生成的新字符串
    func appendingPathExtension(_ str: String) -> String? {
        toNSString().appendingPathExtension(str)
    }
}

// MARK: - 沙盒路径
public extension String {
    /// `Support` 追加后的`目录 / 文件地址` `备份在 iCloud`
    func appendBySupport() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// `Documents` 追加后的`目录／文件地址`
    func appendByDocument() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// `Cachees` 追加后的`目录／文件地址`
    func appendByCache() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(self)"
    }

    /// `tmp` 追加后的`目录／文件地址`
    func appendByTemp() -> String {
        let directory = NSTemporaryDirectory()
        createDirs(directory)
        return directory + "/\(self)"
    }
}

// MARK: - 沙盒URL
public extension String {
    /// `Support` 追加后的`目录／文件地址` `备份在 iCloud`
    func urlBySupport() -> URL {
        var fileURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        _ = appendByDocument()
        fileURL = fileURL.appendingPathComponent(self)
        return fileURL
    }

    /// `Documents` 追加后的`目录／文件地址`
    func urlByDocument() -> URL {
        var fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        _ = appendByDocument()
        fileURL = fileURL.appendingPathComponent(self)
        return fileURL
    }

    /// `Cachees` 追加后的`目录／文件地址`
    func urlByCache() -> URL {
        var fileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        _ = appendByCache()
        fileURL = fileURL.appendingPathComponent(self)
        return fileURL
    }
}

// MARK: - 文件操作
public extension String {
    /// 删除文件
    func removeFile() {
        if FileManager.default.fileExists(atPath: self) {
            do {
                try FileManager.default.removeItem(atPath: self)
            } catch { debugPrint("文件删除失败!") }
        }
    }

    /// 创建目录
    /// 如 `cache/`；以`/`结束代表是`目录`
    func createDirs(_ directory: String = NSHomeDirectory()) {
        let path = contains(NSHomeDirectory()) ? self : "\(directory)/\(self)"
        let dirs = path.components(separatedBy: "/")
        let dir = dirs[0 ..< dirs.count - 1].joined(separator: "/")
        if !FileManager.default.fileExists(atPath: dir) {
            do {
                try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            } catch { print(error) }
        }
    }
}

// MARK: - 剪切板
public extension String {
    /// 将字符串复制到全局粘贴板
    ///
    ///     "SomeText".copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    func copyToPasteboard() {
        #if os(iOS)
            UIPasteboard.general.string = self
        #elseif os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(base, forType: .string)
        #endif
    }
}

// MARK: - 字符串尺寸计算
public extension String {
    /// 计算字符串大小
    /// - Parameters:
    ///   - maxWidth:最大宽度
    ///   - font:文字字体
    /// - Returns:结果`CGSize`
    func strSize(_ maxWidth: CGFloat = UIScreen.main.bounds.width, font: UIFont) -> CGSize {
        let constraint = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = toNSString().boundingRect(with: constraint,
                                             options: [
                                                 .usesLineFragmentOrigin,
                                                 .usesFontLeading,
                                                 .truncatesLastVisibleLine,
                                             ],
                                             attributes: [.font: font],
                                             context: nil)

        return CGSize(width: Foundation.ceil(rect.width), height: Foundation.ceil(rect.height))
    }

    /// 以属性字符串的方式计算字符串大小
    /// - Parameters:
    ///   - maxWidth:最大宽度
    ///   - font:字体
    ///   - lineSpaceing:行间距
    ///   - wordSpacing:字间距
    /// - Returns:结果`CGSize`
    func attributeSize(_ maxWidth: CGFloat = UIScreen.main.bounds.width,
                       font: UIFont,
                       lineSpacing: CGFloat = 0,
                       wordSpacing: CGFloat = 0) -> CGSize
    {
        // 段落样式
        let paragraphStyle = NSMutableParagraphStyle.default()
            .pd_lineBreakMode(.byCharWrapping)
            .pd_alignment(.left)
            .pd_lineSpacing(lineSpacing)
            .pd_hyphenationFactor(1.0)
            .pd_firstLineHeadIndent(0.0)
            .pd_paragraphSpacingBefore(0.0)
            .pd_headIndent(0)
            .pd_tailIndent(0)

        // 属性字符串
        let attString = toMutableAttributedString().pd_addAttributes([
            .font: font,
            .kern: wordSpacing,
            .paragraphStyle: paragraphStyle,
        ])

        let constraint = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let textSize = attString.boundingRect(with: constraint,
                                              options: [
                                                  .usesLineFragmentOrigin,
                                                  .usesFontLeading,
                                                  .truncatesLastVisibleLine,
                                              ], context: nil).size
        // 向上取整(由于计算结果小数问题, 导致界面字符串显示不完整)
        return CGSize(width: Foundation.ceil(textSize.width), height: Foundation.ceil(textSize.height))
    }
}

// MARK: - 方法
public extension String {
    ///  字符串的第一个字符
    /// - Returns: `String?`
    func firstCharacter() -> String? {
        guard let first = first?.toString() else { return nil }
        return first
    }

    /// 字符串最后一个字符
    /// - Returns: `String?`
    func lastCharacter() -> String? {
        guard let last = last?.toString() else { return nil }
        return last
    }

    /// 字符串中的字数(`word`)
    ///
    ///     "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns:字符串中包含的单词数
    func wordCount() -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }

    /// 字符串中的数字个数
    func numericCount() -> Int {
        var count = 0
        for c in self where ("0" ... "9").contains(c) {
            count += 1
        }
        return count
    }

    /// 计算字符个数(`英文 = 1`,`数字 = 1`,`汉语 = 2`)
    var countOfChars: Int {
        var count = 0
        guard !isEmpty else {
            return 0
        }
        for i in 0 ... self.count - 1 {
            let c: unichar = toNSString().character(at: i)
            if c >= 0x4E00 {
                count += 2
            } else {
                count += 1
            }
        }
        return count
    }

    /// 字符串中的子字符串个数
    ///
    ///     "Hello World!".count(of:"o") -> 2
    ///     "Hello World!".count(of:"L", caseSensitive:false) -> 3
    /// - Parameters:
    ///   - string:要搜索的子字符串
    ///   - caseSensitive:是否区分大小写(默认为`true`)
    /// - Returns:子字符串在字符串中出现的计数
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive { return lowercased().components(separatedBy: string.lowercased()).count - 1 }
        return components(separatedBy: string).count - 1
    }

    /// 查找字符串中出现最频繁的字符
    ///
    ///     "This is a test, since e is appearing everywhere e should be the common character".mostCommonCharacter() -> "e"
    ///
    /// - Returns:出现最频繁的字符
    func mostCommonCharacter() -> Character? {
        let mostCommon = withoutSpacesAndNewLines().reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.key
        return mostCommon
    }

    /// 校验`字符串位置`是否有效,并返回`String.Index`
    /// - Parameter original:位置
    /// - Returns:`String.Index`
    func validIndex(original: Int) -> String.Index {
        switch original {
        case ...startIndex.utf16Offset(in: self):
            return startIndex
        case endIndex.utf16Offset(in: self)...:
            return endIndex
        default:
            return index(startIndex, offsetBy: original)
        }
    }

    /// 字符串中所有字符的`unicode`数组
    ///
    ///     "SwifterSwift".unicodeArray() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    ///
    /// - Returns:字符串中所有字符的 unicode
    func unicodeArray() -> [Int] {
        unicodeScalars.map { Int($0.value) }
    }

    /// 字符串中所有单词的数组
    ///
    ///     "Swift is amazing".words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns:字符串中包含的单词
    func words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }

    /// 从字符串中提取链接和文本
    /// - Returns: `(link: String, text: String)?`
    func hrefText() -> (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\"(.*?)>(.*?)</a>"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count))
        else { return nil }
        let link = toNSString().substring(with: result.range(at: 1))
        let text = toNSString().substring(with: result.range(at: 3))
        return (link, text)
    }

    /// 返回当前字符窜中的 `link range`数组
    /// - Returns: `[NSRange]?`
    func linkRanges() -> [NSRange]? {
        // url, ##, 中文字母数字
        let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
        // 遍历数组,生成range的数组
        var ranges = [NSRange]()

        for pattern in patterns {
            guard let regx = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
                return nil
            }
            let matches = regx.matches(in: self, options: [], range: NSRange(location: 0, length: count))
            for m in matches {
                ranges.append(m.range(at: 0))
            }
        }
        return ranges
    }

    /// 由换行符分隔的字符串数组(获取字符串行数, `\n`分割)
    ///
    ///     "Hello\ntest".lines() -> ["Hello", "test"]
    ///
    /// - Returns:分割后的字符串数组
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in result.append(line) }
        return result
    }

    /// 获取文字的每一行字符串 空字符串为空数组(⚠️不适用于属性文本)
    /// - Parameters:
    ///   - maxWidth: 最大宽度
    ///   - font: 字体
    /// - Returns: 行字符串数组
    func lines(_ maxLineWidth: CGFloat, font: UIFont) -> [String] {
        // 段落样式
        let style = NSMutableParagraphStyle.default().pd_lineBreakMode(.byCharWrapping)

        // UIFont字体转CFFont
        let cfFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)

        // 属性字符串
        let attributedString = toMutableAttributedString()
            .pd_addAttributes([
                .paragraphStyle: style,
                NSAttributedString.Key(kCTFontAttributeName as String): cfFont,
            ], for: fullNSRange())

        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)

        let path = CGMutablePath.default().pd_addRect(CGRect(x: 0, y: 0, width: maxLineWidth, height: 100_000))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(CFIndex(0), CFIndex(0)), path, nil)
        let lines = CTFrameGetLines(frame) as? [AnyHashable]

        var result: [String] = []
        for line in lines ?? [] {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            let range = NSRange(location: lineRange.location, length: lineRange.length)

            let lineString = (self as NSString).substring(with: range)
            CFAttributedStringSetAttribute(attributedString, lineRange, kCTKernAttributeName, NSNumber(value: 0.0))
            result.append(lineString)
        }
        return result
    }

    /// 字符串转换成驼峰命名法(并移除空字符串)
    ///
    ///     "sOme vAriable naMe".camelCased -> "someVariableName"
    /// - Returns: `String`
    func toCamelCase() -> String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }

    /// `汉字字符串`转成`拼音字符串`
    /// - Parameter isLatin:`true:带声调`,`false:不带声调`,`默认 false`
    /// - Returns:拼音字符串
    func toPinYin(_ isTone: Bool = false) -> String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        // 将汉字转换为拼音(带音标)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        // 去掉拼音的音标
        if !isTone { CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false) }
        return mutableString as String
    }

    /// 提取汉字拼音首字母(每个汉字)
    ///
    ///     "爱国" --> AG
    /// - Parameter isUpper:`true:大写首字母`,`false:小写首字母`,`默认true`
    /// - Returns:字符串的拼音首字母字符串
    func toPinYinInitials(_ isUpper: Bool = true) -> String {
        let pinYin = toPinYin(false).components(separatedBy: " ")
        let initials = pinYin.compactMap { String(format: "%c", $0.cString(using: .utf8)![0]) }
        return isUpper ? initials.joined().uppercased() : initials.joined()
    }

    /// 返回一个本地化的字符串,带有可选的翻译注释
    /// - Parameter comment: 注释
    /// - Returns: `String`
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }

    /// 将字符串转换为 `slug 字符串`
    ///
    ///     "Swift is amazing".toSlug() -> "swift-is-amazing"
    ///
    /// - Returns:`slug格式`的字符串
    func toSlug() -> String {
        let lowercased = lowercased()
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        while filtered.lastCharacter() == "-" { filtered = String(filtered.dropLast()) }
        while filtered.firstCharacter() == "-" { filtered = String(filtered.dropFirst()) }

        return filtered.replacingOccurrences(of: "--", with: "-")
    }

    /// 删除字符串开头和结尾的空格和换行符
    ///
    ///     var str = "  \n Hello World \n\n\n"
    ///     str.trim()
    ///     print(str) // prints "Hello World"
    ///
    /// - Returns: `String`
    @discardableResult
    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 去除字符串前后的空格
    /// - Returns: `String`
    func trimmedSpace() -> String {
        let resultString = trimmingCharacters(in: CharacterSet.whitespaces)
        return resultString
    }

    /// 去除字符串前后的换行
    /// - Returns: `String`
    func trimmedNewLines() -> String {
        let resultString = trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }

    /// 移除字符串中的空格
    /// - Returns: `String`
    func withoutSpaces() -> String {
        replacingOccurrences(of: " ", with: "")
    }

    /// 移除字符串中的换行符
    /// - Returns: `String`
    func withoutNewLines() -> String {
        replacingOccurrences(of: "\n", with: "")
    }

    /// 移除字符串中的空格及换行符
    ///
    ///     "   \n Swifter   \n  Swift  ".withoutSpacesAndNewLines -> "SwifterSwift"
    ///
    /// - Returns: `String`
    func withoutSpacesAndNewLines() -> String {
        replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }

    /// 将正则表达式加上`"\"`进行保护,将元字符转化成字面值
    ///
    ///     "hello ^$ there" -> "hello \\^\\$ there"
    ///
    /// - Returns: `String`
    func regexEscaped() -> String {
        NSRegularExpression.escapedPattern(for: self)
    }

    /// 字符串的首字符大写,其它字符保持原样
    ///
    ///     "hello world".firstCharacterUppercased() -> "Hello world"
    ///     "".firstCharacterUppercased() -> ""
    ///
    /// - Returns: `String`
    func firstCharacterUppercased() -> String? {
        guard let first else { return nil }
        return String(first).uppercased() + dropFirst()
    }

    /// 翻转字符串
    /// - Returns: `String`
    mutating func reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }

    /// 截断字符串(限于给定数量的字符)
    ///
    ///     "This is a very long sentence".truncated(toLength:14) -> "This is a very..."
    ///     "Short sentence".truncated(toLength:14) -> "Short sentence"
    /// - Parameters:
    ///   - toLength:切割前的最大字符数(从字符开头要保留的字符数量)
    ///   - trailing:要添加到截断字符串末尾的字符串(默认为“...”)
    /// - Returns:截断的字符串+尾巴
    func truncated(toLength length: Int, trailing: String? = "...") -> String {
        guard 0 ..< count ~= length else { return self }
        return self[startIndex ..< index(startIndex, offsetBy: length)] + (trailing ?? "")
    }

    /// 省略字符串
    /// - Parameters:
    ///   - length:开始省略长度(保留长度)
    ///   - suffix:后缀
    /// - Returns: `String`
    func truncate(_ length: Int, suffix: String = "...") -> String {
        count > length ? self[0 ..< length] + suffix : self
    }

    /// 分割字符串
    /// - Parameters:
    ///   - length:每段长度
    ///   - separator:分隔符
    /// - Returns: `String`
    func truncate(_ length: Int, separator: String = "-") -> String {
        var newValue = ""
        for (i, char) in enumerated() {
            if i > (count - length) {
                newValue += "\(char)"
            } else {
                newValue += (((i % length) == (length - 1)) ? "\(char)\(separator)" : "\(char)")
            }
        }
        return newValue
    }

    /// 截断字符串(将其剪切为给定数量的字符)
    ///
    ///     var str = "This is a very long sentence"
    ///     str.truncate(toLength:14)
    ///     print(str) // prints "This is a very..."
    /// - Parameters:
    ///   - toLength:切割前的最大字符数(从字符开头要保留的字符数量)
    ///   - trailing:要添加到截断字符串末尾的字符串(默认为“...”)
    /// - Returns: `String`
    @discardableResult
    func truncate(toLength length: Int, trailing: String? = "...") -> String {
        guard length > 0 else { return self }
        if count > length {
            return self[startIndex ..< index(startIndex, offsetBy: length)] + (trailing ?? "")
        }
        return self
    }

    /// 分割字符串
    /// - Parameter delimiter:分割根据
    /// - Returns:分割结果数组
    /// - Returns: `String`
    func split(with char: String) -> [String] {
        let components = components(separatedBy: char)
        return components != [""] ? components : []
    }

    /// 在开始时用另一个字符串填充字符串以适应长度参数大小
    ///
    ///     "hue".padStart(10) -> "       hue"
    ///     "hue".padStart(10, with:"br") -> "brbrbrbhue"
    /// - Parameters:
    ///   - length:要填充的目标长度
    ///   - string:填充字符串. 默认为`“ ”`
    /// - Returns: `String`
    @discardableResult
    func padStart(_ length: Int, with string: String = " ") -> String {
        paddingStart(length, with: string)
    }

    /// 在开始时用另一个字符串填充字符串以适应长度参数大小
    ///
    ///     "hue".padEnd(10) -> "hue       "
    ///     "hue".padEnd(10, with:"br") -> "huebrbrbrb"
    /// - Parameters:
    ///   - length:要填充的目标长度
    ///   - string:填充字符串. 默认为`“ ”`
    /// - Returns: `String`
    @discardableResult
    func padEnd(_ length: Int, with string: String = " ") -> String {
        paddingEnd(length, with: string)
    }

    /// 通过填充返回一个字符串,以适应长度参数大小,并在开始时使用另一个字符串
    ///
    ///     "hue".paddingStart(10) -> "       hue"
    ///     "hue".paddingStart(10, with:"br") -> "brbrbrbhue"
    /// - Parameters:
    ///   - length:要填充的目标长度
    ///   - string:填充字符串. 默认为`“ ”`
    /// - Returns: `String`
    func paddingStart(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex ..< string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex ..< padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }

    /// 通过填充返回一个字符串,以使长度参数大小与最后的另一个字符串相匹配
    ///
    ///     "hue".paddingEnd(10) -> "hue       "
    ///     "hue".paddingEnd(10, with:"br") -> "huebrbrbrb"
    /// - Parameters:
    ///   - length:要填充的目标长度
    ///   - string:填充字符串. 默认为`“ ”`
    /// - Returns:末尾有填充的字符串
    func paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex ..< string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength { padding.append(string) }
            return self + padding[padding.startIndex ..< padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }

    /// 在指定`searchRange`中使用`template`替换与`regex`匹配的内容
    /// - Parameters:
    ///   - regex:进行替换的正则表达式
    ///   - template:替换正则表达式的模板
    ///   - options:要使用的匹配选项
    ///   - searchRange:要搜索的范围
    /// - Returns:一个新字符串,其中接收者的 `searchRange` 中所有出现的正则表达式都被模板替换
    func replacingOccurrences(of regex: NSRegularExpression,
                              with template: String,
                              options: NSRegularExpression.MatchingOptions = [],
                              range searchRange: Range<String.Index>? = nil) -> String
    {
        let range = NSRange(searchRange ?? startIndex ..< endIndex, in: self)
        return regex.stringByReplacingMatches(in: self, options: options, range: range, withTemplate: template)
    }

    /// 使用正则表达式替换
    /// - Parameters:
    ///   - pattern:正则
    ///   - with:用来替换的字符串
    ///   - options:选项
    /// - Returns:返回替换后的字符串
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String
    {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSRange(location: 0, length: count),
                                              withTemplate: with)
    }

    /// 从字符串中删除指定的前缀
    ///
    ///     "Hello, World!".removingPrefix("Hello, ") -> "World!"
    /// - Parameters prefix:要从字符串中删除的前缀
    /// - Returns:去除前缀后的字符串
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    /// 从字符串中删除给定的后缀
    ///
    ///     "Hello, World!".removingSuffix(", World!") -> "Hello"
    /// - Parameters suffix:要从字符串中删除的后缀
    /// - Returns:删除后缀后的字符串
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// 为字符串添加前缀
    ///
    ///     "www.apple.com".withPrefix("https://") -> "https://www.apple.com"
    /// - Parameters prefix:添加到字符串的前缀
    /// - Returns:带有前缀的字符串
    func withPrefix(_ prefix: String) -> String {
        guard !hasPrefix(prefix) else { return self }
        return prefix + self
    }

    /// 在任意位置插入字符串
    /// - Parameters:
    ///   - content:插入内容
    ///   - locat:插入的位置
    /// - Returns:添加后的字符串
    func insertString(content: String, locat: Int) -> String {
        guard locat < count else {
            return self
        }
        let str1 = subString(to: locat)
        let str2 = subString(from: locat + 1)
        return str1 + content + str2
    }

    /// 替换字符串
    /// - Parameters:
    ///   - string:要替换的字符串
    ///   - withString:要替换成的字符串
    /// - Returns:替换完成的字符串
    func replace(_ string: String, with withString: String) -> String {
        replacingOccurrences(of: string, with: withString)
    }

    /// 隐藏敏感信息
    ///
    ///     "012345678912".HideSensitiveContent(range:3..<8, replace:"*****") -> "012*****912"
    /// - Parameters:
    ///   - range:要隐藏的内容范围
    ///   - replace:用来替换敏感内容的字符串
    /// - Returns:隐藏敏感信息后的字符串
    func hideSensitiveContent(range: Range<Int>, replace: String = "****") -> String {
        if count < range.upperBound {
            return self
        }
        guard let subStr = self[safe: range] else {
            return self
        }
        return self.replace(subStr, with: replace)
    }

    /// 生成指定数量的重复字符串
    /// - Parameter count:要重复的字符串个数
    /// - Returns:拼接后的字符串
    func `repeat`(_ count: Int) -> String {
        String(repeating: self, count: count)
    }

    /// 移除`self`中指定字符串,并用指定字符串来进行替换
    /// - Parameters:
    ///   - removeString:要移除的字符串
    ///   - replacingString:替换的字符串
    /// - Returns:替换后的整体字符串
    func removeSomeStringUseSomeString(removeString: String, replacingString: String = "") -> String {
        replacingOccurrences(of: removeString, with: replacingString)
    }

    /// 删除指定的字符
    /// - Parameter characterString:指定的字符
    /// - Returns:返回删除后的字符
    func removeCharacter(characterString: String) -> String {
        let characterSet = CharacterSet(charactersIn: characterString)
        return trimmingCharacters(in: characterSet)
    }

    /// 获取最长相同后缀
    /// - Parameters:
    ///   - aString:用于与`self`比较的对象
    ///   - options:选项
    /// - Returns:最长相同后缀
    func commonSuffix(with aString: String, options: CompareOptions = []) -> String {
        String(zip(reversed(), aString.reversed())
            .lazy
            .prefix(while: { (lhs: Character, rhs: Character) in
                String(lhs).compare(String(rhs), options: options) == .orderedSame
            })
            .map { (lhs: Character, _: Character) in lhs }
            .reversed())
    }
}

// MARK: - 运算符
public extension String {
    /// 重载 `Swift` 的`包含运算符`以匹配正则表达式模式
    /// - Parameters:
    ///   - lhs:检查正则表达式模式的字符串
    ///   - rhs:要匹配的正则表达式模式
    /// - Returns:如果字符串与模式匹配,则返回 true
    static func ~= (lhs: String, rhs: String) -> Bool {
        lhs.range(of: rhs, options: .regularExpression) != nil
    }

    /// 重载 `Swift` 的`包含运算符`以匹配正则表达式
    /// - Parameters:
    ///   - lhs:检查正则表达式的字符串
    ///   - rhs:要匹配的正则表达式
    /// - Returns:如果字符串中的正则表达式至少有一个匹配项,则返回:`true`
    static func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
        let range = NSRange(lhs.startIndex ..< lhs.endIndex, in: lhs)
        return rhs.firstMatch(in: lhs, range: range) != nil
    }

    /// 生成重复字符串
    ///
    ///     'bar' * 3 -> "barbarbar"
    /// - Parameters:
    ///   - lhs:要重复的字符串
    ///   - rhs:重复字符串的次数
    /// - Returns:给定字符串重复 n 次的新字符串
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    /// 生成重复字符串
    ///
    ///     3 * 'bar' -> "barbarbar"
    /// - Parameters:
    ///   - lhs:重复字符的次数
    ///   - rhs:要重复的字符串
    /// - Returns:给定字符串重复 n 次的新字符串
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
}

// MARK: - Defaultable
extension String: Defaultable {}
public extension String {
    typealias Associatedtype = String
    static func `default`() -> Associatedtype {
        String()
    }
}

// MARK: - 链式语法
public extension String {}
