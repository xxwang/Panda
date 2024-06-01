import CoreGraphics
import CoreLocation
import UIKit

public extension String {
    var pd_localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

public extension String {

    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
}

public extension String {

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

    subscript(nsRange: NSRange) -> Substring {
        guard let range = Range(nsRange, in: self) else { fatalError("Failed to find range \(nsRange) in \(self)") }
        return self[range]
    }
}

public extension String {

    func pd_int() -> Int {
        return Int(self) ?? 0
    }

    func pd_int64() -> Int64 {
        Int64(self) ?? 0
    }

    func pd_uInt() -> UInt {
        return UInt(self) ?? 0
    }

    func pd_uInt64() -> UInt64 {
        return UInt64(self) ?? 0
    }

    func pd_float() -> Float {
        return Float(self) ?? 0
    }

    func pd_double() -> Double {
        return Double(self) ?? 0
    }

    func pd_cgFloat() -> CGFloat {
        CGFloat(pd_double())
    }

    func pd_nsNumber() -> NSNumber {
        NSNumber(value: pd_double())
    }

    func pd_bool() -> Bool {
        let trimmed = pd_trim().lowercased()
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    func pd_character() -> Character? {
        guard let n = Int(self), let scalar = UnicodeScalar(n) else { return nil }
        return Character(scalar)
    }

    func pd_characters() -> [Character] {
        return Array(self)
    }

    func pd_nsString() -> NSString {
        return NSString(string: self)
    }

    func pd_hexInt() -> Int {
        return Int(self, radix: 16) ?? 0
    }

    func pd_data() -> Data? {
        return data(using: .utf8)
    }

    func pd_hexColor() -> UIColor {
        return UIColor(hex: self)
    }

    func pd_image() -> UIImage? {
        return UIImage(named: self)
    }

    func pd_url() -> URL? {
        if hasPrefix("http://") || hasPrefix("https://") {
            return URL(string: self)
        }
        return URL(fileURLWithPath: self)
    }

    func pd_urlRequest() -> URLRequest? {
        guard let url = pd_url() else {
            return nil
        }
        return URLRequest(url: url)
    }

    func pd_notificationName() -> Notification.Name {
        return Notification.Name(self)
    }

    func pd_nsAttributedString() -> NSAttributedString {
        return NSAttributedString(string: self)
    }

    func pd_nsMutableAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}

public extension String {

    func pd_classNameToClass<T>(for name: T.Type = AnyClass.self) -> T.Type? {
        guard let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else { return nil }
        let classNameString = "\(namespace.pd_replace(" ", with: "_")).\(self)"
        guard let nameClass = NSClassFromString(classNameString) as? T.Type else { return nil }
        return nameClass
    }

    func pd_classNameToInstance<T>(for name: T.Type = NSObject.self) -> T? where T: NSObject {
        guard let nameClass = pd_classNameToClass(for: name) else {
            return nil
        }
        let object = nameClass.init()
        return object
    }
}

public extension String {

    func pd_fullRange() -> Range<String.Index>? {
        return startIndex ..< endIndex
    }

    func pd_range(_ nsRange: NSRange) -> Range<String.Index> {
        guard let range = Range(nsRange, in: self) else { fatalError("Failed to find range \(nsRange) in \(self)") }
        return range
    }

    func pd_range(_ subString: String) -> Range<String.Index>? {
        range(of: subString)
    }
}

public extension String {

    func pd_fullNSRange() -> NSRange {
        return NSRange(startIndex ..< endIndex, in: self)
    }

    func pd_nsRange(_ range: Range<String.Index>) -> NSRange {
        NSRange(range, in: self)
    }

    func pd_nsRange(_ subStr: String) -> NSRange {
        guard let range = range(of: subStr) else {
            return NSRange(location: 0, length: 0)
        }
        return NSRange(range, in: self)
    }
}

public extension String {

