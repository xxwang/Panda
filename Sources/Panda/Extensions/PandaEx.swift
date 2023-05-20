//
//  PandaEx.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

// MARK: - 包装类型(base为实例)
public class PandaEx<Base> {
    var base: Base

    init(_ base: Base) {
        self.base = base
    }
}

// MARK: - 为类型提供`.pd.`支持
public protocol Pandaable {}
public extension Pandaable {
    /// 作用于实例
    var pd: PandaEx<Self> {
        PandaEx(self)
    }

    /// 作用于类型
    static var pd: PandaEx<Self>.Type {
        PandaEx<Self>.self
    }
}
