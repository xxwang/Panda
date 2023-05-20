//
//  Character+.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

import Foundation

public extension Character {
    
    /// 从字符转换成Int
    func toInt() -> Int {
        var intValue = 0
        for scalar in String(self).unicodeScalars {
            intValue = Int(scalar.value)
        }
        return intValue
    }

    /// 从字符转换成字符串
    func toString() -> String {String(self)}
}

public extension Character {
    /// 随机产生一个字符`(a-z A-Z 0-9)`
    /// - Returns: 随机`Character`
    static func random() -> Character {
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}
