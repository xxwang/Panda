import CoreGraphics
import CoreLocation
import UIKit

// MARK: - 属性
public extension String {
    /// 返回一个本地化的字符串
    /// - Returns: `String`
    var pd_localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

// MARK: - 构造方法
public extension String {
    /// 从`base64`字符串创建一个新字符串(`base64`解码)
    ///
    ///     String(base64:"SGVsbG8gV29ybGQh") = "Hello World!"
    ///     String(base64:"hello") = nil
    ///
    /// - Parameters base64:`base64`字符串
    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
}

// MARK: - 下标
public extension String {
    /// 获取/替换字符串中的某个字符
    ///
    ///     "Hello World!"[safe:3] -> "l"
    ///     "Hello World!"[safe:20] -> nil
    ///
    /// - Note: 不存在返回`nil`
    /// - Parameter index: 字符所在下标
    /// - Returns: `String?`
    subscript(safe index: Int) -> String? {
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

    /// 在给定范围内安全地获取/替换字符串
    ///
    ///     "Hello World!"[safe:6..<11] -> "World"
    ///     "Hello World!"[safe:21..<110] -> nil
    ///
    ///     "Hello World!"[safe:6...11] -> "World!"
    ///     "Hello World!"[safe:21...110] -> nil
    ///
    /// - Parameter range: 要操作的字符串范围
    /// - Returns: 结果字符串
    subscript<R>(safe range: R) -> String? where R: RangeExpression, R.Bound == Int {
        get {
            let range = range.relative(to: Int.min ..< Int.max)
            let startIndex = index(startIndex, offsetBy: range.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: range.upperBound)
            return String(self[startIndex ..< endIndex])
        }
        set {
            let range = range.relative(to: Int.min ..< Int.max)
            let startIndex = index(startIndex, offsetBy: range.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: range.upperBound)
            self.replaceSubrange(startIndex ..< endIndex, with: newValue ?? "")
        }
    }

    /// 获取字符串指定`NSRange`的子字符串
    ///
    /// - Note: 范围的边界必须是集合的有效索引
    /// - Parameter nsRange: 子字符串的范围
    /// - Returns: 结果子字符串
    subscript(nsRange: NSRange) -> Substring {
        guard let range = Range(nsRange, in: self) else { fatalError("Failed to find range \(nsRange) in \(self)") }
        return self[range]
    }
}

// MARK: - 类型转换
public extension String {
    /// 转换为`Int`
    /// - Returns: `Int`结果
    func pd_int() -> Int {
        return Int(self) ?? 0
    }

    /// 转换为`Int64`
    /// - Returns: `Int64`结果
    func pd_int64() -> Int64 {
        Int64(self) ?? 0
    }

    /// 转换为`UInt`
    /// - Returns: `UInt`结果
    func pd_uInt() -> UInt {
        return UInt(self) ?? 0
    }

    /// 转换为`UInt64`
    /// - Returns: `UInt64`结果
    func pd_uInt64() -> UInt64 {
        return UInt64(self) ?? 0
    }

    /// 转换为`Float`
    /// - Returns: `Float`结果
    func pd_float() -> Float {
        return Float(self) ?? 0
    }

    /// 转换为`Double`
    /// - Returns: `Double`结果
    func pd_double() -> Double {
        return Double(self) ?? 0
    }

    /// 转换为`CGFloat`
    /// - Returns: `CGFloat`结果
    func pd_cgFloat() -> CGFloat {
        CGFloat(pd_double())
    }

    /// 转换为`NSNumber`
    /// - Returns: `NSNumber`结果
    func pd_nsNumber() -> NSNumber {
        NSNumber(value: pd_double())
    }

