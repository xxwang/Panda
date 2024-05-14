import UIKit

public extension IndexPath {
    func xx_string() -> String {
        return String(format: "{section: %d, row: %d}", section, row)
    }
}