    static func pd_loremIpsum(of length: Int = 445) -> String {
        guard length > 0 else { return "" }

        let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        if loremIpsum.count > length {
            return String(loremIpsum[loremIpsum.startIndex ..< loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
        }
        return loremIpsum
    }

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


public extension String {

    func pd_positionFirst(of subStr: String) -> Int {
        return pd_position(of: subStr)
    }

    func pd_positionLast(of subStr: String) -> Int {
        return pd_position(of: subStr, backwards: true)
    }

    func pd_position(of subStr: String, backwards: Bool = false) -> Int {
        var pos = -1
        if let range = range(of: subStr, options: backwards ? .backwards : .literal) {
            if !range.isEmpty { pos = distance(from: startIndex, to: range.lowerBound) }
        }
        return pos
    }
}

public extension String {
    func pd_indexString(index: Int) -> String {
        return self.pd_slice(index ..< index + 1)
    }

    func pd_slice(_ range: CountableRange<Int>) -> String {
        let startIndex = pd_validIndex(original: range.lowerBound)
        let endIndex = pd_validIndex(original: range.upperBound)
        guard startIndex < endIndex else {
            return ""
        }
        return String(self[startIndex ..< endIndex])
    }

    func pd_subString(from: Int) -> String {
        let end = count
        return self[safe: from ..< end] ?? ""
    }

    func pd_subString(to: Int) -> String {
        return self[safe: 0 ..< to] ?? ""
    }

    func pd_subString(from: Int, length: Int) -> String {
        let end = from + length
        return self[safe: from ..< end] ?? ""
    }

    func pd_subString(from: Int, to: Int) -> String {
        return self[safe: from ..< to] ?? ""
    }

    func pd_subString(range: NSRange) -> String {
        return self.pd_nsString().substring(with: range)
    }

    func pd_subString(range: Range<Int>) -> String {
        return self[safe: range] ?? ""
    }

    func pd_subString(range: Range<String.Index>) -> String {
        let subString = self[range]
        return String(subString)
    }

    func pd_truncate(len: Int) -> String {
        if self.count > len {
            return self.pd_subString(to: len)
        }
        return self
    }

    func pd_truncate(length: Int, trailing: String? = "...") -> String {
        guard 0 ..< count ~= length else { return self }
        return self[startIndex ..< index(startIndex, offsetBy: length)] + (trailing ?? "")
    }

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

public extension String {

    func pd_hasLetters() -> Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    func pd_isAlphabetic() -> Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    func pd_hasNumbers() -> Bool {
        rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    func pd_isAlphaNumeric() -> Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }

    func pd_isSwiftNumeric() -> Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        if #available(iOS 13.0, *) {
            return scanner.scanDecimal() != nil && scanner.isAtEnd
        } else {
            return scanner.scanDecimal(nil) && scanner.isAtEnd
        }
    }

    func pd_isPureInt() -> Bool {
        let scan = Scanner(string: self)
        if #available(iOS 13.0, *) {
            return (scan.scanInt() != nil) && scan.isAtEnd
        } else {
            return scan.scanInt(nil) && scan.isAtEnd
        }
    }

    func pd_isDigits() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    func pd_isWhitespace() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

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

    func pd_isPalindrome() -> Bool {
        let letters = filter(\.isLetter)
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex ..< midIndex]
        let secondHalf = letters[midIndex ..< letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }

    func pd_hasUniqueCharacters() -> Bool {
        guard count > 0 else { return false }
        var uniqueChars = Set<String>()
        for char in self {
            if uniqueChars.contains(String(char)) { return false }
            uniqueChars.insert(String(char))
        }
        return true
    }

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

    func pd_isTelNumber() -> Bool {
        let pattern = "^1[3456789]\\d{9}$"
        return pd_regexp(pattern)
    }

    func pd_isAlphanueric(minLen: Int, maxLen: Int) -> Bool {
        let pattern = "^[0-9a-zA-Z_]{\(minLen),\(maxLen)}$"
        return pd_regexp(pattern)
    }

    func pd_isAlphanueric() -> Bool {
        let pattern = "^[A-Za-z0-9]+$"
        return pd_isMatchRegexp(pattern)
    }

    func pd_isChinese() -> Bool {
        let pattern = "(^[\u{4e00}-\u{9fef}]+$)"
        return pd_regexp(pattern)
    }

    func pd_isEmail1() -> Bool {
        let pattern = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?"
        return pd_regexp(pattern)
    }

    func pd_isEmai2() -> Bool {
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    func pd_isNickName() -> Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        return pd_regexp(rgex)
    }

    func pd_validateUserName() -> Bool {
        let rgex = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        return pd_regexp(rgex)
    }

    func pd_password(_ complex: Bool = false) -> Bool {
        var pattern = "^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{8,20}$"
        if complex {
            pattern = "^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\\W_]+$)(?![a-z0-9]+$)(?![a-z\\W_]+$)(?![0-9\\W_]+$)[a-zA-Z0-9\\W_]{8,20}$"
        }
        return pd_regexp(pattern)
    }

    func pd_isNumberValue() -> Bool {
        guard !isEmpty else {
            return false
        }
        let rgex = "^[\\d]*$"
        return pd_regexp(rgex)
    }

    func pd_isValidNumberAndDecimalPoint() -> Bool {
        guard !isEmpty else {
            return false
        }
        let rgex = "^[\\d.]*$"
        return pd_regexp(rgex)
    }

    func pd_isIDNumber() -> Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
        return pd_regexp(pattern)
    }

