//
//  NSPredicate+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import Foundation

// MARK: - 方法
public extension NSPredicate {
    /// 谓词取反
    /// - Returns: `NSCompoundPredicate`
    func not() -> NSCompoundPredicate {
        NSCompoundPredicate(notPredicateWithSubpredicate: self)
    }

    /// 返回一个新的谓词,该谓词由参数构成,并将参数赋给谓词
    ///
    /// - Parameter predicate:`NSPredicate`.
    /// - Returns:`NSCompoundPredicate`.
    func and(_ predicate: NSPredicate) -> NSCompoundPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
    }

    /// 返回一个新的谓词,该谓词由参数或将参数赋给谓词构成
    ///
    /// - Parameter predicate:`NSPredicate`.
    /// - Returns:`NSCompoundPredicate`.
    func or(_ predicate: NSPredicate) -> NSCompoundPredicate {
        NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
    }
}

// MARK: - 运算符
public extension NSPredicate {
    /// 返回一个新的谓词,该谓词由不匹配谓词而形成
    /// - Parameters:rhs:`NSPredicate`
    /// - Returns:`NSCompoundPredicate`
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        rhs.not()
    }

    /// 返回一个新的谓词,该谓词由并将参数赋给谓词构成
    ///
    /// - Parameters:
    ///   - lhs:`NSPredicate`.
    ///   - rhs:`NSPredicate`.
    /// - Returns:`NSCompoundPredicate`
    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        lhs.and(rhs)
    }

    /// 返回一个新的谓词,该谓词由参数构成,或将参数赋给谓词
    ///
    /// - Parameters:
    ///   - lhs:`NSPredicate`.
    ///   - rhs:`NSPredicate`.
    /// - Returns:`NSCompoundPredicate`
    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        lhs.or(rhs)
    }

    /// 返回一个新的谓词,该谓词是通过将参数移除到谓词而形成的
    ///
    /// - Parameters:
    ///   - lhs:`NSPredicate`.
    ///   - rhs:`NSPredicate`.
    /// - Returns:`NSCompoundPredicate`
    static func - (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        lhs + !rhs
    }
}