    /// 转换为`Bool`
    /// - Returns: `Bool`结果
    func pd_bool() -> Bool {
        let trimmed = pd_trim().lowercased()
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    /// 转换为`Character?`
    /// - Returns: `Character?`结果
    func pd_character() -> Character? {
        guard let n = Int(self), let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    /// 转换为`[Character]`
    /// - Returns: `[Character]`结果
    func pd_characters() -> [Character] {
        return Array(self)
    }

    /// 转换为`NSString`
    /// - Returns: `NSString`结果
    func pd_nsString() -> NSString {
        return NSString(string: self)
    }

    /// 转换为`16进制Int`
    /// - Returns: `Int`结果
    func pd_hexInt() -> Int {
        return Int(self, radix: 16) ?? 0
    }

    /// 转`utf8`格式`Data`
    /// - Returns: `Data?`
    func pd_data() -> Data? {
        return data(using: .utf8)
    }

    /// `16进制颜色值`字符串转`UIColor`对象
    /// - Returns: `UIColor`
    func pd_hexColor() -> UIColor {
        return UIColor(hex: self)
    }

    /// 图片资源名称转图片对象
    /// - Returns: `UIImage?`
    func pd_image() -> UIImage? {
        return UIImage(named: self)
    }

    /// 把字符串转为`URL`(失败返回`nil`)
    /// - Returns: `URL?`
    func pd_url() -> URL? {
        if hasPrefix("http://") || hasPrefix("https://") {
            return URL(string: self)
        }
        return URL(fileURLWithPath: self)
    }

    /// 字符串转`URLRequest`
    /// - Returns: `URLRequest?`
    func pd_urlRequest() -> URLRequest? {
        guard let url = pd_url() else {
            return nil
        }
        return URLRequest(url: url)
    }

    ///  字符串转`通知名称`
    /// - Returns: `Notification.Name`
    func pd_notificationName() -> Notification.Name {
        return Notification.Name(self)
    }

    /// 字符串转属性字符串
    /// - Returns: `NSAttributedString`
    func pd_nsAttributedString() -> NSAttributedString {
        return NSAttributedString(string: self)
    }

    /// 字符串转可变属性字符串
    /// - Returns: `NSMutableAttributedString`
    func pd_nsMutableAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}

// MARK: - 类/实例
public extension String {
    /// `类名字符串`转指定类,类型默认:`AnyClass`
    /// - Parameter name: 目标类
    /// - Returns: `T.Type`
    func pd_classNameToClass<T>(for name: T.Type = AnyClass.self) -> T.Type? {
        guard let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else { return nil }
        let classNameString = "\(namespace.pd_replace(" ", with: "_")).\(self)"
        guard let nameClass = NSClassFromString(classNameString) as? T.Type else { return nil }
        return nameClass
    }

    /// `类名字符串`转`类对象`
    ///
    /// - Note: 类需要是继承自`NSObject`
    /// - Parameter name: 目标类
    /// - Returns: 类对象
    func pd_classNameToInstance<T>(for name: T.Type = NSObject.self) -> T? where T: NSObject {
        guard let nameClass = pd_classNameToClass(for: name) else {
            return nil
        }
        let object = nameClass.init()
        return object
    }
}

// MARK: - Range
public extension String {
    /// 字符串的完整 `Range`
    /// - Returns: `Range<String.Index>?`
    func pd_fullRange() -> Range<String.Index>? {
        return startIndex ..< endIndex
    }

    /// 将 `NSRange` 转换为 `Range<String.Index>`
    /// - Parameter nsRange: 要转换的`NSRange`
    /// - Returns: 等价`NSRange`的`Range<String.Index>`
    func pd_range(_ nsRange: NSRange) -> Range<String.Index> {
        guard let range = Range(nsRange, in: self) else { fatalError("Failed to find range \(nsRange) in \(self)") }
        return range
    }

    /// 获取`subString`在当前字符串中的`Range`
    /// - Parameter subString: 用于查找的字符串
    /// - Returns: 结果`Range<String.Index>?`
    func pd_range(_ subString: String) -> Range<String.Index>? {
        range(of: subString)
    }
}

// MARK: - NSRange
public extension String {
    /// 字符串的完整 `NSRange`
    /// - Returns: `NSRange`
    func pd_fullNSRange() -> NSRange {
        return NSRange(startIndex ..< endIndex, in: self)
    }

    /// 将`Range<String.Index>`转换为`NSRange`
    /// - Parameter range: 要转换的`Range<String.Index>`
    /// - Returns: 在字符串中找到的 `Range` 的等效 `NSRange`
    func pd_nsRange(_ range: Range<String.Index>) -> NSRange {
        NSRange(range, in: self)
    }

    /// 获取`subStr`在字符串中的`NSRange`
    /// - Parameter subStr: 用于查找的字符串
    /// - Returns: 结果`NSRange`
    func pd_nsRange(_ subStr: String) -> NSRange {
        guard let range = range(of: subStr) else {
            return NSRange(location: 0, length: 0)
        }
        return NSRange(range, in: self)
    }
}

// MARK: - 静态方法
public extension String {
    /// 指定长度的`乱数假文`字符串
    /// - Parameter length: 限制`乱数假文`字符数(默认为` 445 - 完整`的`乱数假文`)
    /// - Returns: `乱数假文`字符串
    static func pd_loremIpsum(of length: Int = 445) -> String {
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

    /// 指定长度的随机字符串
    ///
    ///     String.pd_random(ofLength:18) -> "u7MMZYvGo9obcOcPj8"
    ///
    /// - Parameter length: 字符个数
    /// - Returns: 结果字符串
    static func pd_random(of length: Int) -> String {
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
    /// `subStr`在字符串中第一次出现的位置
    ///
    /// - Note: 不存在返回`-1`
    /// - Parameter subStr: 要查询的字符串
    /// - Returns: 结果位置
    func pd_positionFirst(of subStr: String) -> Int {
        return pd_position(of: subStr)
    }

    /// `subStr`在字符串中最后一次出现的位置
    ///
    /// - Note: 不存在返回`-1`
    /// - Parameter subStr: 要查询的字符串
    /// - Returns: 结果位置
    func pd_positionLast(of subStr: String) -> Int {
        return pd_position(of: subStr, backwards: true)
    }

    /// 根据`backwards`返回`subStr`在字符串中的位置
    ///
    /// - Note: 不存在返回`-1`
    /// - Parameters:
    ///   - subStr: 要查询的字符串
    ///   - backwards: 如果`backwards`参数设置为`true`,则返回最后一次出现的位置
    /// - Returns: 结果位置
    func pd_position(of subStr: String, backwards: Bool = false) -> Int {
        var pos = -1
        if let range = range(of: subStr, options: backwards ? .backwards : .literal) {
            if !range.isEmpty { pos = distance(from: startIndex, to: range.lowerBound) }
        }
        return pos
    }
}

// MARK: - 字符串截取
public extension String {
    /// 获取某个位置的字符串
    /// - Parameter index: 位置
    /// - Returns: `String`
    func pd_indexString(index: Int) -> String {
        return self.pd_slice(index ..< index + 1)
    }

    /// 切割字符串(区间范围,前闭后开)
    ///
    ///     CountableClosedRange:可数的闭区间,如 0...2
    ///     CountableRange:可数的开区间,如 0..<2
    ///     ClosedRange:不可数的闭区间,如 0.1...2.1
    ///     Range:不可数的开居间,如 0.1..<2.1
    ///
    /// - Parameter range: 范围
    /// - Returns: 结果字符串
    func pd_slice(_ range: CountableRange<Int>) -> String {
        let startIndex = pd_validIndex(original: range.lowerBound)
        let endIndex = pd_validIndex(original: range.upperBound)
        guard startIndex < endIndex else {
            return ""
        }
        return String(self[startIndex ..< endIndex])
    }

    /// 截取子字符串(从`from`开始到`字符串结尾`)
    /// - Parameter from: 开始位置
    /// - Returns: 结果字符串
    func pd_subString(from: Int) -> String {
        let end = count
        return self[safe: from ..< end] ?? ""
    }

    /// 截取子字符串(从`开头`到`to`)
    /// - Parameter to: 停止位置
    /// - Returns: 结果字符串
    func pd_subString(to: Int) -> String {
        return self[safe: 0 ..< to] ?? ""
    }

    /// 截取子字符串(从`from`开始截取`length`个字符)
    /// - Parameters:
    ///   - from: 开始截取位置
    ///   - length: 长度
    /// - Returns: 结果字符串
    func pd_subString(from: Int, length: Int) -> String {
        let end = from + length
        return self[safe: from ..< end] ?? ""
    }

    /// 截取子字符串(从`from`开始截取到`to`)
    /// - Parameters:
    ///   - from: 开始位置
    ///   - to: 结束位置
    /// - Returns: 结果字符串
    func pd_subString(from: Int, to: Int) -> String {
        return self[safe: from ..< to] ?? ""
    }

    /// 根据`NSRange`截取子字符串
    /// - Parameter range:`NSRange`
    /// - Returns: 结果字符串
    func pd_subString(range: NSRange) -> String {
        return self.pd_nsString().substring(with: range)
    }

    /// 根据`Range`截取子字符串
    /// - Parameter range:`Range<Int>`
    /// - Returns: 结果字符串
    func pd_subString(range: Range<Int>) -> String {
        return self[safe: range] ?? ""
    }

    /// 根据`Range`截取子字符串
    /// - Parameter range: `Range<String.Index>`
    /// - Returns: 结果字符串
    func pd_subString(range: Range<String.Index>) -> String {
        let subString = self[range]
        return String(subString)
    }

    /// 截断字符串
    ///
    ///     "This is a very long sentence".pd_truncate(len:14) -> "This is a very"
    ///
    /// - Note: 保留指定长度
    /// - Parameter len: 保留长度
    /// - Returns: 结果字符串
    func pd_truncate(len: Int) -> String {
        if self.count > len {
            return self.pd_subString(to: len)
        }
        return self
    }

    /// 截断字符串, 并添加尾巴
    ///
    ///     "This is a very long sentence".pd_truncate(length:14) -> "This is a very..."
    ///     "Short sentence".pd_truncate(length:14) -> "Short sentence"
    ///
    /// - Note: 只有字符串长度大于保留长度,才会发生截断
    /// - Parameters:
    ///   - length: 保留长度
    ///   - trailing: 尾巴
    /// - Returns: 结果字符串
    func pd_truncate(length: Int, trailing: String? = "...") -> String {
        guard 0 ..< count ~= length else { return self }
        return self[startIndex ..< index(startIndex, offsetBy: length)] + (trailing ?? "")
    }

    /// 截断字符串,并添加分割符
    /// - Parameters:
    ///   - length: 截断长度
    ///   - separator: 分隔符
    /// - Returns: 结果字符串
    func pd_truncate(_ length: Int, separator: String = "-") -> String {
        var newValue = ""
        for (i, char) in self.enumerated() {
            if i > (count - length) {
                newValue += "\(char)"
            } else {
                newValue += (((i % length) == (length - 1)) ? "\(char)\(separator)" : "\(char)")
            }
        }
        return newValue
    }
}

// MARK: - 判断
public extension String {
    /// 检查字符串是否包含字母
    ///
    ///     "123abc".pd_hasLetters -> true
    ///     "123".pd_hasLetters -> false
    ///
    /// - Returns: 是否包含
    func pd_hasLetters() -> Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    /// 检查字符串是否只包含字母
    ///
    ///     "abc".pd_isAlphabetic -> true
    ///     "123abc".pd_isAlphabetic -> false
    ///
    /// - Returns: 是否包含
    func pd_isAlphabetic() -> Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    /// 检查字符串是否包含数字
    ///
    ///     "abcd".pd_hasNumbers -> false
    ///     "123abc".pd_hasNumbers -> true
    ///
    /// - Returns: 是否包含
    func pd_hasNumbers() -> Bool {
        rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    /// 检查字符串是否同时包含字母数字
    ///
    ///     "123abc".pd_isAlphaNumeric -> true
    ///     "abc".pd_isAlphaNumeric -> false
    ///
    /// - Returns: 是否包含
    func pd_isAlphaNumeric() -> Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }

    /// 检查字符串是否为有效的`Swift`数字
    ///
    ///     "123".pd_isSwiftNumeric -> true
    ///     "1.3".pd_isSwiftNumeric -> true (en_US)
    ///     "1,3".pd_isSwiftNumeric -> true (fr_FR)
    ///     "abc".pd_isSwiftNumeric -> false
    ///
    /// - Returns: 是否是有效的`Swift`数字
    func pd_isSwiftNumeric() -> Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        if #available(iOS 13.0, *) {
            return scanner.scanDecimal() != nil && scanner.isAtEnd
        } else {
            return scanner.scanDecimal(nil) && scanner.isAtEnd
        }
    }

    /// 判断是否是整数
    /// - Returns: 是否是整数
    func pd_isPureInt() -> Bool {
        let scan = Scanner(string: self)
        if #available(iOS 13.0, *) {
            return (scan.scanInt() != nil) && scan.isAtEnd
        } else {
            return scan.scanInt(nil) && scan.isAtEnd
        }
    }

    /// 检查字符串是否只包含数字
    ///
    ///     "123".pd_isDigits -> true
    ///     "1.3".pd_isDigits -> false
    ///     "abc".pd_isDigits -> false
    ///
    /// - Returns: 是否只包含数字
    func pd_isDigits() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    /// 检查给定的字符串是否只包含空格
    /// - Returns: 是否只包含空格
    func pd_isWhitespace() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 检查给定的字符串是否拼写正确
    /// - Returns: `Bool`
    func pd_isSpelledCorrectly() -> Bool {
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

    /// 检查字符串是否为回文字符串
    ///
    ///     "abcdcba".pd_isPalindrome -> true
    ///     "Mom".pd_isPalindrome -> true
    ///     "A man a plan a canal, Panama!".pd_isPalindrome -> true
    ///     "Mama".pd_isPalindrome -> false
    ///
    /// - Returns: 是否为回文字符串
    func pd_isPalindrome() -> Bool {
        let letters = filter(\.isLetter)
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex ..< midIndex]
        let secondHalf = letters[midIndex ..< letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }

    /// 检查字符串是否只包含唯一字符(没有重复字符)
    /// - Returns: 是否只包含唯一字符
    func pd_hasUniqueCharacters() -> Bool {
        guard count > 0 else { return false }
        var uniqueChars = Set<String>()
        for char in self {
            if uniqueChars.contains(String(char)) { return false }
            uniqueChars.insert(String(char))
        }
        return true
    }

    /// 判断是不是九宫格键盘
    /// - Returns: 是不是九宫格键盘
    func pd_isNineKeyBoard() -> Bool {
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
    /// - Returns: 是否符合正则
    func pd_isTelNumber() -> Bool {
        let pattern = "^1[3456789]\\d{9}$"
        return pd_regexp(pattern)
    }

    /// 是否是字母数字(指定范围)
    /// - Parameters:
    ///   - minLen: 最小长度
    ///   - maxLen: 最大长度
    /// - Returns: 是否符合正则
    func pd_isAlphanueric(minLen: Int, maxLen: Int) -> Bool {
        let pattern = "^[0-9a-zA-Z_]{\(minLen),\(maxLen)}$"
        return pd_regexp(pattern)
    }

    /// 是否是字母与数字
    /// - Returns: 是否符合正则
    func pd_isAlphanueric() -> Bool {
        let pattern = "^[A-Za-z0-9]+$"
        return pd_isMatchRegexp(pattern)
    }

    /// 是否是纯汉字
    /// - Returns: 是否符合正则
    func pd_isChinese() -> Bool {
        let pattern = "(^[\u{4e00}-\u{9fef}]+$)"
        return pd_regexp(pattern)
    }

    /// 检查字符串是否为有效的电子邮件格式
    /// - Returns: 是否符合正则
    func pd_isEmail1() -> Bool {
        //     let pattern = "^([a-z0-9A-Z]+[-_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$"
        let pattern = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?"
        return pd_regexp(pattern)
    }

    /// 检查字符串是否为有效的电子邮件格式
    ///
    ///     "john@doe.com".pd_isEmai2 -> true
    ///
    /// - Note: 请注意,此属性不会针对电子邮件服务器验证电子邮件地址.
    ///         它只是试图确定其格式是否适合电子邮件地址
    /// - Returns: 是否符合正则
    func pd_isEmai2() -> Bool {
        // http://emailregex.com/
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 是否是有效昵称,即允许`中文`、`英文`、`数字`
    /// - Returns: 是否符合正则
    func pd_isNickName() -> Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        return pd_regexp(rgex)
    }

    /// 字符串是否为合法用户名
    /// - Returns: 是否符合正则
    func pd_validateUserName() -> Bool {
        let rgex = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        return pd_regexp(rgex)
    }

    /// 设置密码必须符合由`数字`、`大写字母`、`小写字母`、`特殊符`
    /// - Parameter complex: 是否复杂密码 至少其中(两种/三种)组成密码
    /// - Returns: 是否符合正则
    func pd_password(_ complex: Bool = false) -> Bool {
        var pattern = "^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{8,20}$"
        if complex {
            pattern = "^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\\W_]+$)(?![a-z0-9]+$)(?![a-z\\W_]+$)(?![0-9\\W_]+$)[a-zA-Z0-9\\W_]{8,20}$"
        }
        return pd_regexp(pattern)
    }

    /// 是否为`0-9`之间的数字(字符串的组成是:`0-9`之间的`数字`)
    /// - Returns: 是否符合正则
    func pd_isNumberValue() -> Bool {
        guard !isEmpty else {
            return false
        }
        let rgex = "^[\\d]*$"
        return pd_regexp(rgex)
    }

    /// 是否为`数字`或者`小数点`(字符串的组成是:`0-9之间`的`数字`或者`小数点`即可)
    /// - Returns: 是否符合正则
    func pd_isValidNumberAndDecimalPoint() -> Bool {
        guard !isEmpty else {
            return false
        }
        let rgex = "^[\\d.]*$"
        return pd_regexp(rgex)
    }

    /// 正则匹配用户身份证号15或18位
    /// - Returns: 是否符合正则
    func pd_isIDNumber() -> Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
        return pd_regexp(pattern)
    }

    /// 严格判断是否有效的身份证号码,检验了省份,生日,校验位,不过没检查市县的编码
    var isValidIDNumber: Bool {
        let str = trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let len = str.count
        if !str.pd_isIDNumber() {
            return false
        }
        // 省份代码
        let areaArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        if !areaArray.contains(str.pd_subString(to: 2)) {
            return false
        }
        var regex = NSRegularExpression()
        var numberOfMatch = 0
        var year = 0
        switch len {
        case 15:
            // 15位身份证
            // 这里年份只有两位,00被处理为闰年了,对2000年是正确的,对1900年是错误的,不过身份证是1900年的应该很少了
            year = Int(str.pd_subString(from: 6, length: 2))!
            if pd_isLeapYear(year: year) { // 闰年
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
            year = Int(str.pd_subString(from: 6, length: 4))!
            if pd_isLeapYear(year: year) {
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
                    if let d = Int(str.pd_slice(i ..< (i + 1))) {
                        s += d * jiaoYan[i % 10]
                    } else {
                        return false
                    }
                }
                let Y = s % 11
                let JYM = "10X98765432"
                let M = JYM.pd_subString(from: Y, length: 1)
                if M == str.pd_subString(from: 17, length: 1) {
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
    /// - Parameter year: 年份
    /// - Returns: 是否是闰年
    private func pd_isLeapYear(year: Int) -> Bool {
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

    /// 检查字符串是否是有效的`URL`
    ///
    ///     "https://google.com".pd_isValidUrl -> true
    ///
    /// - Returns: 是否是有效的`URL`
    func pd_isValidUrl() -> Bool {
        return URL(string: self) != nil
    }

    /// 检查字符串是否是有效带协议头的`URL`
    ///
    ///     "https://google.com".pd_isValidSchemedUrl -> true
    ///     "google.com".pd_isValidSchemedUrl -> false
    ///
    /// - Returns: 是否符合
    func pd_isValidSchemedUrl() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// 检查字符串是否是有效的`https URL`
    ///
    ///     "https://google.com".pd_isValidHttpsUrl -> true
    ///
    /// - Returns: `Bool`
    func pd_isValidHttpsUrl() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }

    /// 检查字符串是否是有效的`http URL`
    ///
    ///     "http://google.com".pd_isValidHttpUrl -> true
    ///
    /// - Returns: `Bool`
    func pd_isValidHttpUrl() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }

    /// 检查字符串是否是有效的文件URL
    ///
    ///     "file://Documents/file.txt".pd_isValidFileUrl -> true
    ///
    /// - Returns: `Bool`
    func pd_isValidFileUrl() -> Bool {
        URL(string: self)?.isFileURL ?? false
    }

    /// 判断是否包含某个字符串`区分大小写`
    /// - Parameter find: 用于查询的字符串
    /// - Returns: 是否包含
    func pd_contains(find: String) -> Bool {
        self.pd_contains(find, caseSensitive: true)
    }

    /// 检查字符串是否包含`string`
    ///
    ///     "Hello World!".pd_contains("O") -> false
    ///     "Hello World!".pd_contains("o", caseSensitive:false) -> true
    ///
    /// - Parameters:
    ///   - string: 用于查询的字符串
    ///   - caseSensitive: 是否区分大小写
    /// - Returns: 是否包含
    func pd_contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }

    ///  判断是否包含`find` `忽略大小写`
    /// - Parameter find: 用于查询的字符串
    /// - Returns: 是否包含
    func pd_containsIgnoringCase(find: String) -> Bool {
        return pd_contains(find, caseSensitive: false)
    }

    /// 检查字符串是否以`prefix`开头
    ///
    ///     "hello World".pd_starts(with:"h") -> true
    ///     "hello World".pd_starts(with:"H", caseSensitive:false) -> true
    ///
    /// - Parameters:
    ///   - prefix: 用于查询的字符串
    ///   - caseSensitive: 是否区分大小写
    /// - Returns: 是否符合
    func pd_starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }

    /// 检查字符串是否以`suffix`结尾
    ///
    ///     "Hello World!".pd_ends(with:"!") -> true
    ///     "Hello World!".pd_ends(with:"WoRld!", caseSensitive:false) -> true
    ///
    /// - Parameters:
    ///   - suffix: 用于查询的字符串
    ///   - caseSensitive: 是否区分大小写
    /// - Returns: 是否符合
    func pd_ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
}

// MARK: - 正则相关运算符
infix operator =~: RegPrecedence
precedencegroup RegPrecedence {
    associativity: none
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

public extension String {
    /// 正则匹配操作符
    /// - Parameters:
    ///   - lhs: 左值
    ///   - rhs: 右值
    /// - Returns: 是否匹配
    static func =~ (lhs: String, rhs: String) -> Bool {
        lhs.pd_regexp(rhs)
    }
}

// MARK: - 正则
public extension String {
    /// 为正则表达式加上`"\"`进行保护,将元字符转化成字面值
    ///
    ///     "hello ^$ there" -> "hello \\^\\$ there"
    ///
    /// - Returns: 结果字符串
    func pd_regexEscaped() -> String {
        return NSRegularExpression.escapedPattern(for: self)
    }

    /// 验证`字符串`是否匹配`正则表达式`
    /// - Parameter pattern: 正则表达式
    /// - Returns: 是否符合
    func pd_matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }

    /// 验证`字符串`是否与`正则表达式`匹配
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配选项
    /// - Returns: 是否符合
    func pd_matches(regex: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        let range = NSRange(startIndex ..< endIndex, in: self)
        return regex.firstMatch(in: self, options: options, range: range) != nil
    }

    /// 验证`字符串`是否与`正则表达式`匹配
    /// - Parameter pattern: 正则表达式
    /// - Returns: 是否符合
    func pd_regexp(_ pattern: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }

    /// 是否有与`正则表达式`匹配的项
    /// - Parameter pattern: 正则表达式
    /// - Returns: 是否符合
    func pd_isMatchRegexp(_ pattern: String) -> Bool {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        let result = regx.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: utf16.count))
        return !result.isEmpty
    }

    /// 获取符合`正则表达式`的结果
    /// - Parameters:
    ///   - pattern: 正则表达式
    ///   - count: 匹配次数
    /// - Returns: 结果数组
    func pd_regexpText(_ pattern: String, count: Int = 1) -> [String]? {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))
        else { return nil }
        var texts = [String]()
        for idx in 1 ... count {
            let text = pd_nsString().substring(with: result.range(at: idx))
            texts.append(text)
        }
        return texts
    }

