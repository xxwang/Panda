//
//  Character++.swift
//
//
//  Created by xxwang on 2023/5/20.
//

import Foundation

extension Character: Pandaable {}

// MARK: - 类型转换
public extension PandaEx where Base == Character {

    /// 从`Character`转换成`String`
    /// - Returns: `String`
    func toString() -> String {
        return String(self.base)
    }
    
}

// MARK: - 静态方法
public extension PandaEx where Base == Character {

    /// 随机产生一个字符`(a-z A-Z 0-9)`
    /// - Returns: 随机`Character`
    static func random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}
