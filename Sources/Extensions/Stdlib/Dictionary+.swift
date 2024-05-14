import UIKit

public extension Dictionary {

    init<S: Sequence>(grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }
}

public extension Dictionary {

    subscript(path path: [Key]) -> Any? {
        get {
            guard !path.isEmpty else { return nil }
            var result: Any? = self
            for key in path {
                if let element = (result as? [Key: Any])?[key] {
                    result = element
                } else {
                    return nil
                }
            }
            return result
        }
        set {
            if let first = path.first {
                if path.count == 1, let new = newValue as? Value {
                    return self[first] = new
                }
                if var nested = self[first] as? [Key: Any] {
                    nested[path: Array(path.dropFirst())] = newValue
                    return self[first] = nested as? Value
                }
            }
        }
    }
}


public extension Dictionary {

    func xx_array<V>(_ map: (Key, Value) -> V) -> [V] {
        self.map(map)
    }

    func xx_allKeys() -> [Key] {
        keys.shuffled()
    }

    func xx_allValues() -> [Value] {
        values.shuffled()
    }

    func xx_has(key: Key) -> Bool {
        index(forKey: key) != nil
    }

    mutating func xx_removeAll(keys: some Sequence<Key>) {
        keys.forEach { self.removeValue(forKey: $0) }
    }

    @discardableResult
    mutating func xx_removeValueForRandomKey() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return self.removeValue(forKey: randomKey)
    }

    func xx_mapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        try [K: V](uniqueKeysWithValues: self.map(transform))
    }

    func xx_compactMapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)?) rethrows -> [K: V] {
        try [K: V](uniqueKeysWithValues: compactMap(transform))
    }

    func xx_pick(keys: [Key]) -> [Key: Value] {
        return keys.reduce(into: [Key: Value]()) { result, item in
            result[item] = self[item]
        }
    }
}

public extension Dictionary where Value: Equatable {

    func xx_keys(forValue value: Value) -> [Key] {
        keys.filter { self[$0] == value }
    }
}

public extension Dictionary where Key: StringProtocol {

    mutating func xx_lowercaseAllKeys() {
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
}

public extension Dictionary {

    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }

    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }

    static func - (lhs: [Key: Value], keys: some Sequence<Key>) -> [Key: Value] {
        var result = lhs
        result.xx_removeAll(keys: keys)
        return result
    }

    static func -= (lhs: inout [Key: Value], keys: some Sequence<Key>) {
        lhs.xx_removeAll(keys: keys)
    }
}
