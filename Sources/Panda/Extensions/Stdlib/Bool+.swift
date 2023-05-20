//
//  Bool+.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

import Foundation

public extension Bool {
    
    /// Bool转Int
    func toInt() -> Int {
        self ? 1 : 0
    }

    /// Bool转字符串
    func toString() -> String {
        self ? "true" : "false"
    }
}
