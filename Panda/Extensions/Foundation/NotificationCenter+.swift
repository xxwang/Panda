import UIKit

// MARK: - 静态方法
public extension NotificationCenter {
    /// 发送通知
    /// - Parameters:
    ///   - name: 通知名称
    ///   - object: 对象
    ///   - userInfo: 信息字典
    static func pd_post(_ name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.async_execute_on_main {
            NotificationCenter.default.post(name: name,
                                            object: object,
                                            userInfo: userInfo)
        }
    }

    /// 添加通知监听(方法)
    /// - Parameters:
    ///   - observer: 监听者
    ///   - selector: 响应方法
    ///   - name: 通知名称
    ///   - object: 对象
    static func pd_add(_ observer: Any, selector: Selector, name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: name,
                                               object: object)
    }

    /// 添加通知监听(闭包)
    /// - Parameters:
    ///   - observer: 监听者
    ///   - name: 通知名称
    ///   - runBlock: 执行代码的闭包
    static func pd_add(_ observer: Any, name: Notification.Name, runBlock: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(observer,
                                               selector: #selector(pd_notificationCB(notification:)),
                                               name: name,
                                               object: runBlock)
    }

    /// 移除监听者
    /// - Parameters:
    ///   - observer: 要移除的监听者
    ///   - name: 通知名称
    ///   - object: 对象
    static func pd_remove(_ observer: Any, name: Notification.Name? = nil, object: Any? = nil) {
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

    /// 移除指定监听者的所有通知
    /// - Parameter observer: 监听者
    static func pd_removeAll(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}

// MARK: - 私有方法
private extension NotificationCenter {
    /// 执行通知中的闭包的方法
    /// - Parameter notification: 接收到的通知
    @objc class func pd_notificationCB(notification: Notification) {
        if let cb = notification.object as? ((Notification) -> Void) {
            DispatchQueue.main.async {
                cb(notification)
            }
        }
    }
}
