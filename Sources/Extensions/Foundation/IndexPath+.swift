import UIKit

public extension IndexPath {
    func pd_string() -> String {
        return String(format: "{section: %d, row: %d}", section, row)
    }
}
