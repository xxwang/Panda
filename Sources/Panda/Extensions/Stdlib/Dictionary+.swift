//
//  Dictionary+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 构造方法
public extension Dictionary {
    /// 根据给定的`KeyPath`分组的给定序列创建字典
    /// - Parameters:
    ///   - sequence:正在分组的序列
    ///   - keypath:分组依据的`KeyPath`
    init<S: Sequence>(grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }
}

// MARK: - 下标
public extension Dictionary {
    /// 从嵌套字典中深度获取或设置值
    ///
    ///     var dict =  ["key":["key1":["key2":"value"]]]
    ///     dict[path:["key", "key1", "key2"]] = "newValue"
    ///     dict[path:["key", "key1", "key2"]] -> "newValue"
    ///
    /// - Note:取值是迭代的,而设置是递归的
    /// - Parameter path:指向所需值的键数组
    /// - Returns:如果不能找到KeyPath对应的值,返回nil
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

// MARK: - 转换
public extension Dictionary {
    /// 字典转`Data`
    /// - Parameters prettify:是否美化格式
    /// - Returns:JSON格式的Data(可选类型)
    func toData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options: JSONSerialization.WritingOptions = (prettify == true) ? .prettyPrinted : .init()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }

    /// 字典转`JSON`字符串
    /// - Parameters prettify:是否美化格式
    /// - Returns:JSON字符串(可选类型)
    func toJSONString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options: JSONSerialization.WritingOptions = (prettify == true) ? .prettyPrinted : .init()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/", options: .caseInsensitive, range: nil)
    }
}

// MARK: - 方法
public extension Dictionary {
    /// 字典的key或者value组成的数组
    /// - Parameter map:`map`
    /// - Returns:数组
    func array<V>(_ map: (Key, Value) -> V) -> [V] {
        self.map(map)
    }

    /// 字典里面所有的key(打乱顺序)
    /// - Returns:`key` 数组
    func allKeys() -> [Key] {
        keys.shuffled()
    }

    /// 字典里面所有的`value`(打乱顺序)
    /// - Returns:`value` 数组
    func allValues() -> [Value] {
        values.shuffled()
    }

    /// 检查字典中是否存在`key`
    ///
    ///     let dict:[String:Any] = ["testKey":"testValue", "testArrayKey":[1, 2, 3, 4, 5]]
    ///     dict.has(key:"testKey") -> true
    ///     dict.has(key:"anotherKey") -> false
    /// - Parameters key:要搜索的key
    /// - Returns:如果字典中存在键,则返回true
    func has(key: Key) -> Bool {
        index(forKey: key) != nil
    }

    /// 从字典中删除`keys`参数中包含的所有键
    ///
    ///     var dict :[String:String] = ["key1" :"value1", "key2" :"value2", "key3" :"value3"]
    ///     dict.removeAll(keys:["key1", "key2"])
    ///     dict.keys.contains("key3") -> true
    ///     dict.keys.contains("key1") -> false
    ///     dict.keys.contains("key2") -> false
    /// - Parameters keys:要删除的键
    mutating func removeAll(keys: some Sequence<Key>) {
        keys.forEach { removeValue(forKey: $0) }
    }

