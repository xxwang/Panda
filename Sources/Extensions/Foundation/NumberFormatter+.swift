import Foundation

public extension NumberFormatter {
    static func sk_numberFormatting(value: Float, style: NumberFormatter.Style = .none) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: value), number: style)
    }

    static func sk_numberFormatting(value: Double, style: NumberFormatter.Style = .none) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: value), number: style)
    }

    static func sk_stringFormattingNumber(value: String, style: NumberFormatter.Style = .none) -> String? {
        guard let number = NumberFormatter().number(from: value) else { return nil }
        return NumberFormatter.localizedString(from: number, number: style)
    }

    static func sk_customFormatter(value: String, numberFormatter: NumberFormatter) -> String? {
        guard let number = NumberFormatter().number(from: value) else { return nil }
        guard let formatValue = numberFormatter.string(from: number) else { return nil }
        return formatValue
    }

    static func sk_groupingSeparatorAndSize(value: String,
                                            separator: String,
                                            size: Int,
                                            style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = separator
        numberFormatter.groupingSize = size
        return sk_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func sk_formatWidthPaddingCharacterAndPosition(value: String,
                                                          formatWidth: Int,
                                                          paddingCharacter: String,
                                                          paddingPosition: NumberFormatter.PadPosition = .beforePrefix,
                                                          style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.formatWidth = formatWidth
        numberFormatter.paddingCharacter = paddingCharacter
        numberFormatter.paddingPosition = paddingPosition
        return sk_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func sk_maximumIntegerDigitsAndMinimumIntegerDigits(value: String,
                                                               maximumIntegerDigits: Int,
                                                               minimumIntegerDigits: Int,
                                                               style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.maximumIntegerDigits = maximumIntegerDigits
        numberFormatter.minimumIntegerDigits = minimumIntegerDigits
        return sk_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func sk_maximumFractionDigitsAndMinimumFractionDigits(value: String,
                                                                 maximumFractionDigits: Int,
                                                                 minimumFractionDigits: Int) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        return sk_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func sk_maximumIntegerDigitsAndMinimumIntegerDigits(value: String,
                                                               positivePrefix: String,
                                                               positiveSuffix: String,
                                                               style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positivePrefix = positivePrefix
        numberFormatter.positiveSuffix = positiveSuffix
        return sk_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func sk_positiveFormat(value: String,
                                  positiveFormat: String,
                                  style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positiveFormat = positiveFormat
        return sk_customFormatter(value: value, numberFormatter: numberFormatter)
    }
}