    /// 获取匹配项的`NSRange`
    /// - Parameter pattern: 正则表达式
    /// - Returns: 匹配的`[NSRange]`结果
    func pd_matchRange(_ pattern: String) -> [NSRange] {
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
    /// - Returns: `HTML字符引用`
    func pd_stringAsHtmlCharacterEntityReferences() -> String {
        var result = ""
        for scalar in utf16 {
            // 将十进制转成十六进制,不足4位前面补0
            let tem = String().appendingFormat("%04x", scalar)
            result += "&#x\(tem);"
        }
        return result
    }

    /// `HTML字符引用`转`字符串`
    /// - Returns: 普通字符串
    func pd_htmlCharacterEntityReferencesAsString() -> String? {
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
    ///   - font: 字体
    ///   - lineSpacing: 行间距
    /// - Returns: 属性字符串
    func pd_htmlCodeToAttributedString(font: UIFont? = UIFont.systemFont(ofSize: 12),
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
        if let font { htmlString?.addAttributes([.font: font], range: pd_fullNSRange()) }

        // 设置行间距
        if let weakLineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle.default().pd_lineSpacing(weakLineSpacing)
            htmlString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: pd_fullNSRange())
        }
        return htmlString ?? pd_nsMutableAttributedString()
    }

    /// 高亮显示关键字(返回属性字符串)
    /// - Parameters:
    ///   - keyword: 要高亮的关键词
    ///   - keywordCololor: 关键高亮字颜色
    ///   - otherColor: 非高亮文字颜色
    ///   - options: 匹配选项
    /// - Returns: 返回匹配后的属性字符串
    func pd_highlightSubString(keyword: String,
                               keywordCololor: UIColor,
                               otherColor: UIColor,
                               options: NSRegularExpression.Options = []) -> NSMutableAttributedString
    {
        // 整体字符串
        let fullString = self
        // 整体属性字符串
        let attributedString = fullString.pd_nsMutableAttributedString().pd_addAttributes([
            NSAttributedString.Key.foregroundColor: otherColor,
        ])

        // 与关键词匹配的range数组
        let ranges = fullString.pd_matchRange(keyword)

        // 设置高亮颜色
        for range in ranges {
            attributedString.addAttributes([.foregroundColor: keywordCololor], range: range)
        }
        return attributedString
    }
}

// MARK: - URL编解码(属性)
public extension String {
    /// 转义字符串(`URL`编码)
    ///
    ///     var str = "it's easy to encode strings"
    ///     str.pd_urlEncode()
    ///     print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    /// - Returns: 编码后的字符串
    @discardableResult
    mutating func pd_urlEncode() -> String {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            self = encoded
        }
        return self
    }

