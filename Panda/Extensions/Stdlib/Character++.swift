//
//  Character++.swift
//
//
//  Created by xxwang on 2023/5/20.
//

import Foundation

// MARK: - 类型转换
public extension Character {
    /// 从`Character`转换成`Int`
    /// - Returns: `Int`
    func toInt() -> Int {
        return self.toString().toInt()
    }

    /// 从`Character`转换成`String`
    /// - Returns: `String`
    func toString() -> String {
        return String(self)
    }
}

// MARK: - 静态方法
public extension Character {
    /// 随机产生一个字符`(a-z A-Z 0-9)`
    /// - Returns: 随机`Character`
    static func random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}
