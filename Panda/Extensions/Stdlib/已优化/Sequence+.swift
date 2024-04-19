import Foundation

// MARK: - 方法
public extension Sequence {
    /// 检查集合中的所有元素是否符合条件
    ///
    ///     [2, 2, 4].pd_all(matching:{$0 % 2 == 0}) -> true
    ///     [2, 2, 4].pd_all(matching:{$0 % 2 == 0}) -> true
    ///
    /// - Parameter condition: 条件
    /// - Returns: 是否符合
    func pd_all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try !condition($0) }
    }

    /// 检查集合中是否所有元素都不符合条件
    ///
    ///     [2, 2, 4].pd_none(matching:{$0 % 2 == 0}) -> false
    ///     [1, 3, 5, 7].pd_none(matching:{$0 % 2 == 0}) -> true
    ///
    /// - Parameter condition: 条件
    /// - Returns: 是否不符合
    func pd_none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try condition($0) }
    }

    /// 检查集合中是否有任意元素匹配条件(全部不匹配,返回false)
    ///
    ///     [1, 3, 2, 2, 4].pd_any(matching:{$0 % 2 == 0}) -> true
    ///     [1, 3, 5, 7].pd_any(matching:{$0 % 2 == 0}) -> false
    ///
    /// - Parameter condition: 条件
    /// - Returns: 是否符合
    func pd_any(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try contains { try condition($0) }
    }

    /// 返回不符合条件的元素
    ///
    ///     [2, 2, 4, 7].pd_reject(where:{$0 % 2 == 0}) -> [7]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果数组
    func pd_reject(where condition: (Element) throws -> Bool) rethrows -> [Element] {
        try filter { try !condition($0) }
    }

    /// 返回满足条件的元素个数
    ///
    ///     [2, 2, 4, 7].pd_count(where:{$0 % 2 == 0}) -> 3
    ///
    /// - Parameter condition: 条件
    /// - Returns: 符合条件的元素个数
    func pd_count(where condition: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self where try condition(element) {
            count += 1
        }
        return count
    }

    /// 反向迭代集合(从右到左)
    ///
    ///     [0, 2, 4, 7].pd_forEachReversed({ print($0)}) -> // Order of print:7,4,2,0
    ///
    /// - Parameter body: 作用于元素的闭包
    func pd_forEachReversed(_ body: (Element) throws -> Void) rethrows {
        try reversed().forEach(body)
    }

    /// 为`condition`条件为真的结果执行`body`闭包
    ///
    ///     [0, 2, 4, 7].pd_forEach(where:{$0 % 2 == 0}, body:{ print($0)}) -> // print:0, 2, 4
    ///
    /// - Parameters:
    ///   - condition: 条件
    ///   - body: 作用于`condition`结果中每个元素的闭包
    func pd_forEach(where condition: (Element) throws -> Bool, body: (Element) throws -> Void) rethrows {
        try lazy.filter(condition).forEach(body)
    }

    /// 积累操作, 操作结果作为返回结果数组元素
    ///
    ///     [1, 2, 3].pd_accumulate(initial:0, next:+) -> [1, 3, 6]
    ///
    /// - Parameters:
    ///   - initial: 初始值
    ///   - next: 作用于元素的闭包
    /// - Returns: 最终累积值组合的数组
    func pd_accumulate<U>(initial: U, next: (U, Element) throws -> U) rethrows -> [U] {
        var runningTotal = initial
        return try map { element in
            runningTotal = try next(runningTotal, element)
            return runningTotal
        }
    }

    /// 过滤元素并为每个结果元素执行闭包
    ///
    ///     [1,2,3,4,5].pd_filtered({ $0 % 2 == 0 }, map:{ $0.string }) -> ["2", "4"]
    ///
    /// - Parameters:
    ///   - isIncluded: 过滤元素的条件
    ///   - transform: 作用于过滤结果元素的闭包
    /// - Returns: 返回一个经过过滤和映射的数组
    func pd_filtered<T>(_ isIncluded: (Element) throws -> Bool, map transform: (Element) throws -> T) rethrows -> [T] {
        try lazy.filter(isIncluded).map(transform)
    }

    /// 查找符合条件的元素,且元素唯一才返回元素,否则为`nil`
    ///
    ///     [].pd_single(where:{_ in true}) -> nil
    ///     [4].pd_single(where:{_ in true}) -> 4
    ///     [1, 4, 7].pd_single(where:{$0 % 2 == 0}) -> 4
    ///     [2, 2, 4, 7].pd_single(where:{$0 % 2 == 0}) -> nil
    ///
    /// - Parameter condition: 条件
    /// - Returns: 查找结果
    func pd_single(where condition: (Element) throws -> Bool) rethrows -> Element? {
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

    /// 根据条件删除重复元素
    ///
    ///     [1, 2, 1, 3, 2].pd_withoutDuplicates { $0 } -> [1, 2, 3]
    ///     [(1, 4), (2, 2), (1, 3), (3, 2), (2, 1)].pd_withoutDuplicates { $0.0 } -> [(1, 4), (2, 2), (3, 2)]
    ///
    /// - Parameter transform: 条件
    /// - Returns: 结果数组
    func pd_withoutDuplicates<T: Hashable>(transform: (Element) throws -> T) rethrows -> [Element] {
        var set = Set<T>()
        return try filter { try set.insert(transform($0)).inserted }
    }

    /// 根据条件把元素分割为两个数组
    ///
    ///     let (even, odd) = [0, 1, 2, 3, 4, 5].pd_divided { $0 % 2 == 0 }
    ///     let (minors, adults) = people.pd_divided { $0.age < 18 }
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果元组
    func pd_divided(by condition: (Element) throws -> Bool) rethrows -> (matching: [Element], nonMatching: [Element]) {
        var matching = [Element]()
        var nonMatching = [Element]()

        for element in self {
            try condition(element) ? matching.append(element) : nonMatching.append(element)
        }
        return (matching, nonMatching)
    }

    /// 根据`keyPath`与条件排序
    /// - Parameters:
    ///   - keyPath: 排序依据`keyPath`
    ///   - compare: 排序条件
    /// - Returns: 排序后的数组
    func pd_sorted<T>(by keyPath: KeyPath<Element, T>, with compare: (T, T) -> Bool) -> [Element] {
        sorted { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    /// 根据`keyPath`排序(升序)
    /// - Parameter keyPath: 排序依据`keyPath`
    /// - Returns: 排序后的数组
    func pd_sorted(by keyPath: KeyPath<Element, some Comparable>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    /// 根据两个`keyPath`进行排序(如果第一个`keyPath`对应元素相等就使用第二个`keyPath`)
    /// - Parameters:
    ///   - keyPath1: 排序依据`keyPath`
    ///   - keyPath2: 排序依据`keyPath`
    /// - Returns: 排序后的数组
    func pd_sorted(by keyPath1: KeyPath<Element, some Comparable>,
                   and keyPath2: KeyPath<Element, some Comparable>) -> [Element]
    {
        sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    /// 根据两个`keyPath`进行排序(如果第一个`keyPath`对应元素相等就使用第二个`keyPath`....)
    /// - Parameters:
    ///   - keyPath1: 排序依据`keyPath`
    ///   - keyPath2: 排序依据`keyPath`
    ///   - keyPath3: 排序依据`keyPath`
    /// - Returns: 排序后的数组
    func pd_sorted(by keyPath1: KeyPath<Element, some Comparable>,
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

    /// 根据数组元素的`keyPath`求合,元素需要符合`AdditiveArithmetic`
    /// - Parameter keyPath: 元素`keyPath`
    /// - Returns: 求合结果
    func pd_sum<T: AdditiveArithmetic>(for keyPath: KeyPath<Element, T>) -> T {
        reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }

    /// 返回序列中第一个`keyPath`等于`value`的元素
    /// - Parameters:
    ///   - keyPath: keyPath
    ///   - value: 与 `Element` 属性比较的值
    /// - Returns: 相等的元素,没有符合的元素返回`nil`
    func pd_first<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        first { $0[keyPath: keyPath] == value }
    }
}

// MARK: - Element:Equatable
public extension Sequence where Element: Equatable {
    /// 检查数组是否完全包含`elements`数组
    ///
    ///     [1, 2, 3, 4, 5].pd_contains([1, 2]) -> true
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].pd_contains([2, 6]) -> false
    ///     ["h", "e", "l", "l", "o"].pd_contains(["l", "o"]) -> true
    ///
    /// - Parameter elements: 要检查的元素数组
    /// - Returns: 检查结果
    func pd_contains(_ elements: [Element]) -> Bool {
        elements.allSatisfy { contains($0) }
    }
}

// MARK: - Element:Hashable
public extension Sequence where Element: Hashable {
    /// 检查数组是否完全包含`elements`数组(会排除数组中的相同元素之后再检查)
    ///
    ///     [1, 2, 3, 4, 5].pd_contains([1, 2]) -> true
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].pd_contains([2, 6]) -> false
    ///     ["h", "e", "l", "l", "o"].pd_contains(["l", "o"]) -> true
    ///
    /// - Parameter elements: 要检查的元素数组
    /// - Returns: 检查结果
    func pd_contains(_ elements: [Element]) -> Bool {
        let set = Set(self)
        return elements.allSatisfy { set.contains($0) }
    }

    /// 检查序列是否包含重复项
    /// - Returns: 是否包含重复项
    func pd_containsDuplicates() -> Bool {
        var set = Set<Element>()
        for element in self {
            if !set.insert(element).inserted {
                return true
            }
        }
        return false
    }

    /// 获取序列中的重复元素
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].pd_duplicates().sorted() -> [1, 2, 3])
    ///     ["h", "e", "l", "l", "o"].pd_duplicates().sorted() -> ["l"])
    ///
    /// - Returns: 重复元素的数组
    func pd_duplicates() -> [Element] {
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

// MARK: - Element:AdditiveArithmetic
public extension Sequence where Element: AdditiveArithmetic {
    /// 求数组中所有元素的和
    ///
    ///     [1, 2, 3, 4, 5].pd_sum() -> 15
    ///
    /// - Returns: 求合结果
    func pd_sum() -> Element {
        reduce(.zero, +)
    }
}
