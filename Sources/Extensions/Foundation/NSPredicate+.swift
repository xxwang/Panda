import Foundation

public extension NSPredicate {
    func sk_not() -> NSCompoundPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self)
    }

    func sk_and(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
    }

    func sk_or(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
    }
}

public extension NSPredicate {
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        return rhs.sk_not()
    }

    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.sk_and(rhs)
    }

    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.sk_or(rhs)
    }

    static func - (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs + !rhs
    }
}
