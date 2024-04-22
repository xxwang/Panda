import UIKit

public extension IndexPath {
    /// 用字符串描述`IndexPath`
    /// - Returns: 字符串描述
    func pd_string() -> String {
        return String(format: "{section: %d, row: %d}", section, row)
    }
}
