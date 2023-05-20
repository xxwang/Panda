//
//  IndexPath+.swift
//  
//
//  Created by 王斌 on 2023/5/20.
//

import Foundation

public extension IndexPath {
    
    /// 字符串描述
    /// - Returns: `String`
    func toString() -> String {
        String(format: "{section: %d, row: %d}", section, row)
    }
    
}
