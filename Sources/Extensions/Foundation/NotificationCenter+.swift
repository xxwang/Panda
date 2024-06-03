import UIKit

public extension NotificationCenter {
    static func xx_post(_ name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.xx_async_execute_on_main {
            NotificationCenter.default.post(name: name,
                                            object: object,
                                            userInfo: userInfo)
        }
    }

    static func xx_add(_ observer: Any, selector: Selector, name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: name,
                                               object: object)
    }

    static func xx_add(_ observer: Any, name: Notification.Name, runBlock: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(observer,
                                               selector: #selector(xx_notificationCB(notification:)),
                                               name: name,
                                               object: runBlock)
    }

    static func xx_remove(_ observer: Any, name: Notification.Name? = nil, object: Any? = nil) {
        guard let name else {
            NotificationCenter.default.removeObserver(observer)
            return
        }

        NotificationCenter.default.removeObserver(
            observer,
            name: name,
            object: object
        )
    }

    static func xx_removeAll(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}

private extension NotificationCenter {
    @objc class func xx_notificationCB(notification: Notification) {
        if let cb = notification.object as? ((Notification) -> Void) {
            DispatchQueue.main.async {
                cb(notification)
            }
        }
    }
}