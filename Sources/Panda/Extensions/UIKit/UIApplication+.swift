//
//  UIApplication+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import CoreLocation
import Foundation
import StoreKit
import UIKit
import UserNotifications

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
    static var interfaceOrientation: UIInterfaceOrientation {
        if #available(iOS 13, *) {
            return UIWindow.main?.windowScene?.interfaceOrientation ?? .unknown
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }

    /// 网络状态是否可用
    static var reachable: Bool {
        NSData(contentsOf: URL(string: "https://www.baidu.com/")!) != nil
    }
}

// MARK: - 商店
public extension UIApplication {
    /// 应用在商店中的链接地址
    /// - Parameter appID: 应用在商店中的ID
    /// - Returns: 地址字符串
    func homeUrlInAppStore(with appID: String) -> String {
        "itms-apps://itunes.apple.com/app/id\(appID)?mt=8"
    }

    /// 应用在商店中的详情链接地址
    /// - Parameter appID: 应用在商店中的ID
    /// - Returns: 地址字符串
    func detailUrlInAppStore(with appID: String) -> String {
        "http://itunes.apple.com/cn/lookup?id=\(appID)"
    }
}

// MARK: - 版本号
public extension UIApplication {
    /// 判断当前版本是否为新版本
    var isNewVersion: Bool {
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
    func compareVersion(_ version: String) -> Bool {
        // 获取要比较的(主版本号、次版本号、补丁版本号)
        let newVersion = splitAppVersion(version)
        guard newVersion.isOk else { return false }

        // 获取当前应用的(主版本号、次版本号、补丁版本号)
        let currentVersion = splitAppVersion(Bundle.appVersion ?? "0.0.0")
        guard currentVersion.isOk else { return false }

        // 主版本大于
        if newVersion.versions.major > currentVersion.versions.major {
            return true
        }

        // 主版本小于
        if newVersion.versions.major < currentVersion.versions.major {
            return false
        }

        // 次版本号大于
        if newVersion.versions.minor > currentVersion.versions.minor {
            return true
        }

        // 次版本号小于
        if newVersion.versions.minor < currentVersion.versions.minor {
            return false
        }

        // 补丁版本大于
        if newVersion.versions.patch > currentVersion.versions.patch {
            return true
        }

        // 补丁版本小于
        if newVersion.versions.patch < currentVersion.versions.patch {
            return false
        }

        // 相等
        return false
    }

    /// 分割版本号
    /// - Parameter version:要分割的版本号
    /// - Returns:(isOk:是否成功, versions:(major:主版本号, minor:次版本号, patch:补丁版本号))
    func splitAppVersion(_ version: String) -> (isOk: Bool, versions: (major: Int, minor: Int, patch: Int)) {
        // 获取(主版本号、次版本号、补丁版本号)字符串数组
        let versionNumbers = version.split(with: ".")
        if versionNumbers.count != 3 {
            return (isOk: false, versions: (major: 0, minor: 0, patch: 0))
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

        return (isOk: true, versions: (major: majorNumber, minor: minorNumber, patch: patchNumber))
    }
}

// MARK: - 方法
public extension UIApplication {
    /// 清理图标上的角标
    func clearApplicationIconBadge() {
        applicationIconBadgeNumber = 0
    }
}

// MARK: - 打开操作
public extension UIApplication {
    /// 打开指定URL地址
    /// - Parameters:
    ///   - url:要打开的URL地址
    ///   - complete:完成回调
    func openURL(_ url: URL, completion: ((_ isOk: Bool) -> Void)? = nil) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { success in
                completion?(success)
            }
        } else {
            completion?(UIApplication.shared.openURL(url))
        }
    }

    /// 拨打电话操作
    /// - Parameters:
    ///   - phoneNumber:要拨打的电话号码
    ///   - completion:完成回调
    func call(with phoneNumber: String, completion: @escaping (_ isOk: Bool) -> Void) {
        let callAddress = ("tel://" + phoneNumber)
        guard let url = URL(string: callAddress) else { completion(false); return }
        guard UIApplication.shared.canOpenURL(url) else { completion(false); return }
        openURL(url, completion: completion)
    }

    /// 在应用中打开指定应用在`AppStore`中的详情页面
    /// - Parameters:
    ///   - controller: 是哪个控制器来弹出的
    ///   - appID: 应用在商店中的ID
    func openAppDetailViewController(from controller: some UIViewController & SKStoreProductViewControllerDelegate,
                                     appID: String)
    {
        guard appID.count > 0 else { return }

        // 商店产品页面
        let productViewController = SKStoreProductViewController()
        productViewController.delegate = controller
        productViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appID]) { isOk, error in
            if !isOk {
                Log.error(error?.localizedDescription ?? "")
                productViewController.dismiss(animated: true)
            }
        }
        controller.showDetailViewController(productViewController, sender: controller)
    }

    /// 打开应用在`AppStore`中的打分页面
    /// - Parameter appID: 应用在商店中的ID
    func openEvaluateInAppStore(_ appID: String) {
        let urlString = "https://itunes.apple.com/cn/app/id\(appID)?mt=12"
        guard let url = URL(string: urlString) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        openURL(url) { $0 ? Log.info("打开应用商店评分页成功!") : Log.error("打开应用商店评分页失败!") }
    }

    /// 打开`设置App`并跳转至当前App权限相关界面
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        openURL(url) { $0 ? Log.info("打开设置App成功!") : Log.error("打开设置App失败!") }
    }

    /// 让用户自己决定是否打开`设置App`并跳转至当前App权限相关界面
    /// - Parameters:
    ///   - title:提示标题
    ///   - message:提示内容
    ///   - cancel:取消按钮标题
    ///   - confirm:确认按钮标题
    ///   - parent:来源控制器(谁来弹出提示窗)
    func openSettings(_ title: String?,
                      message: String?,
                      cancel: String = "取消",
                      confirm: String = "设置",
                      parent: UIViewController? = nil)
    {
        UIAlertController.default()
            .pd_title(title)
            .pd_message(message)
            .pd_addAction_(title: cancel, style: .cancel) { _ in
                Log.info("取消!")
            }
            .pd_addAction_(title: confirm, style: .default) { _ in
                // 打开系统设置App
                self.openSettings()
            }.show()
    }
}
