//
//  Array+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 下标
public extension Array {

    /// 通过数组作为下标 获取/设置数据
    ///
    ///     let arr = [1,2,3,4,5,6]
    ///     let data = arr[[1,2,3]] // 1,2,3
    ///     arr[[1,2,3]] = [3,2,1] // [3,2,1,4,5,6]
    ///
    /// - Parameter input: 下标数组
    /// - Returns: ArraySlice<Element>
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count && i >= 0, "index out of range")
                result.append(self[i])
            }
            return result
        }
        
        set{
            for (index, i ) in input.enumerated() {
                assert(i < self.count && i >= 0, "index out of range")
                self[i] = newValue[index]
            }
        }
    }
}

// MARK: - Array
public extension Array {
    /// 数组JSON格式的Data
    /// - Parameter prettify:是否美化格式
    /// - Returns:JSON格式的Data(可选类型)
    func toData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options: JSONSerialization.WritingOptions = (prettify == true) ? .prettyPrinted : .init()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }

    /// 数组转成JSON字符串
    /// - Parameter prettify:是否美化格式
    /// - Returns:JSON字符串(可选类型)
    func toJSONString(prettify: Bool = false) -> String? {
        guard let data = toData(prettify: prettify) else { return nil }
        return String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/", options: .caseInsensitive, range: nil)
    }
}

// MARK: - 方法
public extension Array {
    /// 安全的取某个索引的值
    /// - Parameter index:索引
    /// - Returns:对应 index 的 value
    func value(of index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    /// 把一个数组添加到当前数组中
    /// - Parameter elements:数组
    mutating func append(_ elements: [Element]) {
        for element in elements { append(element) }
    }

    /// 找出数组中相邻元素(相邻元素放入数组中)
    /// - Parameter condition:条件闭包
    /// - Returns:二维数组
    func split(where condition: (Element, Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = isEmpty ? [] : [[self[0]]]
        for (previous, current) in zip(self, dropFirst()) {
            if condition(previous, current) {
                result.append([current])
            } else {
                result[result.endIndex - 1].append(current)
            }
        }
        return result
    }

    /// 插入元素到数组的头部
    ///
    ///     [2, 3, 4, 5].prepend(1) -> [1, 2, 3, 4, 5]
    ///     ["e", "l", "l", "o"].prepend("h") -> ["h", "e", "l", "l", "o"]
    /// - Parameter newElement:要插入的元素
    mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    /// 交换指定位置的两个元素
    ///
    ///     [1, 2, 3, 4, 5].swap(from:3, to:0) -> [4, 2, 3, 1, 5]
    ///     ["h", "e", "l", "l", "o"].swap(from:1, to:0) -> ["e", "h", "l", "l", "o"]
    /// - Parameters:
    ///   - index:第一个元素位置
    ///   - otherIndex:第二个元素位置
    mutating func swap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex ..< endIndex ~= index else { return }
        guard startIndex ..< endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
}

// MARK: - 排序
public extension Array {
    /// 根据指定的otherArray数组与keyPath对数组进行排序
    ///
    ///     [MyStruct(x:3), MyStruct(x:1), MyStruct(x:2)].sorted(like:[1, 2, 3], keyPath:\.x)
    ///     -> [MyStruct(x:1), MyStruct(x:2), MyStruct(x:3)]
    /// - Parameters:
    ///   - otherArray:按所需顺序包含元素的数组
    ///   - keyPath:指示数组应按其排序的属性
    /// - Returns:排序完成的数组
    func sorted<T: Hashable>(like otherArray: [T], keyPath: KeyPath<Element, T>) -> [Element] {
        let dict = otherArray.enumerated().reduce(into: [:]) { $0[$1.element] = $1.offset }
        return sorted {
            guard let thisIndex = dict[$0[keyPath: keyPath]] else { return false }
            guard let otherIndex = dict[$1[keyPath: keyPath]] else { return true }
            return thisIndex < otherIndex
        }
    }
}

// MARK: - Element == String
public extension [String] {
    /// 数组转字符转(数组的元素是 字符串),如:["1", "2", "3"] 连接器为 - ,那么转化后为 "1-2-3"
    /// - Parameter separator:连接器
    /// - Returns:转化后的字符串
    func toString(separator: String = "") -> String {
        joined(separator: separator)
    }
}

// MARK: - Element:Equatable
public extension Array where Element: Equatable {
    /// 获取数组中的指定元素的索引值
    /// - Parameter item:元素
    /// - Returns:索引值数组
    func indexes(_ item: Element) -> [Int] {
        var indexes = [Int]()
        for index in 0 ..< count where self[index] == item {
            indexes.append(index)
        }
        return indexes
    }

    /// 获取元素首次出现的位置
    /// - Parameter item:元素
    /// - Returns:索引值
    func firstIndex(_ item: Element) -> Int? {
        for (index, value) in enumerated() where value == item { return index }
        return nil
    }

    /// 获取元素最后出现的位置
    /// - Parameter item:元素
    /// - Returns:索引值
    func lastIndex(_ item: Element) -> Int? {
        indexes(item).last
    }

    /// 返回序列中在指定路径中==`value`的最后一个元素
    /// - Parameters:
    ///   - keyPath: 要比较的`value`所在的路径
    ///   - value: 要比较的`value`
    /// - Returns: 返回符合条件的元素(没有返回`nil`)
    func last<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        last { $0[keyPath: keyPath] == value }
    }

    /// 删除数组中的指定元素
    /// - Parameter object:元素
    mutating func remove(_ object: Element) {
        for idx in indexes(object).reversed() { remove(at: idx) }
    }

    /// 删除数组的中的元素(可删除第一个出现的或者删除全部出现的)
    /// - Parameters:
    ///   - element:要删除的元素
    ///   - isRepeat:是否删除重复的元素
    @discardableResult
    mutating func remove(_ element: Element, isRepeat: Bool = true) -> Array {
        var removeIndexs: [Int] = []

        for i in 0 ..< count {
            if self[i] == element {
                removeIndexs.append(i)
                if !isRepeat { break }
            }
        }
        // 倒序删除
        for index in removeIndexs.reversed() { remove(at: index) }
        return self
    }

    /// 从数组中删除在`elements`数组中出现的元素
    /// - Parameters:
    ///   - elements:被删除的数组元素
    ///   - isRepeat:是否删除重复的元素
    @discardableResult
    mutating func removeArray(_ elements: [Element], isRepeat: Bool = true) -> Array {
        for element in elements {
            if contains(element) { remove(element, isRepeat: isRepeat) }
        }
        return self
    }

    /// 移除数组中指定的元素
    ///
    ///     [1, 2, 2, 3, 4, 5].removeAll(2) -> [1, 3, 4, 5]
    ///     ["h", "e", "l", "l", "o"].removeAll("l") -> ["h", "e", "o"]
    /// - Parameters item:要移除的对象
    /// - Returns:移除完成后的数组
    @discardableResult
    mutating func removeAll(_ item: Element) -> [Element] {
        removeAll(where: { $0 == item })
        return self
    }

    /// 移除指定数组中的所有元素
    ///
    ///     [1, 2, 2, 3, 4, 5].removeAll([2,5]) -> [1, 3, 4]
    ///     ["h", "e", "l", "l", "o"].removeAll(["l", "h"]) -> ["e", "o"]
    /// - Parameters items:要移除的对象数组
    /// - Returns:移除完成后的数组
    @discardableResult
    mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }

