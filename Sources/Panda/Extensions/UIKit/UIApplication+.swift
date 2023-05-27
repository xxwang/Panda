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

// MARK: - 方法
public extension UIApplication {
    /// 清理图标上的角标
    func clearApplicationIconBadge() {
        applicationIconBadgeNumber = 0
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

// MARK: - 打开操作
public extension UIApplication {
    /// 打开手机上的`设置App`并跳转至本App的权限界面(带提示窗)
    /// - Parameters:
    ///   - title:提示标题
    ///   - message:提示内容
    ///   - cancel:取消按钮标题
    ///   - confirm:确认按钮标题
    ///   - parent:来源控制器(谁来弹出提示窗)
    static func openSettings(_ title: String?, message: String?, cancel: String = "取消", confirm: String = "设置", parent: UIViewController? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        alert.addAction(cancleAction)
        let confirmAction = UIAlertAction(title: confirm, style: .default, handler: { _ in
            // 打开系统设置App
            self.openSettings()
        })
        alert.addAction(confirmAction)
        if let root = parent {
            root.present(alert, animated: true)
            return
        }
        if let root = UIWindow.rootViewController() {
            root.present(alert, animated: true)
        }
    }

    /// 打开手机上的`设置App`并跳转至本App的权限界面
    static func openSettings() {
        guard let settingsAppURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(settingsAppURL)
        }
    }

    /// 前往AppStore进行评价
    /// - Parameter appID:应用在AppStore中的ID
    static func evaluationInAppStore(_ appID: String) {
        let appURLString = "https://itunes.apple.com/cn/app/id" + appID + "?mt=12"
        guard let url = URL(string: appURLString), UIApplication.shared.canOpenURL(url) else {
            return
        }

        // 打开评分页面
        openURL(url) { isSuccess in
            isSuccess ? print("打开应用商店评分页成功!") : print("打开应用商店评分页失败!")
        }
    }

    /// 应用跳转
    /// - Parameters:
    ///   - vc:跳转时所在控制器
    ///   - appID:app的id
    static func updateApp(vc: UIViewController, appID: String) {
        guard appID.count > 0 else {
            return
        }
        let productView = SKStoreProductViewController()
        // productView.delegate = (vc as! SKStoreProductViewControllerDelegate)
        productView.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appID], completionBlock: { result, _ in
            if !result {
                // 点击取消
                productView.dismiss(animated: true, completion: nil)
            }
        })
        vc.showDetailViewController(productView, sender: vc)
    }

    /// 打开应用更新页面
    /// - Parameters:
    ///   - sourceVC:跳转时的来源控制器(需要遵守`SKStoreProductViewControllerDelegate`协议)
    ///   - appID:用在AppStore中的ID(在Connect中创建应用后生成的ID)
    static func updateApp(from sourceVC: some UIViewController & SKStoreProductViewControllerDelegate, appID: String) {
        guard appID.count > 0 else {
            return
        }
        let productVC = SKStoreProductViewController()
        productVC.delegate = sourceVC
        productVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appID]) { isSuccess, error in
            productVC.dismiss(animated: true)
            if !isSuccess {
                print(error?.localizedDescription ?? "")
                return
            }
        }
        sourceVC.showDetailViewController(productVC, sender: sourceVC)
    }

    /// 打开手机上安装的系统app
    /// - Parameters:
    ///   - app:系统App枚举
    ///   - completion:完成回调
    static func openSystemApp(_ app: CMSystemApp, completion: @escaping Callbacks.BoolResult) {
        openURL(app.url, completion: completion)
    }

    /// 打开手机上安装的第三方App
    /// - Parameters:
    ///   - app:第三方app枚举
    ///   - completion:完成回调
    static func openOtherApp(_ app: CMOtherApp, completion: @escaping Callbacks.BoolResult) {
        openURL(app.url, completion: completion)
    }

    /// 拨打电话操作
    /// - Parameters:
    ///   - phoneNumber:要拨打的电话号码
    ///   - completion:完成回调
    static func call(with phoneNumber: String, completion: @escaping Callbacks.BoolResult) {
        // 判断是否有效
        guard let phoneNumberEncoding = ("tel://" + phoneNumber)
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: phoneNumberEncoding),
            UIApplication.shared.canOpenURL(url)
        else {
            completion(false)
            return
        }
        openURL(url, completion: completion)
    }

    /// 打开指定URL地址
    /// - Parameters:
    ///   - url:要打开的URL地址
    ///   - complete:完成回调
    static func openURL(_ url: URL, completion: @escaping Callbacks.BoolResult) {
        // iOS 10.0 以前
        guard #available(iOS 10.0, *) else {
            let success = UIApplication.shared.openURL(url)
            if success {
                print("10以前可以跳转")
                completion(true)
            } else {
                print("10以前不能完成跳转")
                completion(false)
            }
            return
        }
        // iOS 10.0 以后
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                print("10以后可以跳转url")
                completion(true)
            } else {
                print("10以后不能完成跳转")
                completion(false)
            }
        }
    }
}
