//
//  RangeReplaceableCollection+.swift
//
//
//  Created by xxwang on 2023/5/26.
//

import Foundation

// MARK: - 构造方法
public extension RangeReplaceableCollection {
    /// 使用`expression`结果创建一个指定大小的集合
    ///
    ///     let values = Array(expression:"Value", count:3)
    ///     print(values) -> "["Value", "Value", "Value"]"
    /// - Parameters:
    ///   - expression:为集合的每个位置执行的表达式
    ///   - count:集合元素个数
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

// MARK: - 方法
public extension RangeReplaceableCollection {
    /// 按给定位置返回新的旋转集合(返回一个新的集合)
    ///
    ///     [1, 2, 3, 4].rotated(by:1) -> [4,1,2,3]
    ///     [1, 2, 3, 4].rotated(by:3) -> [2,3,4,1]
    ///     [1, 2, 3, 4].rotated(by:-1) -> [2,3,4,1]
    /// - Parameter places:阵列旋转的位置数.如果值为正,则结束为开始,如果值为负,则开始为结束
    /// - Returns:新的旋转集合
    func rotated(by places: Int) -> Self {
        var copy = self
        return copy.rotate(by: places)
    }

    ///  按给定的位置旋转集合(返回旋转完的集合)
    ///
    ///      [1, 2, 3, 4].rotate(by:1) -> [4,1,2,3]
    ///      [1, 2, 3, 4].rotate(by:3) -> [2,3,4,1]
    ///      [1, 2, 3, 4].rotated(by:-1) -> [2,3,4,1]
    /// - Parameters places:阵列应旋转的位置数.如果值为正,则结束为开始,如果值为负,则开始为结束
    /// - Returns:旋转后的集合
    @discardableResult
    mutating func rotate(by places: Int) -> Self {
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

    /// 删除集合中满足条件的第一个元素
    ///
    ///     [1, 2, 2, 3, 4, 2, 5].removeFirst { $0 % 2 == 0 } -> [1, 2, 3, 4, 2, 5]
    ///     ["h", "e", "l", "l", "o"].removeFirst { $0 == "e" } -> ["h", "l", "l", "o"]
    /// - Parameters predicate:以元素为参数并返回布尔值的闭包,该布尔值指示传递的元素是否表示匹配
    /// - Returns:删除谓词后,谓词返回true的第一个元素.如果集合中没有满足给定谓词的元素,则返回“nil”
    @discardableResult
    mutating func removeFirst(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try firstIndex(where: predicate) else { return nil }
        return remove(at: index)
    }

    /// 从集合中随机删除一个值
    @discardableResult
    mutating func removeRandomElement() -> Element? {
        guard let randomIndex = indices.randomElement() else { return nil }
        return remove(at: randomIndex)
    }

    /// 保留条件为真的数组元素
    ///
    ///     [0, 2, 4, 7].keep(while:{ $0 % 2 == 0 }) -> [0, 2, 4]
    /// - Parameters condition:评估每个元素的条件
    /// - Returns:应用提供的条件后自行返回
    /// - Throws:异常
    @discardableResult
    mutating func keep(while condition: (Element) throws -> Bool) rethrows -> Self {
        if let idx = try firstIndex(where: { try !condition($0) }) {
            removeSubrange(idx...)
        }
        return self
    }

    /// 获取条件为`true`的连续数组元素(条件`false`之前)
    ///
    ///     [0, 2, 4, 7, 6, 8].take( where:{$0 % 2 == 0}) -> [0, 2, 4]
    /// - Parameters condition:评估每个元素的条件
    /// - Returns:条件为false之前的所有元素
    func take(while condition: (Element) throws -> Bool) rethrows -> Self {
        try Self(prefix(while: condition))
    }

    /// 获取条件为`false`之后的所有元素
    ///
    ///     [0, 2, 4, 7, 6, 8].skip( where:{$0 % 2 == 0}) -> [6, 8]
    /// - Parameters condition:评估每个元素的条件
    /// - Returns:条件为false后的所有元素
    func skip(while condition: (Element) throws -> Bool) rethrows -> Self {
        guard let idx = try firstIndex(where: { try !condition($0) }) else { return Self() }
        return Self(self[idx...])
    }

    /// 使用`KeyPath`删除所有重复的元素
    /// - Parameters path:要比较的路径,值必须可以比较
    mutating func removeDuplicates(keyPath path: KeyPath<Element, some Equatable>) {
        var items = [Element]()
        removeAll { element -> Bool in
            guard items.contains(where: { $0[keyPath: path] == element[keyPath: path] }) else {
                items.append(element)
                return false
            }
            return true
        }
    }

    /// 使用`KeyPath`删除所有重复的元素
    /// - Parameters path:要比较的`keyPath`,该值必须是`可hash`的
    mutating func removeDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) {
        var set = Set<E>()
        removeAll { !set.insert($0[keyPath: path]).inserted }
    }

    /// 访问指定位置的元素
    /// - Parameters offset:要访问的元素的偏移位置`offset`必须是集合的有效索引偏移量,该偏移量不等于'endIndex'属性
    subscript(offset: Int) -> Element {
        get { self[index(startIndex, offsetBy: offset)] }
        set {
            let offsetIndex = index(startIndex, offsetBy: offset)
            replaceSubrange(offsetIndex ..< index(after: offsetIndex), with: [newValue])
        }
    }

    /// 访问集合元素的连续子范围
    /// - Parameters range:集合的索引偏移范围, 范围的边界必须是集合的有效索引
    subscript<R>(range: R) -> SubSequence where R: RangeExpression, R.Bound == Int {
        get {
            let indexRange = range.relative(to: 0 ..< count)
            return self[index(startIndex, offsetBy: indexRange.lowerBound) ..< index(startIndex,
                                                                                     offsetBy: indexRange.upperBound)]
        }
        set {
            let indexRange = range.relative(to: 0 ..< count)
            replaceSubrange(
                index(startIndex, offsetBy: indexRange.lowerBound) ..< index(startIndex, offsetBy: indexRange.upperBound),
                with: newValue
            )
        }
    }

    /// 在数组末尾添加新元素(`newElement`为空,不插入)
    /// - Parameter newElement:附加到数组的可选元素
    mutating func appendIfNonNil(_ newElement: Element?) {
        guard let newElement else { return }
        append(newElement)
    }

    /// 将序列的元素添加到数组的末尾(`newElement`为空,不插入)
    /// - Parameter newElement:附加到数组的可选序列
    mutating func appendIfNonNil<S>(contentsOf newElements: S?) where Element == S.Element, S: Sequence {
        guard let newElements else { return }
        append(contentsOf: newElements)
    }
}