    /// `URL`字符串转换为可读字符串(`URL`转义字符串解码)
    ///
    ///     var str = "it's%20easy%20to%20decode%20strings"
    ///     str.pd_urlDecode()
    ///     print(str) // prints "it's easy to decode strings"
    ///
    /// - Returns: 解码后的字符串
    @discardableResult
    mutating func pd_urlDecode() -> String {
        if let decoded = removingPercentEncoding { self = decoded }
        return self
    }
}

// MARK: - base64(属性)
public extension String {
    /// `base64`加密
    ///
    ///     "Hello World!".pd_base64Encoded() -> Optional("SGVsbG8gV29ybGQh")
    ///
    /// - Returns: base64加密结果
    func pd_base64Encoded() -> String? {
        let plainData = pd_data()
        return plainData?.base64EncodedString()
    }

    /// `base64`解密
    ///
    ///     "SGVsbG8gV29ybGQh".pd_base64Decoded() -> Optional("Hello World!")
    ///
    /// - Returns: base64解密结果
    func pd_base64Decoded() -> String? {
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
    /// - Returns: `unicode`编码后的字符串
    func pd_unicodeEncode() -> String {
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
    func pd_unicodeDecode() -> String {
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
    /// - Parameter format: 日期格式
    /// - Returns: Date?`
    func pd_date(with format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

// MARK: - 位置
public extension String {
    /// 地理编码(`地址转坐标`)
    /// - Parameter completionHandler: 回调函数
    func pd_locationEncode(completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().geocodeAddressString(self, completionHandler: completionHandler)
    }
}

// MARK: - URL
public extension String {
    /// 提取出字符串中所有的`URL`链接
    /// - Returns: `URL`链接数组
    func pd_urls() -> [String]? {
        var urls = [String]()
        // 创建一个正则表达式对象
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue)) else {
            return nil
        }

        // 匹配字符串,返回结果集
        let res = dataDetector.matches(in: self,
                                       options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                       range: NSRange(location: 0, length: count))

        // 取出结果
        for checkingRes in res {
            urls.append(pd_nsString().substring(with: checkingRes.range))
        }
        return urls
    }

    /// 截取参数列表
    /// - Returns: `URL`中的参数列表
    func pd_urlParamters() -> [String: Any] {
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
    /// 获取路径字符串中最后一个路径组件
    /// - Returns: 最后一个路径组件
    func pd_lastPathComponent() -> String {
        return self.pd_nsString().lastPathComponent
    }

    /// 获取路径字符串的扩展名
    /// - Returns: 扩展名
    func pd_pathExtension() -> String {
        return self.pd_nsString().pathExtension
    }

    /// 返回删除了最后一个路径组件之后的字符串
    /// - Returns: 结果字符串
    func pd_deletingLastPathComponent() -> String {
        return self.pd_nsString().deletingLastPathComponent
    }

    /// 返回删除了路径扩展之后的字符串
    /// - Returns: 结果字符串
    func pd_deletingPathExtension() -> String {
        return self.pd_nsString().deletingPathExtension
    }

    /// 获取路径组件数组
    /// - Returns: 路径组件数组
    func pd_pathComponents() -> [String] {
        return self.pd_nsString().pathComponents
    }

    /// 在路径字符串尾部添加路径组件
    ///
    /// - Note: 此方法仅适用于文件路径(例如,URL 的字符串表示形式
    /// - Parameter str: 要添加的路径组件(如果需要可以在前面添加分隔符`/`)
    /// - Returns: 新的路径字符串
    func pd_appendingPathComponent(_ str: String) -> String {
        return self.pd_nsString().appendingPathComponent(str)
    }

    /// 添加路径扩展
    /// - Parameter str: 要添加的扩展
    /// - Returns: 新的路径字符串
    func pd_appendingPathExtension(_ str: String) -> String? {
        return self.pd_nsString().appendingPathExtension(str)
    }
}

// MARK: - 沙盒路径
public extension String {
    /// 在`Support`目录后追加`目录/文件地址`
    ///
    /// - Note: `Support`备份在 iCloud
    /// - Returns: 拼接后的路径字符串
    func pd_appendBySupport() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        self.pd_createDirs(directory)
        return directory + "/\(self)"
    }

    /// 在`Documents`目录后追加`目录/文件地址`
    /// - Returns: 拼接后的路径字符串
    func pd_appendByDocument() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.pd_createDirs(directory)
        return directory + "/\(self)"
    }

    /// 在`Cachees`目录后追加`目录/文件地址`
    /// - Returns: 拼接后的路径字符串
    func pd_appendByCache() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        self.pd_createDirs(directory)
        return directory + "/\(self)"
    }

    /// 在`tmp`目录后追加`目录/文件地址`
    /// - Returns: 拼接后的路径字符串
    func pd_appendByTemp() -> String {
        let directory = NSTemporaryDirectory()
        self.pd_createDirs(directory)
        return directory + "/\(self)"
    }
}

// MARK: - 沙盒URL
public extension String {
    /// 在`Support`目录后追加`目录/文件地址`
    ///
    /// - Note: `Support`备份在 iCloud
    /// - Returns: 拼接后的路径`URL`
    func pd_urlBySupport() -> URL {
        _ = pd_appendByDocument()
        let fileUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }

