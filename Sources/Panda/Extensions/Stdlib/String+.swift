//
//  String+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import CoreGraphics
import CoreLocation
import UIKit

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
        let trimmed = trimmed().lowercased()
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

// MARK: - 方法
public extension String {
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
