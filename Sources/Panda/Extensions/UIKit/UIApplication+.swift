//
//  UIApplication+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

/// 属性
public extension UIApplication {
    /// 获取`UIApplicationDelegate`
    static var appDelegate: UIApplicationDelegate? {
        let delegate = UIApplication.shared.delegate
        return delegate
    }

    /// 获取`UIWindowSceneDelegate`
    @available(iOS 13.0, *)
    static var sceneDelegate: UIWindowSceneDelegate? {
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene,
               let windowSceneDelegate = windowScene.delegate as? UIWindowSceneDelegate
            {
                return windowSceneDelegate
            }
        }
        return nil
    }

    /// 获取屏幕的方向
    static var screenOrientation: UIInterfaceOrientation {
        UIApplication.shared.statusBarOrientation
    }

    /// 网络状态是否可用
    static var reachable: Bool {
        NSData(contentsOf: URL(string: "https://www.baidu.com/")!) != nil
    }

    /// 消息推送是否可用
    static var isAvailableOfPush: Bool {
        let notOpen = UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType(rawValue: 0)
        return !notOpen
    }
}

// MARK: - 方法
public extension UIApplication {
    /// 清理图标上的角标
    func clearApplicationIconBadge() {
        applicationIconBadgeNumber = 0
    }
}

// MARK: - 商店
public extension UIApplication {
    /// app商店链接
    /// - Parameter appID:应用在商店中的ID
    /// - Returns:URL字符串
    @discardableResult
    static func appURL(with appID: String) -> String {
        let appStoreURL = "itms-apps://itunes.apple.com/app/id\(appID)?mt=8"
        return appStoreURL
    }

    /// app详情链接
    /// - Parameter appID:应用在商店中的ID
    /// - Returns:URL字符串
    @discardableResult
    static func appDetailURL(with appID: String) -> String {
        let detailURL = "http://itunes.apple.com/cn/lookup?id=\(appID)"
        return detailURL
    }
}

// MARK: - 版本号
public extension UIApplication {
    /// 判断当前版本是否为新版本
    static var isNewVersion: Bool {
        // 当前应用版本
        let currentVersion = Bundle.appVersion ?? "0.0.0"
        // 获取存储的版本
        let sandboxVersion = UserDefaults.standard.string(forKey: "appVersion") ?? ""
        // 存储当前版本
        UserDefaults.standard.set(currentVersion, for: "appVersion")
        UserDefaults.standard.synchronize()
        // 返回比较结果
        return currentVersion.compare(sandboxVersion) == .orderedDescending
    }

    /// 指定版本号与应用当前版本号进行比较
    /// - Parameter version:传进来的版本号码
    /// - Returns:返回对比加过,true:比当前的版本大,false:比当前的版本小
    static func compareVersion(version: String) -> Bool {
        // 获取要比较的(主版本号、次版本号、补丁版本号)
        let newVersionResult = appVersion(version: version)
        guard newVersionResult.isSuccess else {
            return false
        }

        // 获取当前应用的(主版本号、次版本号、补丁版本号)
        let currentVersion = Bundle.appVersion ?? "0.0.0"
        let currentVersionResult = appVersion(version: currentVersion)
        guard currentVersionResult.isSuccess else {
            return false
        }

        // 主版本大于
        if newVersionResult.versions.major > currentVersionResult.versions.major {
            return true
        }

        // 主版本小于
        if newVersionResult.versions.major < currentVersionResult.versions.major {
            return false
        }

        // 次版本号大于
        if newVersionResult.versions.minor > currentVersionResult.versions.minor {
            return true
        }

        // 次版本号小于
        if newVersionResult.versions.minor < currentVersionResult.versions.minor {
            return false
        }

        // 补丁版本大于
        if newVersionResult.versions.patch > currentVersionResult.versions.patch {
            return true
        }

        // 补丁版本小于
        if newVersionResult.versions.patch < currentVersionResult.versions.patch {
            return false
        }

        // 相等
        return false
    }

    /// 分割版本号
    /// - Parameter version:要分割的版本号
    /// - Returns:(isSuccess:是否成功, versions:(major:主版本号, minor:次版本号, patch:补丁版本号))
    static func appVersion(version: String) -> (isSuccess: Bool, versions: (major: Int, minor: Int, patch: Int)) {
        // 获取(主版本号、次版本号、补丁版本号)字符串数组
        let versionNumbers = version.split(with: ".")
        if versionNumbers.count != 3 {
            return (isSuccess: false, versions: (major: 0, minor: 0, patch: 0))
        }

        // 主版本号
        let majorString = versionNumbers[0]
        let majorNumber = majorString.toInt()

        // 次版本号
        let minorString = versionNumbers[1]
        let minorNumber = minorString.toInt()

        // 补丁版本号
        let patchString = versionNumbers[2]
        let patchNumber = patchString.toInt()

        return (isSuccess: true, versions: (major: majorNumber, minor: minorNumber, patch: patchNumber))
    }
}