    /// 在`Cachees`目录后追加`目录/文件地址`
    /// - Returns: 拼接后的路径`URL`
    func pd_urlByDocument() -> URL {
        _ = pd_appendByDocument()
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }

    /// 在`Cachees`目录后追加`目录/文件地址`
    /// - Returns: 拼接后的路径`URL`
    func pd_urlByCache() -> URL {
        _ = pd_appendByCache()
        let fileUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }
}

// MARK: - 文件操作
public extension String {
    /// 删除文件
    func pd_removeFile() {
        if FileManager.default.fileExists(atPath: self) {
            do {
                try FileManager.default.removeItem(atPath: self)
            } catch {
                debugPrint("文件删除失败!")
            }
        }
    }

    /// 创建目录/文件
    ///
    /// - Note: 以`/`结束代表是`目录`, 如 `cache/`
    /// - Parameter directory: 路径
    func pd_createDirs(_ directory: String = NSHomeDirectory()) {
        let path = contains(NSHomeDirectory()) ? self : "\(directory)/\(self)"
        let dirs = path.components(separatedBy: "/")
        let dir = dirs[0 ..< dirs.count - 1].joined(separator: "/")
        if !FileManager.default.fileExists(atPath: dir) {
            do {
                try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint(error)
            }
        }
    }
}

// MARK: - 剪切板
public extension String {
    /// 将字符串复制到全局粘贴板
    ///
    ///     "SomeText".pd_copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    func pd_copyToPasteboard() {
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
    /// 根据参数计算字符串`CGSize`
    /// - Parameters:
    ///   - lineWidth: 最大宽度
    ///   - font: 字体
    /// - Returns: 结果`CGSize`
    func pd_stringSize(_ lineWidth: CGFloat = UIScreen.main.bounds.width,
                       font: UIFont) -> CGSize
    {
        let constraint = CGSize(width: lineWidth, height: .greatestFiniteMagnitude)
        // .usesDeviceMetrics, .truncatesLastVisibleLine
        let size = self.pd_nsString()
            .boundingRect(with: constraint,
                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                          attributes: [.font: font],
                          context: nil)
        return CGSize(width: size.width.pd_ceil(), height: size.height.pd_ceil())
    }