    /// 从字典中删除随机键的值
    @discardableResult
    mutating func removeValueForRandomKey() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return removeValue(forKey: randomKey)
    }

    /// 返回一个字典,其中包含将给定闭包映射到序列元素的结果
    /// - Parameter transform:映射闭包`transform`接受该序列的一个元素作为其参数,并返回相同或不同类型的转换值
    /// - Returns:包含此序列的转换元素的字典
    func mapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        try [K: V](uniqueKeysWithValues: map(transform))
    }

    /// 返回一个字典,其中包含使用该序列的每个元素调用给定转换的非'nil'结果
    /// - Parameter transform:接受此序列的元素作为参数并返回可选值的闭包
    /// - Returns:对序列中的每个元素调用“transform”的非“nil”结果的字典
    func compactMapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)?) rethrows -> [K: V] {
        try [K: V](uniqueKeysWithValues: compactMap(transform))
    }

    /// 使用指定键创建新词典
    ///
    ///     var dict =  ["key1":1, "key2":2, "key3":3, "key4":4]
    ///     dict.pick(keys:["key1", "key3", "key4"]) -> ["key1":1, "key3":3, "key4":4]
    ///     dict.pick(keys:["key2"]) -> ["key2":2]
    /// - Parameters keys:将作为结果字典中条目的键数组
    /// - Returns:仅包含指定键的新字典.如果所有键都不存在,将返回一个空字典
    func pick(keys: [Key]) -> [Key: Value] {
        keys.reduce(into: [Key: Value]()) { result, item in
            result[item] = self[item]
        }
    }
}

// MARK: - Value:Equatable
public extension Dictionary where Value: Equatable {
    /// 返回字典中具有给定值的所有键的数组
    ///
    ///     let dict = ["key1":"value1", "key2":"value1", "key3":"value2"]
    ///     dict.keys(forValue:"value1") -> ["key1", "key2"]
    ///     dict.keys(forValue:"value2") -> ["key3"]
    ///     dict.keys(forValue:"value3") -> []
    /// - Parameters value:要提取键的值
    /// - Returns:包含具有给定值的键的数组
    func keys(forValue value: Value) -> [Key] {
        keys.filter { self[$0] == value }
    }
}

// MARK: - Key:StringProtocol
public extension Dictionary where Key: StringProtocol {
    /// 将字典中的所有键小写
    ///
    ///     var dict = ["tEstKeY":"value"]
    ///     dict.lowercaseAllKeys()
    ///     print(dict) // prints "["testkey":"value"]"
    ///
    mutating func lowercaseAllKeys() {
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
}

// MARK: - 运算符重载
public extension Dictionary {
    /// 合并两个字典的键/值
    ///
    ///     let dict:[String:String] = ["key1":"value1"]
    ///     let dict2:[String:String] = ["key2":"value2"]
    ///     let result = dict + dict2
    ///     result["key1"] -> "value1"
    ///     result["key2"] -> "value2"
    /// - Parameters:
    ///   - lhs:字典
    ///   - rhs:字典
    /// - Returns:包含两个字典的键和值的字典
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }

    /// 将第二个字典中的键和值附加到第一个字典中
    ///
    ///     var dict:[String:String] = ["key1":"value1"]
    ///     let dict2:[String:String] = ["key2":"value2"]
    ///     dict += dict2
    ///     dict["key1"] -> "value1"
    ///     dict["key2"] -> "value2"
    /// - Parameters:
    ///   - lhs:字典
    ///   - rhs:字典
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }

    /// 从字典中删除序列中包含的键(返回新字典)
    ///
    ///     let dict:[String:String] = ["key1":"value1", "key2":"value2", "key3":"value3"]
    ///     let result = dict-["key1", "key2"]
    ///     result.keys.contains("key3") -> true
    ///     result.keys.contains("key1") -> false
    ///     result.keys.contains("key2") -> false
    /// - Parameters:
    ///   - lhs:字典
    ///   - keys:包含要删除的key的数组
    /// - Returns:删除键的新词典
    static func - (lhs: [Key: Value], keys: some Sequence<Key>) -> [Key: Value] {
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }

    /// 从字典中删除序列中包含的键
    ///
    ///     var dict:[String:String] = ["key1":"value1", "key2":"value2", "key3":"value3"]
    ///     dict-=["key1", "key2"]
    ///     dict.keys.contains("key3") -> true
    ///     dict.keys.contains("key1") -> false
    ///     dict.keys.contains("key2") -> false
    /// - Parameters:
    ///   - lhs:字典
    ///   - keys:包含要删除的key的数组
    static func -= (lhs: inout [Key: Value], keys: some Sequence<Key>) {
        lhs.removeAll(keys: keys)
    }
}
