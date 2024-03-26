//
//  SkinUtils.swift
//
//
//  Created by 王斌 on 2023/5/29.
//

import UIKit

// MARK: - `Skinable`协议
public protocol Skinable: AnyObject {
    /// 在这个方法中更新主题(前提:遵守`Skinable`协议)
    func apply()
}

// MARK: - 设置遵守`UITraitEnvironment`的可以使用协议`Skinable`
public extension Skinable where Self: UITraitEnvironment {
    // 返回单例对象
    var skinManager: SkinProvider {
        SkinUtils.shared
    }
}

// MARK: - SkinUtils
public class SkinUtils {
    /// 监听对象数组
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    /// 单例
    public static let shared = SkinUtils()
    private init() {}
}

extension SkinUtils: SkinProvider {
    /// 注册监听
    /// - Parameter observer:监听对象
    public func register(observer: some Skinable) {
        observers.add(observer)
    }

    /// 移除监听
    /// - Parameter observer:监听对象
    public func remove(observer: some Skinable) {
        if !observers.contains(observer) { return }
        observers.remove(observer)
    }

    /// 更新主题
    public func updateSkin() {
        // 通知监听对象更新`Skin`
        DispatchQueue.main.async {
            self.observers
                .allObjects
                .compactMap { $0 as? Skinable }
                .forEach { $0.apply() }
        }
    }
}

// MARK: - `SkinProvider`协议
public protocol SkinProvider: AnyObject {
    /// 注册监听
    func register<Observer: Skinable>(observer: Observer)
    /// 移除监听
    func remove<Observer: Skinable>(observer: Observer)
    /// 更新主题
    func updateSkin()
}
