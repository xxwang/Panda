import Foundation

public extension RangeReplaceableCollection {

    init(expression: @autoclosure () throws -> Element, count: Int) rethrows {
        self.init()
        if count > 0 {
            reserveCapacity(count)
            while self.count < count {
                try append(expression())
            }
        }
    }
}


public extension RangeReplaceableCollection {

    subscript(offset: Int) -> Element {
        get { self[index(startIndex, offsetBy: offset)] }
        set {
            let offsetIndex = index(startIndex, offsetBy: offset)
            replaceSubrange(offsetIndex ..< index(after: offsetIndex), with: [newValue])
        }
    }

    subscript<R>(range: R) -> SubSequence where R: RangeExpression, R.Bound == Int {
        get {
            let indexRange = range.relative(to: 0 ..< count)
            return self[index(startIndex, offsetBy: indexRange.lowerBound) ..< index(startIndex, offsetBy: indexRange.upperBound)]
        }
        set {
            let indexRange = range.relative(to: 0 ..< count)
            replaceSubrange(
                index(startIndex, offsetBy: indexRange.lowerBound) ..< index(startIndex, offsetBy: indexRange.upperBound),
                with: newValue
            )
        }
    }
}

public extension RangeReplaceableCollection {

    func pd_rotated(by places: Int) -> Self {
        var copy = self
        return copy.pd_rotate(by: places)
    }

    @discardableResult
    mutating func pd_rotate(by places: Int) -> Self {
        guard places != 0 else { return self }
        let placesToMove = places % count
        if placesToMove > 0 {
            let range = index(endIndex, offsetBy: -placesToMove)...
            let slice = self[range]
            removeSubrange(range)
            insert(contentsOf: slice, at: startIndex)
        } else {
            let range = startIndex ..< index(startIndex, offsetBy: -placesToMove)
            let slice = self[range]
            removeSubrange(range)
            append(contentsOf: slice)
        }
        return self
    }

    @discardableResult
    mutating func pd_removeFirst(where condition: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try self.firstIndex(where: condition) else { return nil }
        return self.remove(at: index)
    }

    @discardableResult
    mutating func pd_removeRandomElement() -> Element? {
        guard let randomIndex = indices.randomElement() else { return nil }
        return self.remove(at: randomIndex)
    }

    @discardableResult
    mutating func pd_keep(while condition: (Element) throws -> Bool) rethrows -> Self {
        if let idx = try self.firstIndex(where: { try !condition($0) }) {
            removeSubrange(idx...)
        }
        return self
    }

    func pd_take(while condition: (Element) throws -> Bool) rethrows -> Self {
        try Self(self.prefix(while: condition))
    }

    func pd_skip(while condition: (Element) throws -> Bool) rethrows -> Self {
        guard let idx = try firstIndex(where: { try !condition($0) }) else { return Self() }
        return Self(self[idx...])
    }

    mutating func pd_removeDuplicates(keyPath path: KeyPath<Element, some Equatable>) {
        var items = [Element]()
        self.removeAll { element -> Bool in
            guard items.contains(where: { $0[keyPath: path] == element[keyPath: path] }) else {
                items.append(element)
                return false
            }
            return true
        }
    }

    mutating func pd_removeDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) {
        var set = Set<E>()
        removeAll { !set.insert($0[keyPath: path]).inserted }
    }

    mutating func pd_appendIfNonNil(_ newElement: Element?) {
        guard let newElement else { return }
        self.append(newElement)
    }

    mutating func pd_appendIfNonNil<S>(contentsOf newElements: S?) where Element == S.Element, S: Sequence {
        guard let newElements else { return }
        self.append(contentsOf: newElements)
    }
}
