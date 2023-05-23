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
        DispatchQueue.main.async { block() }
    }

    /// 在默认的全局队列异步执行
    /// - Parameter block: 要执行任务
    static func async_execute_on_global(_ block: @escaping () -> Void) {
        DispatchQueue.global().async { block() }
    }
}

// MARK: - GCD定时器
public extension DispatchQueue {
    /// `GCD定时器``倒计时`⏳
    /// - Parameters:
    ///   - timeInterval: 间隔时间
    ///   - repeatCount: 重复次数
    ///   - handler: 循环执行任务(`主线程`)
    @discardableResult
    static func countdown(_ timeInterval: TimeInterval, repeatCount: Int, handler: @escaping (DispatchSourceTimer?, Int) -> Void) -> DispatchSourceTimer? {
        if repeatCount <= 0 { return nil }

        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount
        timer.schedule(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
            }
        })
        timer.resume()
        return timer
    }

    /// `GCD定时器`按指定时间间隔连续执行
    /// - Parameters:
    ///   - timeInterval:间隔时间
    ///   - handler: 任务
    @discardableResult
    static func interval(_ timeInterval: TimeInterval, handler: @escaping (DispatchSourceTimer?) -> Void) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler {
            DispatchQueue.main.async {
                handler(timer)
            }
        }
        timer.resume()
        return timer
    }
}

// MARK: - 延时执行
public extension DispatchQueue {
    /// `防抖``延时`执行
    /// - Parameters:
    ///   - queue: 任务执行的队列
    ///   - seconds: `延迟时间`
    ///   - work: 要执行的任务
    /// - Returns: `block`
    static func debounce(_ queue: DispatchQueue = .main,
                         delay timeInterval: TimeInterval,
                         execute work: @escaping () -> Void) -> () -> Void
    {
        var lastFireTime = DispatchTime.now()
        let deadline = { lastFireTime + timeInterval }
        return {
            queue.asyncAfter(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    work()
                }
            }
        }
    }

    /// `延时``异步`执行
    /// - Parameters:
    ///   - queue: 任务执行的队列
    ///   - seconds: `延迟时间`
    ///   - qos: 优化级
    ///   - flags: 标识
    ///   - work: 要执行的任务
    static func delay_execute(_ queue: DispatchQueue = .main,
                              delay timeInterval: TimeInterval,
                              qos: DispatchQoS = .unspecified,
                              flags: DispatchWorkItemFlags = [],
                              execute work: @escaping () -> Void)
    {
        queue.asyncAfter(deadline: .now() + timeInterval, qos: qos, flags: flags, execute: work)
    }

    /// `延时`执行指定任务
    /// - Parameters:
    ///   - seconds: `延迟时间`
    ///   - asyncTask: `异步执行`的`任务`
    ///   - mainTask: `异步任务`完成之后执行的`主线程任务`
    /// - Returns:`DispatchWorkItem`
    static func delay_execute(delay timeInterval: TimeInterval,
                              task: (() -> Void)? = nil,
                              callback: (() -> Void)? = nil) -> DispatchWorkItem
    {
        let item = DispatchWorkItem(block: task ?? {})
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: item)
        if let callback { item.notify(queue: DispatchQueue.main, execute: callback) }
        return item
    }
}

// MARK: - 任务只被执行一次
public extension DispatchQueue {
    /// 函数`token`数组
    private static var onceTracker = [String]()

    /// `只执行一次``代码块`
    /// - Parameters:
    ///   - token: 函数标识
    ///   - block: 要执行的任务
    static func once(token: String, block: () -> Void) {
        if DispatchQueue.onceTracker.contains(token) {
            return
        }
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        DispatchQueue.onceTracker.append(token)
        block()
    }
}
