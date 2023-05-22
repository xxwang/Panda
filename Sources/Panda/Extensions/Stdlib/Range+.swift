//
//  Range+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import Foundation

// MARK: - Range<String.Index>
public extension Range<String.Index> {
    /// `Range<String.Index>`转`NSRange`
    /// - Parameter string:字符串
    /// - Returns:`NSRange`
    func toNSRange(in string: String) -> NSRange {
        NSRange(self, in: string)
    }
}
