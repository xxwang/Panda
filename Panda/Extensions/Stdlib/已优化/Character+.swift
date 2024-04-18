import Foundation

// MARK: - 类型转换
public extension Character {

    /// 从`Character`转换成`String`
    /// - Returns: `String`
    func pd_String() -> String {
        return String(self)
    }
    
}

// MARK: - 静态方法
public extension Character {
    /// 随机产生一个字符`(a-z A-Z 0-9)`
    /// - Returns: 随机`Character`
    static func pd_random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
    
}

