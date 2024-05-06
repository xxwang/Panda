import Foundation

public extension NSNumber {
    func pd_formatter(style: NumberFormatter.Style = .none,
                      separator: String = ",",
                      mode: NumberFormatter.RoundingMode = .halfEven,
                      minDecimalPlaces: Int = 0,
                      maxDecimalPlaces: Int = 0) -> String?
    {
        let formater = NumberFormatter()
        formater.numberStyle = style
        formater.groupingSeparator = separator
        formater.roundingMode = mode
        formater.minimumFractionDigits = minDecimalPlaces
        formater.maximumFractionDigits = maxDecimalPlaces

        return formater.string(from: self)
    }
}
