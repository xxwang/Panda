import UIKit

public extension IndexPath {
    func sk_string() -> String {
        return String(format: "{section: %d, row: %d}", section, row)
    }
}