    /// 根据参数计算字符串`CGSize`
    /// - Parameters:
    ///   - lineWidth: 最大宽度
    ///   - font: 字体
    ///   - lineSpacing: 行间距
    ///   - wordSpacing: 字间距
    /// - Returns: 结果`CGSize`
    func pd_attributedSize(_ lineWidth: CGFloat = UIScreen.main.bounds.width,
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
        let attributedString = self.pd_nsMutableAttributedString()
            .pd_addAttributes([
                .font: font,
                .kern: wordSpacing,
                .paragraphStyle: paragraphStyle,
            ])

        let constraint = CGSize(width: lineWidth, height: CGFloat.greatestFiniteMagnitude)
        /*
         .usesDeviceMetrics,
         .truncatesLastVisibleLine,
          */
        let size = attributedString.boundingRect(with: constraint,
                                                 options: [
                                                     .usesLineFragmentOrigin,
                                                     .usesFontLeading,
                                                 ], context: nil).size
        // 向上取整(由于计算结果小数问题, 导致界面字符串显示不完整)
        return CGSize(width: size.width.pd_ceil(), height: size.height.pd_ceil())
    }
}

// MARK: - 方法
public extension String {
    /// 从字符串中提取数字
    /// - Returns: 数字字符串
    func pd_extractNumber() -> String {
        return self.filter(\.isNumber)
    }

    /// 字符串中第一个字符
    /// - Returns: 第一个字符(字符串)
    func pd_firstCharacter() -> String? {
        guard let first = first?.pd_string() else { return nil }
        return first
    }

    /// 字符串中最后一个字符
    /// - Returns: 最后一个字符(字符串)
    func pd_lastCharacter() -> String? {
        guard let last = last?.pd_string() else { return nil }
        return last
    }

    /// 字符串中的单词数量(`word`)
    ///
    ///     "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: 单词数量
    func pd_wordCount() -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }

    /// 字符串中的数字个数
    /// - Returns: 数字个数
    func pd_numericCount() -> Int {
        var count = 0
        for c in self where ("0" ... "9").contains(c) {
            count += 1
        }
        return count
    }

    /// 计算字符个数
    ///
    /// - Note: `英文 == 1`,`数字 == 1`,`汉语 == 2`
    /// - Returns: 字符数量
    func pd_countOfChars() -> Int {
        var count = 0
        guard !isEmpty else {
            return 0
        }
        for i in 0 ... self.count - 1 {
            let c: unichar = self.pd_nsString().character(at: i)
            if c >= 0x4E00 {
                count += 2
            } else {
                count += 1
            }
        }
        return count
    }

