import Foundation

public extension NSRegularExpression {
    func xx_enumerateMatches(in string: String,
                             options: NSRegularExpression.MatchingOptions = [],
                             range: Range<String.Index>,
                             using block: (_ result: NSTextCheckingResult?,
                                           _ flags: NSRegularExpression.MatchingFlags,
                                           _ stop: inout Bool) -> Void)
    {
        self.enumerateMatches(in: string, options: options, range: NSRange(range, in: string)) { result, flags, stop in
            var shouldStop = false
            block(result, flags, &shouldStop)
            if shouldStop { stop.pointee = true }
        }
    }

    func xx_matches(in string: String,
                    options: NSRegularExpression.MatchingOptions = [],
                    range: Range<String.Index>) -> [NSTextCheckingResult]
    {
        return self.matches(in: string, options: options, range: NSRange(range, in: string))
    }

    func xx_numberOfMatches(in string: String,
                            options: NSRegularExpression.MatchingOptions = [],
                            range: Range<String.Index>) -> Int
    {
        return self.numberOfMatches(in: string, options: options, range: NSRange(range, in: string))
    }

    func xx_firstMatch(in string: String,
                       options: NSRegularExpression.MatchingOptions = [],
                       range: Range<String.Index>) -> NSTextCheckingResult?
    {
        return self.firstMatch(in: string, options: options, range: NSRange(range, in: string))
    }

    func xx_rangeOfFirstMatch(in string: String,
                              options: NSRegularExpression.MatchingOptions = [],
                              range: Range<String.Index>) -> Range<String.Index>?
    {
        return Range(rangeOfFirstMatch(in: string,
                                       options: options,
                                       range: NSRange(range, in: string)), in: string)
    }

    func xx_stringByReplacingMatches(in string: String,
                                     options: NSRegularExpression.MatchingOptions = [],
                                     range: Range<String.Index>,
                                     with template: String) -> String
    {
        return self.stringByReplacingMatches(in: string,
                                             options: options,
                                             range: NSRange(range, in: string),
                                             withTemplate: template)
    }

    @discardableResult
    func xx_replaceMatches(in string: inout String,
                           options: NSRegularExpression.MatchingOptions = [],
                           range: Range<String.Index>,
                           with template: String) -> Int
    {
        let mutableString = NSMutableString(string: string)
        let matches = replaceMatches(in: mutableString,
                                     options: options,
                                     range: NSRange(range, in: string),
                                     withTemplate: template)
        string = mutableString.copy() as! String
        return matches
    }
}
