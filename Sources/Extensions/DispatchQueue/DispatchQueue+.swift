
import Dispatch
import Foundation

public extension DispatchQueue {
    static func sk_isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()
        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }
        return DispatchQueue.getSpecific(key: key) != nil
    }

    static func isMainQueue() -> Bool {
        return sk_isCurrent(.main)
    }
}

public extension DispatchQueue {
    static func sk_async_execute_on_main(_ block: @escaping () -> Void) {
        DispatchQueue.main.async { block() }
    }

    static func sk_async_execute_on_global(_ block: @escaping () -> Void) {
        DispatchQueue.global().async { block() }
    }
}

public extension DispatchQueue {
    @discardableResult
    static func sk_countdown(_ timeInterval: TimeInterval, repeatCount: Int, handler: @escaping (DispatchSourceTimer?, Int) -> Void) -> DispatchSourceTimer? {
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

    @discardableResult
    static func sk_interval(_ timeInterval: TimeInterval, handler: @escaping (DispatchSourceTimer?) -> Void) -> DispatchSourceTimer {
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

public extension DispatchQueue {
    static func sk_debounce(_ queue: DispatchQueue = .main,
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

    static func sk_delay_execute(delay timeInterval: TimeInterval,
                                 queue: DispatchQueue = .main,
                                 qos: DispatchQoS = .unspecified,
                                 flags: DispatchWorkItemFlags = [],
                                 execute work: @escaping () -> Void)
    {
        queue.asyncAfter(deadline: .now() + timeInterval, qos: qos, flags: flags, execute: work)
    }

    static func sk_delay_execute(delay timeInterval: TimeInterval,
                                 task: (() -> Void)? = nil,
                                 callback: (() -> Void)? = nil) -> DispatchWorkItem
    {
        let item = DispatchWorkItem(block: task ?? {})
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: item)
        if let callback { item.notify(queue: DispatchQueue.main, execute: callback) }
        return item
    }
}

public extension DispatchQueue {
    private static var sk_onceTracker = [String]()

    static func sk_once(token: String, block: () -> Void) {
        if DispatchQueue.sk_onceTracker.contains(token) {
            return
        }
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        DispatchQueue.sk_onceTracker.append(token)
        block()
    }
}
