import Foundation

public extension NSPredicate {
    func pd_not() -> NSCompoundPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self)
    }

    func pd_and(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
    }

    func pd_or(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
    }
}

public extension NSPredicate {
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        return rhs.pd_not()
    }

    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.pd_and(rhs)
    }

    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.pd_or(rhs)
    }

    static func - (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs + !rhs
    }
}
