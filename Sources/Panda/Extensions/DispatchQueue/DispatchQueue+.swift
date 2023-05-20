//
//  DispatchQueue+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import Dispatch
import Foundation

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
