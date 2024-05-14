import Foundation

public extension NumberFormatter {
    static func xx_numberFormatting(value: Float, style: NumberFormatter.Style = .none) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: value), number: style)
    }

    static func xx_numberFormatting(value: Double, style: NumberFormatter.Style = .none) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: value), number: style)
    }

    static func xx_stringFormattingNumber(value: String, style: NumberFormatter.Style = .none) -> String? {
        guard let number = NumberFormatter().number(from: value) else { return nil }
        return NumberFormatter.localizedString(from: number, number: style)
    }

    static func xx_customFormatter(value: String, numberFormatter: NumberFormatter) -> String? {
        guard let number = NumberFormatter().number(from: value) else { return nil }
        guard let formatValue = numberFormatter.string(from: number) else { return nil }
        return formatValue
    }

    static func xx_groupingSeparatorAndSize(value: String,
                                            separator: String,
                                            size: Int,
                                            style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = separator
        numberFormatter.groupingSize = size
        return xx_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func xx_formatWidthPaddingCharacterAndPosition(value: String,
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
        return xx_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func xx_maximumIntegerDigitsAndMinimumIntegerDigits(value: String,
                                                               maximumIntegerDigits: Int,
                                                               minimumIntegerDigits: Int,
                                                               style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.maximumIntegerDigits = maximumIntegerDigits
        numberFormatter.minimumIntegerDigits = minimumIntegerDigits
        return xx_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func xx_maximumFractionDigitsAndMinimumFractionDigits(value: String,
                                                                 maximumFractionDigits: Int,
                                                                 minimumFractionDigits: Int) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        return xx_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func xx_maximumIntegerDigitsAndMinimumIntegerDigits(value: String,
                                                               positivePrefix: String,
                                                               positiveSuffix: String,
                                                               style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positivePrefix = positivePrefix
        numberFormatter.positiveSuffix = positiveSuffix
        return xx_customFormatter(value: value, numberFormatter: numberFormatter)
    }

    static func xx_positiveFormat(value: String,
                                  positiveFormat: String,
                                  style: NumberFormatter.Style = .none) -> String?
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positiveFormat = positiveFormat
        return xx_customFormatter(value: value, numberFormatter: numberFormatter)
    }
}