    var isValidIDNumber: Bool {
        let str = trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let len = str.count
        if !str.pd_isIDNumber() {
            return false
        }

        let areaArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        if !areaArray.contains(str.pd_subString(to: 2)) {
            return false
        }
        var regex = NSRegularExpression()
        var numberOfMatch = 0
        var year = 0
        switch len {
        case 15:
            year = Int(str.pd_subString(from: 6, length: 2))!
            if pd_isLeapYear(year: year) {
                do {
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive)
                } catch {}
            }
            numberOfMatch = regex.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: len))

            if numberOfMatch > 0 { return true } else { return false }
        case 18:
            year = Int(str.pd_subString(from: 6, length: 4))!
            if pd_isLeapYear(year: year) {
                do {
                    regex = try NSRegularExpression(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch {}
            } else {
                do {
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

    func pd_isValidUrl() -> Bool {
        return URL(string: self) != nil
    }

    func pd_isValidSchemedUrl() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    func pd_isValidHttpsUrl() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }

    func pd_isValidHttpUrl() -> Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }

    func pd_isValidFileUrl() -> Bool {
        URL(string: self)?.isFileURL ?? false
    }

    func pd_contains(find: String) -> Bool {
        self.pd_contains(find, caseSensitive: true)
    }

    func pd_contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }

    func pd_containsIgnoringCase(find: String) -> Bool {
        return pd_contains(find, caseSensitive: false)
    }

    func pd_starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }

    func pd_ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
}

infix operator =~: RegPrecedence
precedencegroup RegPrecedence {
    associativity: none
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

public extension String {

    static func =~ (lhs: String, rhs: String) -> Bool {
        lhs.pd_regexp(rhs)
    }
}

public extension String {

    func pd_regexEscaped() -> String {
        return NSRegularExpression.escapedPattern(for: self)
    }

    func pd_matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }

    func pd_matches(regex: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        let range = NSRange(startIndex ..< endIndex, in: self)
        return regex.firstMatch(in: self, options: options, range: range) != nil
    }

    func pd_regexp(_ pattern: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }

    func pd_isMatchRegexp(_ pattern: String) -> Bool {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        let result = regx.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: utf16.count))
        return !result.isEmpty
    }

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

public extension String {

    func pd_stringAsHtmlCharacterEntityReferences() -> String {
        var result = ""
        for scalar in utf16 {
            let tem = String().appendingFormat("%04x", scalar)
            result += "&#x\(tem);"
        }
        return result
    }