    /// 计算字符串中包含的`string`个数
    ///
    ///     "Hello World!".pd_count(of:"o") -> 2
    ///     "Hello World!".pd_count(of:"L", caseSensitive:false) -> 3
    ///
    /// - Parameters:
    ///   - string: 查询目标
    ///   - caseSensitive: 是否区分大小写
    /// - Returns: 结果数量
    func pd_count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive { return self.lowercased().components(separatedBy: string.lowercased()).count - 1 }
        return self.components(separatedBy: string).count - 1
    }

    /// 查找字符串中出现最频繁的字符
    ///
    ///     "This is a test, since e is appearing everywhere e should be the common character".pd_mostCommonCharacter() -> "e"
    ///
    /// - Returns: 结果字符
    func pd_mostCommonCharacter() -> Character? {
        let mostCommon = self.pd_withoutSpacesAndNewLines().reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.key
        return mostCommon
    }

    /// 校验`字符串位置`是否有效,并返回`String.Index`
    /// - Parameter original: 位置
    /// - Returns: 返回索引位置
    func pd_validIndex(original: Int) -> String.Index {
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
    ///     "SwifterSwift".pd_unicodeArray() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    ///
    /// - Returns: `unicode`数组
    func pd_unicodeArray() -> [Int] {
        return self.unicodeScalars.map { Int($0.value) }
    }

    /// 字符串中所有单词的数组
    ///
    ///     "Swift is amazing".pd_words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: 单词数组
    func pd_words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }

    /// 从`HTML`字符串中提取链接和文本
    /// - Returns: `(link: String, text: String)?`
    func pd_hrefText() -> (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\"(.*?)>(.*?)</a>"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count))
        else { return nil }
        let link = pd_nsString().substring(with: result.range(at: 1))
        let text = pd_nsString().substring(with: result.range(at: 3))
        return (link, text)
    }

    /// 从字符串中提取链接所在位置的`NSRange`数组
    /// - Returns: `NSRange`数组
    func pd_linkRanges() -> [NSRange]? {
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
    ///     "Hello\ntest".pd_lines() -> ["Hello", "test"]
    ///
    /// - Returns: 分割后的字符串数组
    func pd_lines() -> [String] {
        var result = [String]()
        self.enumerateLines { line, _ in result.append(line) }
        return result
    }

    /// 获取字符串每一行的内容
    ///
    /// - Note: 空字符串为空数组(⚠️不适用于属性文本)
    /// - Parameters:
    ///   - lineWidth: 行宽度
    ///   - font: 字体
    /// - Returns: 字符串数组
    func pd_lines(_ lineWidth: CGFloat, font: UIFont) -> [String] {
        // 段落样式
        let style = NSMutableParagraphStyle.default().pd_lineBreakMode(.byCharWrapping)

        // UIFont字体转CFFont
        let cfFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)

        // 属性字符串
        let attributedString = pd_nsMutableAttributedString()
            .pd_addAttributes([
                .paragraphStyle: style,
                NSAttributedString.Key(kCTFontAttributeName as String): cfFont,
            ], for: pd_fullNSRange())

        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)

        let path = CGMutablePath().pd_addRect(CGRect(x: 0, y: 0, width: lineWidth, height: 100_000))
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

    /// 字符串转换成驼峰命名法
    ///
    ///     "sOme vAriable naMe".pd_camelCase -> "someVariableName"
    ///
    /// - Note: 移除空字符并把单词首字母大写, 第一个单词首字母小写
    /// - Returns: 转换结果
    func pd_camelCase() -> String {
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
    /// - Parameter isTone: 是否带声调
    /// - Returns: 拼音字符串
    func pd_pinYin(_ isTone: Bool = false) -> String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        // 将汉字转换为拼音(带音标)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        // 去掉拼音的音标
        if !isTone { CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false) }
        return mutableString as String
    }

    /// 提取汉字拼音首字母(每个汉字)
    ///
    ///     "爱国".pd_pinYinInitials() --> AG
    ///
    /// - Parameter isUpper: 是否大写
    /// - Returns: 字符串的拼音首字母字符串
    func pd_pinYinInitials(_ isUpper: Bool = true) -> String {
        let pinYin = pd_pinYin(false).components(separatedBy: " ")
        let initials = pinYin.compactMap { String(format: "%c", $0.cString(using: .utf8)![0]) }
        return isUpper ? initials.joined().uppercased() : initials.joined()
    }

    /// 返回一个本地化的字符串,带有可选的翻译注释
    /// - Parameter comment: 注释
    /// - Returns: 本地化字符串
    func pd_localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    /// 将字符串转换为slug字符串
    ///
    ///     "Swift is amazing".pd_slug() -> "swift-is-amazing"
    ///
    /// - Returns: 结果字符串
    func pd_slug() -> String {
        let lowercased = lowercased()
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        while filtered.pd_lastCharacter() == "-" {
            filtered = String(filtered.dropLast())
        }
        while filtered.pd_firstCharacter() == "-" {
            filtered = String(filtered.dropFirst())
        }

        return filtered.replacingOccurrences(of: "--", with: "-")
    }

    /// 删除字符串开着和结尾的空格及换行符
    ///
    ///     var str = "  \n Hello World \n\n\n"
    ///     str.pd_trim()
    ///     print(str) // prints "Hello World"
    ///
    /// - Returns: 结果字符串
    @discardableResult
    func pd_trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 移除字符串前后的空格
    /// - Returns: 结果字符串
    func pd_trimmedSpace() -> String {
        let resultString = trimmingCharacters(in: CharacterSet.whitespaces)
        return resultString
    }

    /// 移除字符前后的换行符
    /// - Returns: 结果字符串
    func pd_trimmedNewLines() -> String {
        let resultString = trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }

    /// 移除字符串中的所有空格
    /// - Returns: 结果字符串
    func pd_withoutSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }

    /// 移除字符串中的所有换行符
    /// - Returns: 结果字符串
    func pd_withoutNewLines() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
    }

    /// 移除字符串中所有的空格和换行符
    ///
    ///     "   \n Swifter   \n  Swift  ".pd_withoutSpacesAndNewLines -> "SwifterSwift"
    ///
    /// - Returns: 结果字符串
    func pd_withoutSpacesAndNewLines() -> String {
        replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }

    /// 字符串的首字符大写,其它字符保持原样
    ///
    ///     "hello world".pd_firstCharacterUppercased() -> "Hello world"
    ///     "".pd_firstCharacterUppercased() -> ""
    ///
    /// - Returns: 结果字符串
    func pd_firstCharacterUppercased() -> String? {
        guard let first else { return nil }
        return String(first).uppercased() + dropFirst()
    }

    /// 将字符串反转
    /// - Returns: 结果字符串
    @discardableResult
    mutating func pd_reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }

    /// 分割字符串
    /// - Parameter char: 分割依据
    /// - Returns: 结果数组
    func pd_split(with char: String) -> [String] {
        let components = self.components(separatedBy: char)
        return components != [""] ? components : []
    }

    /// 在字符串头部填充字符串以适应长度
    ///
    ///     "hue".pd_padStart(10) -> "       hue"
    ///     "hue".pd_padStart(10, with:"br") -> "brbrbrbhue"
    ///
    /// - Note: 只有字符串小于指定长度才会发生填充
    /// - Parameters:
    ///   - length: 字符串长度
    ///   - string: 用于填充的字符串
    /// - Returns: 结果字符串
    @discardableResult
    func pd_padStart(_ length: Int, with string: String = " ") -> String {
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

    /// 在字符串尾部填充字符串以适应长度
    ///
    ///     "hue".pd_padEnd(10) -> "hue       "
    ///     "hue".pd_padEnd(10, with:"br") -> "huebrbrbrb"
    ///
    /// - Note: 只有字符串小于指定长度才会发生填充
    /// - Parameters:
    ///   - length: 字符串长度
    ///   - string: 用于填充的字符串
    /// - Returns: 结果字符串
    @discardableResult
    func pd_padEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex ..< string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex ..< padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }

    /// 使用`template`替换`regex`匹配的项
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - template: 用于替换的字符串
    ///   - options: 匹配选项
    ///   - searchRange: 搜索范围
    /// - Returns: 结果字符串
    func pd_replacingOccurrences(of regex: NSRegularExpression,
                                 with template: String,
                                 options: NSRegularExpression.MatchingOptions = [],
                                 range searchRange: Range<String.Index>? = nil) -> String
    {
        let range = NSRange(searchRange ?? startIndex ..< endIndex, in: self)
        return regex.stringByReplacingMatches(in: self,
                                              options: options,
                                              range: range,
                                              withTemplate: template)
    }

    /// 使用`template`替换`regex`匹配的项
    /// - Parameters:
    ///   - pattern: 正则表达式
    ///   - template: 用于替换的字符串
    ///   - options: 匹配选项
    /// - Returns: 结果字符串
    func pd_replacingOccurrences(of pattern: String,
                                 with template: String,
                                 options: NSRegularExpression.Options = []) -> String
    {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self,
                                              options: [],
                                              range: NSRange(location: 0, length: count),
                                              withTemplate: template)
    }

    /// 从字符串中删除指定的前缀
    ///
    ///     "Hello, World!".pd_removePrefix("Hello, ") -> "World!"
    ///
    /// - Parameter prefix: 要从字符串中删除的前缀
    /// - Returns: 结果字符串
    func pd_removePrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    /// 从字符串中删除给定的后缀
    ///
    ///     "Hello, World!".pd_removeSuffix(", World!") -> "Hello"
    ///
    /// - Parameter suffix: 要从字符串中删除的后缀
    /// - Returns: 结果字符串
    func pd_removeSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// 为字符串添加前缀
    ///
    ///     "www.apple.com".pd_withPrefix("https://") -> "https://www.apple.com"
    ///
    /// - Parameter prefix: 前缀
    /// - Returns: 结果字符串
    func pd_withPrefix(_ prefix: String) -> String {
        guard !hasPrefix(prefix) else { return self }
        return prefix + self
    }

    /// 为字符串添加前缀
    ///
    ///     "https://www.apple".pd_withSuffix(".com") -> "https://www.apple.com"
    ///
    /// - Parameter prefix: 前缀
    /// - Returns: 结果字符串
    func pd_withSuffix(_ suffix: String) -> String {
        guard !hasSuffix(suffix) else { return self }
        return self + suffix
    }

    /// 在任意位置插入字符串
    /// - Parameters:
    ///   - content: 插入内容
    ///   - locat: 插入的位置
    /// - Returns: 结果字符串
    func pd_insertString(content: String, locat: Int) -> String {
        guard locat < count else {
            return self
        }
        let str1 = self.pd_subString(to: locat)
        let str2 = self.pd_subString(from: locat + 1)
        return str1 + content + str2
    }

    /// 替换字符串
    /// - Parameters:
    ///   - string: 被替换的字符串
    ///   - withString: 以于替换的字符串
    /// - Returns: 结果字符串
    func pd_replace(_ string: String, with withString: String) -> String {
        return self.replacingOccurrences(of: string, with: withString)
    }

    /// 隐藏字符串中的敏感内容
    ///
    ///     "012345678912".pd_hideSensitiveContent(range:3..<8, replace:"*****") -> "012*****912"
    ///
    /// - Parameters:
    ///   - range: 要隐藏的内容`Range<Int>`
    ///   - replace: 用来替换敏感内容的字符串
    /// - Returns: 结果字符串
    func pd_hideSensitiveContent(range: Range<Int>, replace: String = "****") -> String {
        if count < range.upperBound {
            return self
        }
        guard let subStr = self[safe: range] else {
            return self
        }
        return self.pd_replace(subStr, with: replace)
    }

    /// 生成指定数量的重复字符串
    /// - Parameter count: 重复个数
    /// - Returns: 结果字符串
    func pd_repeat(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }

    /// 删除字符串中指定的字符
    /// - Parameter characterString: 要删除的字符
    /// - Returns: 结果字符串
    func pd_removeCharacter(characterString: String) -> String {
        let characterSet = CharacterSet(charactersIn: characterString)
        return self.trimmingCharacters(in: characterSet)
    }

    /// 获取最长相同后缀
    /// - Parameters:
    ///   - aString: 用于与`self`比较的字符串
    ///   - options: 选项
    /// - Returns: 结果字符串
    func pd_commonSuffix(with aString: String, options: CompareOptions = []) -> String {
        return String(zip(reversed(), aString.reversed())
            .lazy
            .prefix(while: { (lhs: Character, rhs: Character) in
                return String(lhs).compare(String(rhs), options: options) == .orderedSame
            })
            .map { (lhs: Character, rhs: Character) in
                return lhs
            }
            .reversed())
    }
}

