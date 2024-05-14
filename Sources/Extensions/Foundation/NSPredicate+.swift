import Foundation

public extension NSPredicate {
    func xx_not() -> NSCompoundPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: self)
    }

    func xx_and(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
    }

    func xx_or(_ predicate: NSPredicate) -> NSCompoundPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
    }
}

public extension NSPredicate {
    static prefix func ! (rhs: NSPredicate) -> NSCompoundPredicate {
        return rhs.xx_not()
    }

    static func + (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.xx_and(rhs)
    }

    static func | (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs.xx_or(rhs)
    }

    static func - (lhs: NSPredicate, rhs: NSPredicate) -> NSCompoundPredicate {
        return lhs + !rhs
    }
}
