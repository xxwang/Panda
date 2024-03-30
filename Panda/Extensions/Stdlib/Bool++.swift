//
//  Bool++.swift
//
//
//  Created by xxwang on 2023/5/20.
//

import Foundation

// MARK: - 类型转换
public extension Bool {
    /// `Bool`转`Int`
    /// - Returns: `Int`
    func toInt() -> Int {
        self ? 1 : 0
    }

    /// `Bool`转`String`
    /// - Returns: `String`
    func toString() -> String {
        self ? "true" : "false"
    }
}