    /// 移除数组中的重复元素
    ///
    ///     [1, 2, 2, 3, 4, 5].removeDuplicates() -> [1, 2, 3, 4, 5]
    ///     ["h", "e", "l", "l", "o"]. removeDuplicates() -> ["h", "e", "l", "o"]
    ///
    /// - Returns:移除完成后的数组
    @discardableResult
    mutating func removeDuplicates() -> [Element] {
        self = reduce(into: [Element]()) {
            if !$0.contains($1) { $0.append($1) }
        }
        return self
    }

    /// 移除数组中的重复元素(不修改当前数组, 只是返回移除后的数组)
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].withoutDuplicates() -> [1, 2, 3, 4, 5])
    ///     ["h", "e", "l", "l", "o"].withoutDuplicates() -> ["h", "e", "l", "o"])
    ///
    /// - Returns:移除完成后的数组
    func withoutDuplicates() -> [Element] {
        reduce(into: [Element]()) {
            if !$0.contains($1) { $0.append($1) }
        }
    }

    /// 按指定路径移除重复元素(不修改当前数组, 只是返回移除后的数组)
    /// - Parameters path:要比较的路径,值必须是可比较的
    /// - Returns:移除完成后的数组
    func withoutDuplicates(keyPath path: KeyPath<Element, some Equatable>) -> [Element] {
        reduce(into: [Element]()) { result, element in
            if !result.contains(where: { $0[keyPath: path] == element[keyPath: path] }) {
                result.append(element)
            }
        }
    }

    /// 按指定路径移除重复元素(不修改当前数组, 只是返回移除后的数组)
    /// - Parameters path:要比较的路径,值必须是可哈希的
    /// - Returns:移除完成后的数组
    func withoutDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        var set = Set<E>()
        return filter { set.insert($0[keyPath: path]).inserted }
    }
}

// MARK: - Element:NSObjectProtocol
public extension Array where Element: NSObjectProtocol {
    /// 删除数组中遵守`NSObjectProtocol`协议的元素
    /// - Parameters:
    ///   - object:元素
    ///   - isRepeat:是否删除重复的元素
    @discardableResult
    mutating func remove(object: NSObjectProtocol, isRepeat: Bool = true) -> Array {
        var removeIndexs: [Int] = []
        for i in 0 ..< count {
            if self[i].isEqual(object) {
                removeIndexs.append(i)
                if !isRepeat { break }
            }
        }
        for index in removeIndexs.reversed() { remove(at: index) }
        return self
    }

    /// 删除一个遵守`NSObjectProtocol`的数组中的元素,支持重复删除
    /// - Parameters:
    ///   - objects:遵守`NSObjectProtocol`的数组
    ///   - isRepeat:是否删除重复的元素
    @discardableResult
    mutating func removeArray(objects: [NSObjectProtocol], isRepeat: Bool = true) -> Array {
        for object in objects {
            if contains(where: { $0.isEqual(object) }) {
                remove(object: object, isRepeat: isRepeat)
            }
        }
        return self
    }
}

// MARK: - 方法(数组:Element:NSAttributedString)
public extension Array where Element: NSAttributedString {
    /// `拼接``NSAttributedString数组`中的每个元素并使用`separator`分割
    /// - Parameter separator:`NSAttributedString`类型分割符
    /// - Returns:`NSAttributedString`
    func joined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = first else { return "".toAttributedString() }
        return dropFirst()
            .reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
                result.append(separator)
                result.append(element)
            }
    }

    /// `拼接``NSAttributedString数组`中的每个元素并使用`separator`分割
    /// - Parameter separator:`String`类型分割符
    /// - Returns:`NSAttributedString`
    func joined(separator: String) -> NSAttributedString {
        let separator = NSAttributedString(string: separator)
        return joined(separator: separator)
    }
}