// MARK: - 数字字符串
public extension String {
    /// 金额字符串,千分位表示
    ///
    ///     "1234567".pd_amountAsThousands() => 1,234,567
    ///     "1234567.56".pd_amountAsThousands() => 1,234,567.56
    ///
    /// - Returns: 结果字符串
    func pd_amountAsThousands(roundOff: Bool = true, or default: String = "") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        if contains(".") {
            formatter.maximumFractionDigits = roundOff ? 0 : 2
            formatter.minimumFractionDigits = roundOff ? 0 : 2
            formatter.minimumIntegerDigits = 1
        }
        var num = NSDecimalNumber(string: self)
        if num.doubleValue.isNaN { num = NSDecimalNumber(string: "0") }
        let result = formatter.string(from: num)
        return result ?? `default`
    }

    /// 删除小数点后面多余的0
    /// - Returns: 结果字符串
    func pd_deleteMoreThanZeroFromAfterDecimalPoint() -> String {
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
    ///   - decimalPlaces: 保留几位小数
    ///   - mode: 模式
    /// - Returns: 结果字符串
    func pd_keepDecimalPlaces(decimalPlaces: Int = 0, mode: NumberFormatter.RoundingMode = .floor) -> String {
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
                for _ in 0 ..< decimalPlaces {
                    zero += zero
                }
                return "0." + zero
            }
        }
        return result
    }
}

// MARK: - NSDecimalNumber四则运算
public extension String {
    /// `＋` 加法运算
    /// - Parameter strNumber: 加数字符串
    /// - Returns: 结果数字串
    func pd_adding(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .zero }
        let final = ln.adding(rn)
        return final.stringValue
    }

    /// `－` 减法运算
    /// - Parameter strNumber: 减数字符串
    /// - Returns: 结果数字串
    func pd_subtracting(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .zero }
        let final = ln.subtracting(rn)
        return final.stringValue
    }

    /// `*` 乘法运算
    /// - Parameter strNumber: 乘数字符串
    /// - Returns: 结果数字串
    func pd_multiplying(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .zero }
        let final = ln.multiplying(by: rn)
        return final.stringValue
    }

    /// `/`除法运算
    /// - Parameter strNumber: 除数字符串
    /// - Returns: 结果字符串
    func pd_dividing(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .one }
        if rn.doubleValue == 0 { rn = .one }
        let final = ln.dividing(by: rn)
        return final.stringValue
    }
}

// MARK: - 运算符
public extension String {
    /// 重载 `Swift` 的`包含运算符`以匹配正则表达式模式
    /// - Parameters:
    ///   - lhs: 用于匹配的字符串
    ///   - rhs: 用于匹配的正则字符串
    /// - Returns: 匹配结果
    static func ~= (lhs: String, rhs: String) -> Bool {
        return lhs.range(of: rhs, options: .regularExpression) != nil
    }

    /// 重载 `Swift` 的`包含运算符`以匹配正则表达式
    /// - Parameters:
    ///   - lhs: 用于匹配的字符串
    ///   - rhs: 用于匹配的正则表达式
    /// - Returns: 匹配结果
    static func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
        let range = NSRange(lhs.startIndex ..< lhs.endIndex, in: lhs)
        return rhs.firstMatch(in: lhs, range: range) != nil
    }

    /// 生成重复字符串
    ///
    ///     "bar"  * 3 -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: 要重复的字符串
    ///   - rhs: 重复字符串个数
    /// - Returns:
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    /// 生成重复字符串
    ///
    ///     3 * 'bar' -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: 重复字符串个数
    ///   - rhs: 要重复的字符串
    /// - Returns: 结果字符串
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
}