    func pd_htmlCharacterEntityReferencesAsString() -> String? {
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                                                     NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
        guard let encodedData = data(using: String.Encoding.utf8) else { return nil }
        guard let attributedString = try? NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil) else { return nil }
        return attributedString.string
    }
}

public extension String {

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
                if let weakHtmlString = htmlString, weakHtmlString.string.hasSuffix("\n") {
                    htmlString?.deleteCharacters(in: NSRange(location: weakHtmlString.length - wrapHtmlString.length, length: wrapHtmlString.length))
                }
            }
        } catch {}
        if let font { htmlString?.addAttributes([.font: font], range: pd_fullNSRange()) }

        if let weakLineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle.default().pd_lineSpacing(weakLineSpacing)
            htmlString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: pd_fullNSRange())
        }
        return htmlString ?? pd_nsMutableAttributedString()
    }

    func pd_highlightSubString(keyword: String,
                               keywordCololor: UIColor,
                               otherColor: UIColor,
                               options: NSRegularExpression.Options = []) -> NSMutableAttributedString
    {
        let fullString = self
        let attributedString = fullString.pd_nsMutableAttributedString().pd_addAttributes([
            NSAttributedString.Key.foregroundColor: otherColor,
        ])

        let ranges = fullString.pd_matchRange(keyword)

        for range in ranges {
            attributedString.addAttributes([.foregroundColor: keywordCololor], range: range)
        }
        return attributedString
    }
}

public extension String {

    @discardableResult
    mutating func pd_urlEncode() -> String {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            self = encoded
        }
        return self
    }

    @discardableResult
    mutating func pd_urlDecode() -> String {
        if let decoded = removingPercentEncoding { self = decoded }
        return self
    }
}

public extension String {

    func pd_base64Encoded() -> String? {
        let plainData = pd_data()
        return plainData?.base64EncodedString()
    }

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

public extension String {

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

    func pd_unicodeDecode() -> String {
        let tempStr1 = replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print("😭error! \(error.localizedDescription)")
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}

public extension String {

    func pd_date(with format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

public extension String {

    func pd_locationEncode(completionHandler: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().geocodeAddressString(self, completionHandler: completionHandler)
    }
}

public extension String {

    func pd_urls() -> [String]? {
        var urls = [String]()
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue)) else {
            return nil
        }

        let res = dataDetector.matches(in: self,
                                       options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                       range: NSRange(location: 0, length: count))

        for checkingRes in res {
            urls.append(pd_nsString().substring(with: checkingRes.range))
        }
        return urls
    }

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

public extension String {

    func pd_lastPathComponent() -> String {
        return self.pd_nsString().lastPathComponent
    }

    func pd_pathExtension() -> String {
        return self.pd_nsString().pathExtension
    }

    func pd_deletingLastPathComponent() -> String {
        return self.pd_nsString().deletingLastPathComponent
    }

    func pd_deletingPathExtension() -> String {
        return self.pd_nsString().deletingPathExtension
    }

    func pd_pathComponents() -> [String] {
        return self.pd_nsString().pathComponents
    }

    func pd_appendingPathComponent(_ str: String) -> String {
        return self.pd_nsString().appendingPathComponent(str)
    }

    func pd_appendingPathExtension(_ str: String) -> String? {
        return self.pd_nsString().appendingPathExtension(str)
    }
}

public extension String {

    func pd_appendBySupport() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        self.pd_createDirs(directory)
        return directory + "/\(self)"
    }

    func pd_appendByDocument() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.pd_createDirs(directory)
        return directory + "/\(self)"
    }

    func pd_appendByCache() -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        self.pd_createDirs(directory)
        return directory + "/\(self)"
    }

    func pd_appendByTemp() -> String {
        let directory = NSTemporaryDirectory()
        self.pd_createDirs(directory)
        return directory + "/\(self)"
    }
}

public extension String {

