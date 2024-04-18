import Foundation

// MARK: - 类型转换
public extension Bool {
    
    /// `Bool`转`Int`
    /// - Returns: `Int`
    func pd_Int() -> Int {
        return self ? 1 : 0
    }
    
    /// `Bool`转`String`
    /// - Returns: `String`
    func pd_String() -> String {
        return self ? "true" : "false"
    }
}
