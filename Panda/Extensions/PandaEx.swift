//
//  PandaEx.swift
//
//
//  Created by xxwang on 2023/5/20.
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

// MARK: - 使用方法
/*
 // 要扩展的类型需要先遵守协议
 extension [类型]: Pandaable {}

 // 添加方法列表
 public extension SaberEx where Base: [类型] {
     //TODO: - 具体方法
 }

 // 调用方法
 类型实例.pd.方法名() //实例方法
 类型.pd.方法名() //类型方法
 */