    func pd_urlBySupport() -> URL {
        _ = pd_appendByDocument()
        let fileUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }

    func pd_urlByDocument() -> URL {
        _ = pd_appendByDocument()
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }

    func pd_urlByCache() -> URL {
        _ = pd_appendByCache()
        let fileUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return fileUrl.appendingPathComponent(self)
    }
}

public extension String {
    func pd_removeFile() {
        if FileManager.default.fileExists(atPath: self) {
            do {
                try FileManager.default.removeItem(atPath: self)
            } catch {
                debugPrint("file delete failed!")
            }
        }
    }

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

public extension String {

    func pd_copyToPasteboard() {
        #if os(iOS)
            UIPasteboard.general.string = self
        #elseif os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(base, forType: .string)
        #endif
    }
}

public extension String {

    func pd_stringSize(_ lineWidth: CGFloat = UIScreen.main.bounds.width,
                       font: UIFont) -> CGSize
    {
        let constraint = CGSize(width: lineWidth, height: .greatestFiniteMagnitude)

        let size = self.pd_nsString()
            .boundingRect(with: constraint,
                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                          attributes: [.font: font],
                          context: nil)
        return CGSize(width: size.width.pd_ceil(), height: size.height.pd_ceil())
    }

    func pd_attributedSize(_ lineWidth: CGFloat = UIScreen.main.bounds.width,
                           font: UIFont,
                           lineSpacing: CGFloat = 0,
                           wordSpacing: CGFloat = 0) -> CGSize
    {
        let paragraphStyle = NSMutableParagraphStyle.default()
            .pd_lineBreakMode(.byCharWrapping)
            .pd_alignment(.left)
            .pd_lineSpacing(lineSpacing)
            .pd_hyphenationFactor(1.0)
            .pd_firstLineHeadIndent(0.0)
            .pd_paragraphSpacingBefore(0.0)
            .pd_headIndent(0)
            .pd_tailIndent(0)

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
        return CGSize(width: size.width.pd_ceil(), height: size.height.pd_ceil())
    }
}

public extension String {

    func pd_extractNumber() -> String {
        return self.filter(\.isNumber)
    }

    func pd_firstCharacter() -> String? {
        guard let first = first?.pd_string() else { return nil }
        return first
    }

    func pd_lastCharacter() -> String? {
        guard let last = last?.pd_string() else { return nil }
        return last
    }

    func pd_wordCount() -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }

    func pd_numericCount() -> Int {
        var count = 0
        for c in self where ("0" ... "9").contains(c) {
            count += 1
        }
        return count
    }

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

