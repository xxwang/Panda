import UIKit


public extension Array {

    subscript(indexs input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < count && i >= 0, "index out of range")
                result.append(self[i])
            }
            return result
        }

        set {
            for (index, i) in input.enumerated() {
                assert(i < count && i >= 0, "index out of range")
                self[i] = newValue[index]
            }
        }
    }
}


public extension Array {

    func xx_value(of index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    mutating func xx_append(_ elements: [Element]) {
        for element in elements {
            self.append(element)
        }
    }

    func xx_split(where condition: (Element, Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = self.isEmpty ? [] : [[self[0]]]
        for (previous, current) in zip(self, dropFirst()) {
            if condition(previous, current) {
                result[result.endIndex - 1].append(current)
            } else {
                result.append([current])
            }
        }
        return result
    }

    func xx_split(size: Int) -> [[Element]] {
        if self.count <= size {
            return [self]
        }

        let subCount = self.count % size == 0 ? (self.count / size) : (self.count / size + 1)
        var superArray: [[Element]] = []

        for i in 0 ..< subCount {
            var subArr: [Element] = []
            for j in 0 ..< size {
                let index = i * size + j
                if index < self.count {
                    let ele = self[index]
                    subArr.append(ele)
                } else {
                    break
                }
            }
            superArray.append(subArr)
        }
        return superArray
    }

    mutating func xx_prepend(_ newElement: Element) {
        self.insert(newElement, at: 0)
    }

    mutating func xx_swap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex ..< endIndex ~= index else { return }
        guard startIndex ..< endIndex ~= otherIndex else { return }
        self.swapAt(index, otherIndex)
    }
}

public extension Array {

    func xx_sorted<T: Hashable>(like otherArray: [T], keyPath: KeyPath<Element, T>) -> [Element] {
        let dict = otherArray.enumerated().reduce(into: [:]) { $0[$1.element] = $1.offset }
        return sorted {
            guard let thisIndex = dict[$0[keyPath: keyPath]] else { return false }
            guard let otherIndex = dict[$1[keyPath: keyPath]] else { return true }
            return thisIndex < otherIndex
        }
    }
}

public extension [String] {

    func xx_string(separator: String = "") -> String {
        self.joined(separator: separator)
    }
}

public extension Array where Element: Equatable {

    func xx_indexes(_ item: Element) -> [Int] {
        var indexes = [Int]()
        for index in 0 ..< count where self[index] == item {
            indexes.append(index)
        }
        return indexes
    }

    func xx_firstIndex(_ item: Element) -> Int? {
        for (index, value) in enumerated() where value == item {
            return index
        }
        return nil
    }

    func xx_lastIndex(_ item: Element) -> Int? {
        return self.xx_indexes(item).last
    }

    func xx_last<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        last { $0[keyPath: keyPath] == value }
    }

    mutating func xx_remove(_ object: Element) {
        for idx in self.xx_indexes(object).reversed() {
            remove(at: idx)
        }
    }

    @discardableResult
    mutating func xx_remove(_ element: Element, isRepeat: Bool = true) -> Array {
        var removeIndexs: [Int] = []

        for i in 0 ..< count {
            if self[i] == element {
                removeIndexs.append(i)
                if !isRepeat { break }
            }
        }

        for index in removeIndexs.reversed() {
            remove(at: index)
        }
        return self
    }

    @discardableResult
    mutating func xx_removeArray(_ elements: [Element], isRepeat: Bool = true) -> Array {
        for element in elements {
            if contains(element) { self.xx_remove(element, isRepeat: isRepeat) }
        }
        return self
    }

    @discardableResult
    mutating func xx_removeAll(_ item: Element) -> [Element] {
        removeAll(where: { $0 == item })
        return self
    }

    @discardableResult
    mutating func xx_removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }

    @discardableResult
    mutating func xx_removeDuplicates() -> [Element] {
        self = reduce(into: [Element]()) {
            if !$0.contains($1) { $0.append($1) }
        }
        return self
    }

    func xx_withoutDuplicates() -> [Element] {
        reduce(into: [Element]()) {
            if !$0.contains($1) { $0.append($1) }
        }
    }

    func xx_withoutDuplicates(keyPath path: KeyPath<Element, some Equatable>) -> [Element] {
        reduce(into: [Element]()) { result, element in
            if !result.contains(where: { $0[keyPath: path] == element[keyPath: path] }) {
                result.append(element)
            }
        }
    }

    func xx_withoutDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        var set = Set<E>()
        return filter { set.insert($0[keyPath: path]).inserted }
    }
}

public extension Array where Element: NSObjectProtocol {
    @discardableResult
    mutating func xx_remove(object: NSObjectProtocol, isRepeat: Bool = true) -> Array {
        var removeIndexs: [Int] = []
        for i in 0 ..< count {
            if self[i].isEqual(object) {
                removeIndexs.append(i)
                if !isRepeat { break }
            }
        }
        for index in removeIndexs.reversed() {
            remove(at: index)
        }
        return self
    }

    @discardableResult
    mutating func xx_removeArray(objects: [NSObjectProtocol], isRepeat: Bool = true) -> Array {
        for object in objects {
            if contains(where: { $0.isEqual(object) }) {
                self.xx_remove(object: object, isRepeat: isRepeat)
            }
        }
        return self
    }
}

public extension Array where Element: NSAttributedString {

    func xx_joined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = first else { return "".xx_nsAttributedString() }
        return dropFirst()
            .reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
                result.append(separator)
                result.append(element)
            }
    }

    func xx_joined(separator: String) -> NSAttributedString {
        let separator = NSAttributedString(string: separator)
        return xx_joined(separator: separator)
    }
}
