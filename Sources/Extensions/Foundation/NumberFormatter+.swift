import Foundation

public extension NumberFormatter {
    static func pd_numberFormatting(value: Float, style: NumberFormatter.Style = .none) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: value), number: style)
    }

    static func pd_numberFormatting(value: Double, style: NumberFormatter.Style = .none) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: value), number: style)
    }

    static func pd_stringFormattingNumber(value: String, style: NumberFormatter.Style = .none) -> String? {
        guard let number = NumberFormatter().number(from: value) else { return nil }
        return NumberFormatter.localizedString(from: number, number: style)
    }

    static func pd_customFormatter(value: String, numberFormatter: NumberFormatter) -> String? {
        guard let number = NumberFormatter().number(from: value) else { return nil }
        guard let formatValue = numberFormatter.string(from: number) else { return nil }
        return formatValue
    }

    static func pd_groupingSeparatorAndSize(value: String,
                                            separator: String,
                                            size: Int,
                                            style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = separator
        numberFormatter.groupingSize = size
        return pd_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func pd_formatWidthPaddingCharacterAndPosition(value: String,
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
        return pd_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func pd_maximumIntegerDigitsAndMinimumIntegerDigits(value: String,
                                                               maximumIntegerDigits: Int,
                                                               minimumIntegerDigits: Int,
                                                               style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.maximumIntegerDigits = maximumIntegerDigits
        numberFormatter.minimumIntegerDigits = minimumIntegerDigits
        return pd_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func pd_maximumFractionDigitsAndMinimumFractionDigits(value: String,
                                                                 maximumFractionDigits: Int,
                                                                 minimumFractionDigits: Int) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        return pd_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func pd_maximumIntegerDigitsAndMinimumIntegerDigits(value: String,
                                                               positivePrefix: String,
                                                               positiveSuffix: String,
                                                               style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positivePrefix = positivePrefix
        numberFormatter.positiveSuffix = positiveSuffix
        return pd_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func pd_positiveFormat(value: String,
                                  positiveFormat: String,
                                  style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positiveFormat = positiveFormat
        return pd_customFormatter(value: value, numberFormatter: numberFormatter)
    }
}
