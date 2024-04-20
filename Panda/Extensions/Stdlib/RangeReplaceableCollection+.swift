import Foundation

// MARK: - 构造方法
public extension RangeReplaceableCollection {
    /// 使用`expression`结果创建一个指定大小的集合
    ///
    ///     let values = Array(expression:"Value", count:3)
    ///     print(values) -> "["Value", "Value", "Value"]"
    ///
    /// - Parameters:
    ///   - expression: 返回集合元素的自动闭包
    ///   - count: 集合元素个数
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

// MARK: - 下标
public extension RangeReplaceableCollection {
    /// 访问指定位置的元素
    /// - Parameter offset: 元素位置对应的偏移
    /// - Returns: 指定位置的元素
    subscript(offset: Int) -> Element {
        get { self[index(startIndex, offsetBy: offset)] }
        set {
            let offsetIndex = index(startIndex, offsetBy: offset)
            replaceSubrange(offsetIndex ..< index(after: offsetIndex), with: [newValue])
        }
    }

    /// 访问集合元素的连续范围
    /// - Parameter range: 序列范围
    /// - Returns: 结果序列
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

// MARK: - 方法
public extension RangeReplaceableCollection {
    /// 按给定位置返回新的旋转集合
    ///
    ///     [1, 2, 3, 4].pd_rotated(by:1) -> [4,1,2,3]
    ///     [1, 2, 3, 4].pd_rotated(by:3) -> [2,3,4,1]
    ///     [1, 2, 3, 4].pd_rotated(by:-1) -> [2,3,4,1]
    ///
    /// - Parameter places: 旋转的位置数
    /// - Returns: 结果集合
    func pd_rotated(by places: Int) -> Self {
        var copy = self
        return copy.pd_rotate(by: places)
    }

    /// 按给定的位置旋转集合
    ///
    ///      [1, 2, 3, 4].pd_rotate(by:1) -> [4,1,2,3]
    ///      [1, 2, 3, 4].pd_rotate(by:3) -> [2,3,4,1]
    ///      [1, 2, 3, 4].pd_rotate(by:-1) -> [2,3,4,1]
    ///
    /// - Parameter places: 旋转的位置数
    /// - Returns: 结果集合
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

    /// 删除集合中满足条件的第一个元素
    ///
    ///     [1, 2, 2, 3, 4, 2, 5].pd_removeFirst { $0 % 2 == 0 } -> [1, 2, 3, 4, 2, 5]
    ///     ["h", "e", "l", "l", "o"].pd_removeFirst { $0 == "e" } -> ["h", "l", "l", "o"]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 第一个删除的元素
    @discardableResult
    mutating func pd_removeFirst(where condition: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try self.firstIndex(where: condition) else { return nil }
        return self.remove(at: index)
    }

    /// 从集合中随机删除一个值
    /// - Returns: 被删除的元素
    @discardableResult
    mutating func pd_removeRandomElement() -> Element? {
        guard let randomIndex = indices.randomElement() else { return nil }
        return self.remove(at: randomIndex)
    }

    /// 保留数组符合条件的连续的元素(第一个不符合条件元素之前的所有元素)
    ///
    ///     [0, 2, 4, 7].pd_keep(while:{ $0 % 2 == 0 }) -> [0, 2, 4]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果集合
    @discardableResult
    mutating func pd_keep(while condition: (Element) throws -> Bool) rethrows -> Self {
        if let idx = try self.firstIndex(where: { try !condition($0) }) {
            removeSubrange(idx...)
        }
        return self
    }

    /// 获取符合条件的连续的数组元素(第一个不符合条件元素之前的所有元素)
    ///
    ///     [0, 2, 4, 7, 6, 8].pd_take( where:{$0 % 2 == 0}) -> [0, 2, 4]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果集合
    func pd_take(while condition: (Element) throws -> Bool) rethrows -> Self {
        try Self(self.prefix(while: condition))
    }

    /// 获取第一个不符合条件的元素之后的所有元素
    ///
    ///     [0, 2, 4, 7, 6, 8].pd_skip( where:{$0 % 2 == 0}) -> [6, 8]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果集合
    func pd_skip(while condition: (Element) throws -> Bool) rethrows -> Self {
        guard let idx = try firstIndex(where: { try !condition($0) }) else { return Self() }
        return Self(self[idx...])
    }

    /// 根据`keyPath`删除集合中的重复元素
    /// - Parameter path: 删除依据
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

    /// 使用`KeyPath`删除所有重复的元素
    /// - Parameters path:要比较的`keyPath`,该值必须是`可hash`的
    mutating func pd_removeDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) {
        var set = Set<E>()
        removeAll { !set.insert($0[keyPath: path]).inserted }
    }

    /// 在集合末尾添加非`nil`元素
    /// - Parameter newElement: 要添加的可选元素
    mutating func pd_appendIfNonNil(_ newElement: Element?) {
        guard let newElement else { return }
        self.append(newElement)
    }

    /// 在集合末尾添加非`nil`序列
    /// - Parameter newElements: 要添加的可选序列
    mutating func pd_appendIfNonNil<S>(contentsOf newElements: S?) where Element == S.Element, S: Sequence {
        guard let newElements else { return }
        self.append(contentsOf: newElements)
    }
}
