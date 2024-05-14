
import Foundation

public extension Timer {
    convenience init(timeInterval: TimeInterval,
                     repeats: Bool,
                     forMode mode: RunLoop.Mode,
                     block: @escaping ((Timer) -> Void))
    {
        if #available(iOS 10.0, *) {
            self.init(timeInterval: timeInterval,
                      repeats: repeats,
                      block: block)
        } else {
            self.init(timeInterval: timeInterval,
                      target: Timer.self,
                      selector: #selector(Timer.xx_timerCB(timer:)),
                      userInfo: block,
                      repeats: repeats)
        }
        RunLoop.current.add(self, forMode: mode)
    }

    convenience init(startDate date: Date,
                     timeInterval: TimeInterval,
                     repeats: Bool,
                     forMode mode: RunLoop.Mode,
                     block: @escaping ((Timer) -> Void))
    {
        if #available(iOS 10.0, *) {
            self.init(fire: date,
                      interval: timeInterval,
                      repeats: repeats,
                      block: block)
        } else {
            self.init(fireAt: date,
                      interval: timeInterval,
                      target: Timer.self,
                      selector: #selector(Timer.xx_timerCB(timer:)),
                      userInfo: block,
                      repeats: repeats)
        }
        RunLoop.current.add(self, forMode: mode)
    }
}

public extension Timer {
    @discardableResult
    static func xx_safeScheduledTimer(timeInterval: TimeInterval,
                                      repeats: Bool,
                                      block: @escaping ((Timer) -> Void)) -> Timer
    {
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: timeInterval,
                                        repeats: repeats,
                                        block: block)
        }
        return Timer.scheduledTimer(timeInterval: timeInterval,
                                    target: self,
                                    selector: #selector(Timer.xx_timerCB(timer:)),
                                    userInfo: block,
                                    repeats: repeats)
    }

    @discardableResult
    static func xx_runThisEvery(timeInterval: TimeInterval,
                                block: @escaping (Timer?) -> Void) -> Timer?
    {
        let fireDate = CFAbsoluteTimeGetCurrent()
        guard let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault,
                                                          fireDate,
                                                          timeInterval,
                                                          0,
                                                          0,
                                                          block)
        else {
            return nil
        }
        CFRunLoopAddTimer(CFRunLoopGetCurrent(),
                          timer,
                          CFRunLoopMode.commonModes)
        return timer
    }
}

private extension Timer {
    @objc class func xx_timerCB(timer: Timer) {
        if let cb = timer.userInfo as? ((Timer) -> Void) {
            cb(timer)
        } else {
            timer.invalidate()
        }
    }
}
