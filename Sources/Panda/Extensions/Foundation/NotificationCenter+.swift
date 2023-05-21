//
//  NotificationCenter+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

// MARK: - 静态方法
public extension NotificationCenter {
    /// 发送通知
    /// - Parameters:
    ///   - name:通知名称
    ///   - object:对象
    ///   - userInfo:携带信息
    static func post(_ name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.async_execute_on_main {
            NotificationCenter.default.post(
                name: name,
                object: object,
                userInfo: userInfo
            )
        }
    }

    /// 添加通知监听(方法)
    /// - Parameters:
    ///   - observer:监听者
    ///   - selector:响应方法
    ///   - name:通知名称
    ///   - object:对象
    static func add(_ observer: Any, selector: Selector, name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: name,
            object: object
        )
    }

    /// 移除监听者
    /// - Parameters:
    ///   - observer:要移除的监听者
    ///   - name:通知名称
    ///   - object:对象
    static func remove(_ observer: Any, name: Notification.Name? = nil, object: Any? = nil) {
        guard let name else { // 移除全部
            NotificationCenter.default.removeObserver(observer)
            return
        }

        // 移除指定通知监听者
        NotificationCenter.default.removeObserver(
            observer,
            name: name,
            object: object
        )
    }

    /// 移除`observer`的所有通知
    static func removeAll(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
