import Foundation

public extension MutableCollection {

    mutating func sk_assignToAll<Value>(value: Value, by keyPath: WritableKeyPath<Element, Value>) {
        for idx in indices {
            self[idx][keyPath: keyPath] = value
        }
    }
}


public extension MutableCollection where Self: RandomAccessCollection {

    mutating func sk_sort<T>(by keyPath: KeyPath<Element, T>, with compare: (T, T) -> Bool) {
        sort { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    mutating func sk_sort(by keyPath: KeyPath<Element, some Comparable>) {
        sort { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    mutating func sk_sort(by keyPath1: KeyPath<Element, some Comparable>,
                          and keyPath2: KeyPath<Element, some Comparable>)
    {
        sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    mutating func sk_sort(by keyPath1: KeyPath<Element, some Comparable>,
                          and keyPath2: KeyPath<Element, some Comparable>,
                          and keyPath3: KeyPath<Element, some Comparable>)
    {
        sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            if $0[keyPath: keyPath2] != $1[keyPath: keyPath2] {
                return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
            }
            return $0[keyPath: keyPath3] < $1[keyPath: keyPath3]
        }
    }
}
