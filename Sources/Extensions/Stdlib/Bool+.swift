import Foundation

// MARK: - 类型转换
public extension Bool {
    /// `Bool`转`Int`
    /// - Returns: `Int`
    func pd_int() -> Int {
        return self ? 1 : 0
    }

    /// `Bool`转`String`
    /// - Returns: `String`
    func pd_string() -> String {
        return self ? "true" : "false"
    }
}
