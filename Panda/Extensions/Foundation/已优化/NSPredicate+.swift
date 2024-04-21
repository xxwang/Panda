import Foundation

// MARK: - 方法
public extension NSPredicate {
    /// 创建一个`NOT`复合谓词
    /// - Returns: 结果复合谓词
    func pd_not() -> NSCompoundPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self)
    }

    /// 创建一个`AND`复合谓词
    /// - Parameter predicate: 谓词
    /// - Returns: 结果复合谓词
    func pd_and(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
    }

    /// 创建一个`OR`复合谓词
    /// - Parameter predicate: 谓词
    /// - Returns: 结果复合谓词
    func pd_or(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
    }
}

// MARK: - 运算符
public extension NSPredicate {
    /// 创建一个`NOT`复合谓词
    /// - Parameter rhs: `NSPredicate`
    /// - Returns: 结果复合谓词
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        return rhs.pd_not()
    }

    /// 创建一个`AND`复合谓词
    /// - Parameters:
    ///   - lhs: `NSPredicate`
    ///   - rhs: `NSPredicate`
    /// - Returns: 结果复合谓词
    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.pd_and(rhs)
    }

    /// 返创建一个`OR`复合谓词
    ///
    /// - Parameters:
    ///   - lhs: `NSPredicate`
    ///   - rhs: `NSPredicate`
    /// - Returns: 结果复合谓词
    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.pd_or(rhs)
    }

    /// 从左值谓词中减去右值谓词
    /// - Parameters:
    ///   - lhs: `NSPredicate`.
    ///   - rhs: `NSPredicate`.
    /// - Returns: 结果复合谓词
    static func - (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs + !rhs
    }
}