    func pd_count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive { return self.lowercased().components(separatedBy: string.lowercased()).count - 1 }
        return self.components(separatedBy: string).count - 1
    }

    func pd_mostCommonCharacter() -> Character? {
        let mostCommon = self.pd_withoutSpacesAndNewLines().reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.key
        return mostCommon
    }

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

    func pd_unicodeArray() -> [Int] {
        return self.unicodeScalars.map { Int($0.value) }
    }

    func pd_words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }

    func pd_hrefText() -> (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\"(.*?)>(.*?)</a>"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count))
        else { return nil }
        let link = pd_nsString().substring(with: result.range(at: 1))
        let text = pd_nsString().substring(with: result.range(at: 3))
        return (link, text)
    }

    func pd_linkRanges() -> [NSRange]? {
        let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
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

    func pd_lines() -> [String] {
        var result = [String]()
        self.enumerateLines { line, _ in result.append(line) }
        return result
    }

    func pd_lines(_ lineWidth: CGFloat, font: UIFont) -> [String] {
        let style = NSMutableParagraphStyle.default().pd_lineBreakMode(.byCharWrapping)
        let cfFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
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

    func pd_pinYin(_ isTone: Bool = false) -> String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        if !isTone { CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false) }
        return mutableString as String
    }

    func pd_pinYinInitials(_ isUpper: Bool = true) -> String {
        let pinYin = pd_pinYin(false).components(separatedBy: " ")
        let initials = pinYin.compactMap { String(format: "%c", $0.cString(using: .utf8)![0]) }
        return isUpper ? initials.joined().uppercased() : initials.joined()
    }

    func pd_localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

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

    @discardableResult
    func pd_trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func pd_trimmedSpace() -> String {
        let resultString = trimmingCharacters(in: CharacterSet.whitespaces)
        return resultString
    }

    func pd_trimmedNewLines() -> String {
        let resultString = trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }

    func pd_withoutSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }

    func pd_withoutNewLines() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
    }

    func pd_withoutSpacesAndNewLines() -> String {
        replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }

    func pd_firstCharacterUppercased() -> String? {
        guard let first else { return nil }
        return String(first).uppercased() + dropFirst()
    }

    @discardableResult
    mutating func pd_reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }

    func pd_split(with char: String) -> [String] {
        let components = self.components(separatedBy: char)
        return components != [""] ? components : []
    }

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

    func pd_removePrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    func pd_removeSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    func pd_withPrefix(_ prefix: String) -> String {
        guard !hasPrefix(prefix) else { return self }
        return prefix + self
    }

    func pd_withSuffix(_ suffix: String) -> String {
        guard !hasSuffix(suffix) else { return self }
        return self + suffix
    }

    func pd_insertString(content: String, locat: Int) -> String {
        guard locat < count else {
            return self
        }
        let str1 = self.pd_subString(to: locat)
        let str2 = self.pd_subString(from: locat + 1)
        return str1 + content + str2
    }

    func pd_replace(_ string: String, with withString: String) -> String {
        return self.replacingOccurrences(of: string, with: withString)
    }

    func pd_hideSensitiveContent(range: Range<Int>, replace: String = "****") -> String {
        if count < range.upperBound {
            return self
        }
        guard let subStr = self[safe: range] else {
            return self
        }
        return self.pd_replace(subStr, with: replace)
    }

    func pd_repeat(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }

    func pd_removeCharacter(characterString: String) -> String {
        let characterSet = CharacterSet(charactersIn: characterString)
        return self.trimmingCharacters(in: characterSet)
    }

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

public extension String {

    func pd_amountAsThousands(maximumFractionDigits: Int = 2, or default: String = "") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if contains(".") {
            formatter.maximumFractionDigits = maximumFractionDigits
            formatter.minimumFractionDigits = 0
            formatter.minimumIntegerDigits = 1
        } else {
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
        }
        var num = NSDecimalNumber(string: self)
        if num.doubleValue.isNaN {
            num = NSDecimalNumber(string: "0")
        }
        let result = formatter.string(from: num)
        return result ?? `default`
    }

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

    func pd_keepDecimalPlaces(decimalPlaces: Int = 0, mode: NumberFormatter.RoundingMode = .floor) -> String {

        var decimalNumber = NSDecimalNumber(string: self)
        if decimalNumber.doubleValue.isNaN {
            decimalNumber = NSDecimalNumber.zero
        }

        let formatter = NumberFormatter()
        formatter.roundingMode = mode
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = decimalPlaces
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 100

        guard let result = formatter.string(from: decimalNumber) else {
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

public extension String {

    func pd_adding(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .zero }
        let final = ln.adding(rn)
        return final.stringValue
    }

    func pd_subtracting(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .zero }
        let final = ln.subtracting(rn)
        return final.stringValue
    }

    func pd_multiplying(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: self)
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN { ln = .zero }
        if rn.doubleValue.isNaN { rn = .zero }
        let final = ln.multiplying(by: rn)
        return final.stringValue
    }

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

public extension String {

    static func ~= (lhs: String, rhs: String) -> Bool {
        return lhs.range(of: rhs, options: .regularExpression) != nil
    }

    static func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
        let range = NSRange(lhs.startIndex ..< lhs.endIndex, in: lhs)
        return rhs.firstMatch(in: lhs, range: range) != nil
    }

    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
}
