import Foundation

public extension Sequence {

    func xx_all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try !condition($0) }
    }

    func xx_none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try condition($0) }
    }

    func xx_any(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try contains { try condition($0) }
    }

    func xx_reject(where condition: (Element) throws -> Bool) rethrows -> [Element] {
        try filter { try !condition($0) }
    }

    func xx_count(where condition: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self where try condition(element) {
            count += 1
        }
        return count
    }

    func xx_forEachReversed(_ body: (Element) throws -> Void) rethrows {
        try reversed().forEach(body)
    }

    func xx_forEach(where condition: (Element) throws -> Bool, body: (Element) throws -> Void) rethrows {
        try lazy.filter(condition).forEach(body)
    }

    func xx_accumulate<U>(initial: U, next: (U, Element) throws -> U) rethrows -> [U] {
        var runningTotal = initial
        return try map { element in
            runningTotal = try next(runningTotal, element)
            return runningTotal
        }
    }

    func xx_filtered<T>(_ isIncluded: (Element) throws -> Bool, map transform: (Element) throws -> T) rethrows -> [T] {
        try lazy.filter(isIncluded).map(transform)
    }

    func xx_single(where condition: (Element) throws -> Bool) rethrows -> Element? {
        var singleElement: Element?
        for element in self where try condition(element) {
            guard singleElement == nil else {
                singleElement = nil
                break
            }
            singleElement = element
        }
        return singleElement
    }

    func xx_withoutDuplicates<T: Hashable>(transform: (Element) throws -> T) rethrows -> [Element] {
        var set = Set<T>()
        return try filter { try set.insert(transform($0)).inserted }
    }

    func xx_divided(by condition: (Element) throws -> Bool) rethrows -> (matching: [Element], nonMatching: [Element]) {
        var matching = [Element]()
        var nonMatching = [Element]()

        for element in self {
            try condition(element) ? matching.append(element) : nonMatching.append(element)
        }
        return (matching, nonMatching)
    }

    func xx_sorted<T>(by keyPath: KeyPath<Element, T>, with compare: (T, T) -> Bool) -> [Element] {
        sorted { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    func xx_sorted(by keyPath: KeyPath<Element, some Comparable>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    func xx_sorted(by keyPath1: KeyPath<Element, some Comparable>,
                   and keyPath2: KeyPath<Element, some Comparable>) -> [Element]
    {
        sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    func xx_sorted(by keyPath1: KeyPath<Element, some Comparable>,
                   and keyPath2: KeyPath<Element, some Comparable>,
                   and keyPath3: KeyPath<Element, some Comparable>) -> [Element]
    {
        sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            if $0[keyPath: keyPath2] != $1[keyPath: keyPath2] {
                return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
            }
            return $0[keyPath: keyPath3] < $1[keyPath: keyPath3]
        }
    }

    func xx_sum<T: AdditiveArithmetic>(for keyPath: KeyPath<Element, T>) -> T {
        reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }

    func xx_first<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        first { $0[keyPath: keyPath] == value }
    }
}

public extension Sequence where Element: Equatable {

    func xx_contains(_ elements: [Element]) -> Bool {
        elements.allSatisfy { contains($0) }
    }
}

public extension Sequence where Element: Hashable {

    func xx_contains(_ elements: [Element]) -> Bool {
        let set = Set(self)
        return elements.allSatisfy { set.contains($0) }
    }

    func xx_containsDuplicates() -> Bool {
        var set = Set<Element>()
        for element in self {
            if !set.insert(element).inserted {
                return true
            }
        }
        return false
    }

    func xx_duplicates() -> [Element] {
        var set = Set<Element>()
        var duplicates = Set<Element>()
        forEach {
            if !set.insert($0).inserted {
                duplicates.insert($0)
            }
        }
        return Array(duplicates)
    }
}

public extension Sequence where Element: AdditiveArithmetic {

    func xx_sum() -> Element {
        reduce(.zero, +)
    }
}