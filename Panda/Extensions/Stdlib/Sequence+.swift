import Foundation

// MARK: - 方法
public extension Sequence {

    /// 检查集合中的所有元素是否符合条件
    ///
    ///     [2, 2, 4].all(matching:{$0 % 2 == 0}) -> true
    ///     [2, 2, 4].all(matching:{$0 % 2 == 0}) -> true
    ///
    /// - Parameter condition: 条件
    /// - Returns: 是否符合
    func pd_all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try !condition($0) }
    }

    /// 检查集合中是否所有元素都不符合条件
    ///
    ///     [2, 2, 4].none(matching:{$0 % 2 == 0}) -> false
    ///     [1, 3, 5, 7].none(matching:{$0 % 2 == 0}) -> true
    ///
    /// - Parameter condition: 条件
    /// - Returns: 是否不符合
    func pd_none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try !contains { try condition($0) }
    }

    /// 检查集合中是否有任意元素匹配条件(全部不匹配,返回false)
    ///
    ///     [1, 3, 2, 2, 4].any(matching:{$0 % 2 == 0}) -> true
    ///     [1, 3, 5, 7].any(matching:{$0 % 2 == 0}) -> false
    ///
    /// - Parameter condition: 条件
    /// - Returns: 是否符合
    func pd_any(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        try contains { try condition($0) }
    }

    /// 返回不符合条件的元素
    ///
    ///     [2, 2, 4, 7].reject(where:{$0 % 2 == 0}) -> [7]
    ///
    /// - Parameter condition: 条件
    /// - Returns: 结果数组
    func pd_reject(where condition: (Element) throws -> Bool) rethrows -> [Element] {
        try filter { try !condition($0) }
    }

    /// 返回满足条件的元素个数
    ///
    ///     [2, 2, 4, 7].count(where:{$0 % 2 == 0}) -> 3
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
    ///     [0, 2, 4, 7].forEachReversed({ print($0)}) -> // Order of print:7,4,2,0
    ///
    /// - Parameter body: 作用于元素的闭包
    func pd_forEachReversed(_ body: (Element) throws -> Void) rethrows {
        try reversed().forEach(body)
    }

    /// 为`condition`条件为真的结果执行`body`闭包
    ///
    ///     [0, 2, 4, 7].forEach(where:{$0 % 2 == 0}, body:{ print($0)}) -> // print:0, 2, 4
    ///
    /// - Parameters:
    ///   - condition: 条件
    ///   - body: 作用于`condition`结果中每个元素的闭包
    func pd_forEach(where condition: (Element) throws -> Bool, body: (Element) throws -> Void) rethrows {
        try lazy.filter(condition).forEach(body)
    }

    /// 积累操作, 操作结果作为返回结果数组元素
    ///
    ///     [1, 2, 3].accumulate(initial:0, next:+) -> [1, 3, 6]
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
    ///     [1,2,3,4,5].filtered({ $0 % 2 == 0 }, map:{ $0.string }) -> ["2", "4"]
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
    ///     [].single(where:{_ in true}) -> nil
    ///     [4].single(where:{_ in true}) -> 4
    ///     [1, 4, 7].single(where:{$0 % 2 == 0}) -> 4
    ///     [2, 2, 4, 7].single(where:{$0 % 2 == 0}) -> nil
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
    ///     [1, 2, 1, 3, 2].withoutDuplicates { $0 } -> [1, 2, 3]
    ///     [(1, 4), (2, 2), (1, 3), (3, 2), (2, 1)].withoutDuplicates { $0.0 } -> [(1, 4), (2, 2), (3, 2)]
    ///
    /// - Parameter transform: 条件
    /// - Returns: 结果数组
    func pd_withoutDuplicates<T: Hashable>(transform: (Element) throws -> T) rethrows -> [Element] {
        var set = Set<T>()
        return try filter { try set.insert(transform($0)).inserted }
    }

    ///  根据给定的谓词将所有项目分成 2 个列表. 第一个列表包含指定条件评估为真的所有项目. 第二个列表包含那些不包含的列表
    ///
    ///     let (even, odd) = [0, 1, 2, 3, 4, 5].divided { $0 % 2 == 0 }
    ///     let (minors, adults) = people.divided { $0.age < 18 }
    /// - Parameters condition:评估每个元素的条件
    /// - Returns:匹配和不匹配项的元组
    
    
    /// <#Description#>
    /// - Parameter condition: <#condition description#>
    /// - Returns: <#description#>
    func pd_divided(by condition: (Element) throws -> Bool) rethrows -> (matching: [Element], nonMatching: [Element]) {
        var matching = [Element]()
        var nonMatching = [Element]()

        for element in self {
            try condition(element) ? matching.append(element) : nonMatching.append(element)
        }
        return (matching, nonMatching)
    }

    /// 返回一个基于keyPath和比较函数的排序数组
    /// - Parameters keyPath:排序依据的vvvkeyPath
    /// - Parameter compare:将确定排序的比较函数
    /// - Returns:排序后的数组
    func pd_sorted<T>(by keyPath: KeyPath<Element, T>, with compare: (T, T) -> Bool) -> [Element] {
        sorted { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    /// 返回一个基于keyPath的排序数组
    /// - Parameters keyPath:排序依据的keyPath. keyPath类型必须遵守Comparable
    /// - Returns:排序后的数组
    func pd_sorted(by keyPath: KeyPath<Element, some Comparable>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    /// 返回基于两个keyPath的排序序列. 如果第一个的值匹配,则将使用第二个
    /// - Parameters:
    ///     - keyPath1:排序依据的keyPath, 必须遵守Comparable.
    ///     - keyPath2:在 `keyPath1` 的值匹配的情况下排序的keyPath, 必须遵守Comparable.
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

    /// 返回基于三个keyPath的排序序列. 每当一个键路径的值匹配时,将使用下一个
    /// - Parameters:
    ///     - keyPath1:排序依据的KeyPath,必须遵守Comparable
    ///     - keyPath2:在 `keyPath1` 的值匹配的情况下排序的KeyPath, 必须遵守Comparable
    ///     - keyPath3:在 `keyPath1` 和 `keyPath2` 的值匹配的情况下排序的KeyPath, 必须遵守Comparable
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

    /// 求`Sequence` 中每个 `Element` 的 `AdditiveArithmetic` 属性的总和
    ///
    ///     ["James", "Wade", "Bryant"].sum(for:\.count) -> 15
    /// - Parameters keyPath:`AdditiveArithmetic` 属性的KeyPath
    /// - Returns:`keyPath` 处的 `AdditiveArithmetic` 属性的总和
    func pd_sum<T: AdditiveArithmetic>(for keyPath: KeyPath<Element, T>) -> T {
        reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }

    /// 返回序列的第一个元素,给定KeyPath属性等于给定的`value`
    /// - Parameters:
    ///   - keyPath:要比较的 `Element` 属性的 `KeyPath`
    ///   - value:与 `Element` 属性比较的值
    /// - Returns:符合比较结果的第一个元素,如果没有符合的元素返回nil
    func pd_first<T: Equatable>(where keyPath: KeyPath<Element, T>, equals value: T) -> Element? {
        first { $0[keyPath: keyPath] == value }
    }
}

// MARK: - Element:Equatable
public extension Sequence where Element: Equatable {
    /// 检查数组是否包含元素数组
    ///
    ///     [1, 2, 3, 4, 5].contains([1, 2]) -> true
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].contains([2, 6]) -> false
    ///     ["h", "e", "l", "l", "o"].contains(["l", "o"]) -> true
    /// - Parameters elements:要检查的元素数组
    /// - Returns:如果数组包含所有给定项,则返回true
    func pd_contains(_ elements: [Element]) -> Bool {
        elements.allSatisfy { contains($0) }
    }
}

// MARK: - Element:Hashable
public extension Sequence where Element: Hashable {
    /// 检查数组是否包含元素数组
    ///
    ///     [1, 2, 3, 4, 5].contains([1, 2]) -> true
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].contains([2, 6]) -> false
    ///     ["h", "e", "l", "l", "o"].contains(["l", "o"]) -> true
    /// - Parameters elements:要检查的元素数组
    /// - Returns:如果数组包含所有给定项,则返回true
    func pd_contains(_ elements: [Element]) -> Bool {
        let set = Set(self)
        return elements.allSatisfy { set.contains($0) }
    }

    /// 检查序列是否包含重复项
    ///
    /// - Returns:如果接收器包含重复项,则返回true
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
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].duplicates().sorted() -> [1, 2, 3])
    ///     ["h", "e", "l", "l", "o"].duplicates().sorted() -> ["l"])
    ///
    /// - Returns:重复元素的数组
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
    /// 数组中所有元素的总和
    ///
    ///     [1, 2, 3, 4, 5].sum() -> 15
    ///
    /// - Returns:数组元素的总和
    func pd_sum() -> Element {
        reduce(.zero, +)
    }
}
