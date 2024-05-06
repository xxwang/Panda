import Foundation

public extension Locale {
    func pd_is12hour() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = self

        let dateString = dateFormatter.string(from: Date())

        return dateString.contains(dateFormatter.amSymbol) || dateString.contains(dateFormatter.pmSymbol)
    }
}
