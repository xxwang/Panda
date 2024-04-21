//
//  Bundle+.swift
//
//
//  Created by xxwang on 2023/5/24.
//

import UIKit

// MARK: - 静态属性
public extension Bundle {
    /// `Info.plist`
    static var infoDic: [String: Any]? {
        Bundle.main.infoDictionary
    }

    /// app的版本号`CFBundleShortVersionString`
    static var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    /// app的编译版本号`CFBundleVersion`
    static var buildVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    /// 获取app的 `bundleIdentifier`
    static var bundleId: String? {
        Bundle.main.bundleIdentifier
    }

    /// 使用反射时的命名空间(app工程名称)`CFBundleExecutable`
    static var namespace: String? {
        infoDic?["CFBundleExecutable"] as? String
    }

    /// 可执行文件名称`kCFBundleExecutableKey`
    static var executableName: String? {
        let name = kCFBundleExecutableKey as String
        return infoDic?[name] as? String
    }

    /// App 名称`CFBundleDisplayName`/`CFBundleExecutable`/`CFBundleName`
    static var displayName: String? {
        if let appName = infoDic?["CFBundleDisplayName"] as? String {
            return appName
        }

        if let appName = infoDic?["CFBundleExecutable"] as? String {
            return appName
        }

        if let appName = infoDic?["CFBundleName"] as? String {
            return appName
        }

        return nil
    }

    /// 设备信息的获取
    static var userAgent: String {
        // 可执行程序名称
        let executable = executableName ?? "Unknown"
        // 应用标识
        let bundleID = bundleId ?? "Unknown"
        // 应用版本
        let version = buildVersion ?? "Unknown"

        // 操作系统名称
        let osName = UIDevice.current.systemName
        // 操作系统版本
        let osVersion = UIDevice.current.systemVersion
        let osNameVersion = "\(osName) \(osVersion)"

        return "\(executable)/\(bundleID) (\(version); \(osNameVersion))"
    }

    /// 本地化`kCFBundleLocalizationsKey`
    static var localization: String? {
        guard let content = infoDic?[String(kCFBundleLocalizationsKey)] else {
            return nil
        }
        return content as? String
    }

    /// 应用商店`收据URL`(`appStoreReceiptURL`)
    static var storeReceiptURL: URL? {
        Bundle.main.appStoreReceiptURL
    }
}

// MARK: - 方法
public extension Bundle {
    /// 获取项目中文件的`path`
    /// - Parameters:
    ///   - fileName:文件名称
    ///   - ext:后缀名称
    /// - Returns:对应路径
    static func pd_path(for fileName: String?, withExtension ext: String? = nil) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: ext) else {
            return nil
        }
        return path
    }

    /// 获取项目中文件的`URL`
    /// - Parameters:
    ///   - fileName:文件名称
    ///   - ext:后缀名称
    /// - Returns:对应路径
    static func pd_url(for fileName: String?, withExtension ext: String? = nil) -> URL? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
            return nil
        }
        return url
    }
}
