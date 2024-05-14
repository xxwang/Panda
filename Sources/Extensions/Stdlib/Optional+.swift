import Foundation

extension Optional {

    func xx_run(_ block: (Wrapped) -> Void) {
        _ = map(block)
    }

    func xx_expect(_ fatalErrorDescription: String) -> Wrapped {
        guard let value = self else { fatalError(fatalErrorDescription) }
        return value
    }
}

public extension Optional {

    func xx_or(_ default: Wrapped) -> Wrapped { self ?? `default` }

    func xx_or(else: @autoclosure () -> Wrapped) -> Wrapped { self ?? `else`() }

    func xx_or(else: () -> Wrapped) -> Wrapped { self ?? `else`() }

    func xx_or(throw exception: Error) throws -> Wrapped {
        guard let unBase = self else { throw exception }
        return unBase
    }
}

public extension Optional {

    func xx_on(some: () throws -> Void) rethrows { if self != nil { try some() }}

    func xx_on(none: () throws -> Void) rethrows { if self == nil { try none() }}
}

public extension Optional where Wrapped: Collection {

    var xx_isNilOrEmpty: Bool {
        guard let collection = self else { return true }
        return collection.isEmpty
    }
}

public extension Optional where Wrapped: Error {

    func xx_or(_ else: (Error) -> Void) {
        guard let error = self else { return }
        `else`(error)
    }
}

infix operator ??=: AssignmentPrecedence
infix operator ?=: AssignmentPrecedence


public extension Optional {

    @inlinable static func ??= (lhs: inout Optional, rhs: Optional) {
        guard let rhs else { return }
        lhs = rhs
    }

    @inlinable static func ?= (lhs: inout Optional, rhs: @autoclosure () -> Optional) {
        if lhs == nil { lhs = rhs() }
    }
}

public extension Optional where Wrapped: RawRepresentable, Wrapped.RawValue: Equatable {

    @inlinable static func == (lhs: Optional, rhs: Wrapped.RawValue?) -> Bool {
        return lhs?.rawValue == rhs
    }

    @inlinable static func == (lhs: Wrapped.RawValue?, rhs: Optional) -> Bool {
        return lhs == rhs?.rawValue
    }

    @inlinable static func != (lhs: Optional, rhs: Wrapped.RawValue?) -> Bool {
        return lhs?.rawValue != rhs
    }

    @inlinable static func != (lhs: Wrapped.RawValue?, rhs: Optional) -> Bool {
        return lhs != rhs?.rawValue
    }
}
