//
//  DispatchQueue+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import Dispatch
import Foundation

// MARK: - 队列判断
public extension DispatchQueue {
    /// 判断`当前队列`是否是`指定队列`
    /// - Parameter queue: `指定队列`
    /// - Returns:
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()
        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }
        return DispatchQueue.getSpecific(key: key) != nil
    }

    /// 判断`当前队列`是否是`主队列`
    /// - Returns: `Bool`
    static func isMainQueue() -> Bool {
        isCurrent(.main)
    }
}

// MARK: - 指定队列执行
public extension DispatchQueue {
    /// 在主线程异步执行
    /// - Parameter block: 要执行任务
    static func async_execute_on_main(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }

    /// 在默认的全局队列异步执行
    /// - Parameter block: 要执行任务
    static func async_execute_on_global(_ block: @escaping () -> Void) {
        DispatchQueue.global().async {
            block()
        }
    }
}
