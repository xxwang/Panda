//
//  Timer+.swift
//
//
//  Created by 王斌 on 2023/5/27.
//

import Foundation

// MARK: - 构造方法
public extension Timer {
    /// 使用构造方法创建定时器(需要调用`fire()`)
    /// - Parameters:
    ///   - timeInterval:时间间隔
    ///   - repeats:是否重复执行
    ///   - mode:`RunLoop`模式
    ///   - block:执行代码的`block`
    convenience init(timeInterval: TimeInterval,
                     repeats: Bool,
                     forMode mode: RunLoop.Mode,
                     block: @escaping ((Timer) -> Void))
    {
        if #available(iOS 10.0, *) {
            self.init(timeInterval: timeInterval, repeats: repeats, block: block)
        } else {
            self.init(timeInterval: timeInterval,
                      target: Timer.self,
                      selector: #selector(Timer.timerCB(timer:)),
                      userInfo: block,
                      repeats: repeats)
        }
        RunLoop.current.add(self, forMode: mode)
    }

    /// 使用构造方法创建带`延时`的定时器(不需要调用`fire()`)
    /// - Parameters:
    ///   - date:开始时间
    ///   - timeInterval:时间间隔
    ///   - repeats:是否重复执行
    ///   - mode:`RunLoop`模式
    ///   - block:执行代码的`block`
    convenience init(startDate date: Date,
                     timeInterval: TimeInterval,
                     repeats: Bool,
                     forMode mode: RunLoop.Mode,
                     block: @escaping ((Timer) -> Void))
    {
        if #available(iOS 10.0, *) {
            self.init(fire: date, interval: timeInterval, repeats: repeats, block: block)
        } else {
            self.init(
                fireAt: date,
                interval: timeInterval,
                target: Timer.self,
                selector: #selector(Timer.timerCB(timer:)),
                userInfo: block,
                repeats: repeats
            )
        }
        RunLoop.current.add(self, forMode: mode)
    }
}

// MARK: - 静态方法
public extension Timer {
    /// 创建定时器(不需要调用`fire()`,不需要加入`RunLoop`)
    /// - Parameters:
    ///   - timeInterval:时间间隔
    ///   - repeats:是否重复执行
    ///   - block:执行代码的`block`
    /// - Returns:`Timer`
    @discardableResult
    static func safeScheduledTimer(timeInterval: TimeInterval,
                                   repeats: Bool,
                                   block: @escaping ((Timer) -> Void)) -> Timer
    {
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: repeats, block: block)
        }
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(Timer.timerCB(timer:)), userInfo: block, repeats: repeats)
    }

    /// 创建`C语言`形式的定时器(不需要调用`fire()`,不需要加入`RunLoop`)
    /// - Parameters:
    ///   - timeInterval:时间间隔
    ///   - block:重复执行的`block`
    /// - Returns:`Timer`
    @discardableResult
    static func runThisEvery(timeInterval: TimeInterval,
                             block: @escaping (Timer?) -> Void) -> Timer?
    {
        let fireDate = CFAbsoluteTimeGetCurrent()
        guard let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, timeInterval, 0, 0, block) else {
            return nil
        }
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer
    }
}

// MARK: - 私有方法
private extension Timer {
    /// `Timer`执行方法
    /// - Parameter timer:`Timer`
    @objc class func timerCB(timer: Timer) {
        if let cb = timer.userInfo as? ((Timer) -> Void) { cb(timer) } else { timer.invalidate() }
    }
}
