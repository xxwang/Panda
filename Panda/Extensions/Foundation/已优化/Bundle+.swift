import UIKit

// MARK: - 静态属性
public extension Bundle {
    /// 返回`Info.plist`的内容字典
    /// - Returns: `Info.plist`内容字典
    static func pd_infoDict() -> [String: Any] {
        return Bundle.main.infoDictionary.pd_or([:])
    }

    /// 返回`App`的版本号
    ///
    /// - Note: `CFBundleShortVersionString`
    /// - Returns: 版本号
    static func pd_appVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String).pd_or("")
    }

    /// 返回`App`的编译版本号
    ///
    /// - Note: `CFBundleVersion`
    /// - Returns: 编译版本号
    static func pd_buildVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String).pd_or("")
    }

    /// 返回`App`的`bundleId`
    ///
    /// - Note: `bundleIdentifier`
    /// - Returns: bundleId
    static func pd_bundleId() -> String {
        return Bundle.main.bundleIdentifier.pd_or("")
    }

    /// 返回`App`工程的命名空间
    ///
    /// - Note: `CFBundleExecutable`
    /// - Returns: 命名空间
    static func pd_namespace() -> String {
        let infoDict = self.pd_infoDict()
        return (infoDict["CFBundleExecutable"] as? String).pd_or("")
    }

    /// 返回`App`的可执行文件名
    ///
    /// - Note: `kCFBundleExecutableKey`
    /// - Returns: 可执行文件名
    static func pd_executableName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDict = self.pd_infoDict()
        return (infoDict[name] as? String).pd_or("")
    }

    /// 返回`App`的`bundleName`
    ///
    /// - Note: `CFBundleName`
    /// - Returns: `bundleName`
    static func pd_bundleName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDict = self.pd_infoDict()
        return (infoDict[name] as? String).pd_or("")
    }

    /// 返回`App`在桌面显示的名称
    ///
    /// - Note: `CFBundleDisplayName`
    /// - Returns: 名称
    static func pd_displayName() -> String {
        let infoDict = self.pd_infoDict()
        return (infoDict["CFBundleDisplayName"] as? String).pd_or("")
    }

    /// 获取设备`UA`信息
    /// - Returns: 设备`UA`字符串
    static func pd_userAgent() -> String {
        // 可执行程序名称
        let executable = self.pd_executableName()
        // 应用标识
        let bundleID = self.pd_bundleId()
        // 应用版本
        let version = self.pd_buildVersion()
        // 操作系统名称
        let osName = UIDevice.current.systemName
        // 操作系统版本
        let osVersion = UIDevice.current.systemVersion
        let osNameVersion = "\(osName) \(osVersion)"

        return "\(executable)/\(bundleID) (\(version); \(osNameVersion))"
    }

    /// 获取设备的本地化信息
    ///
    /// - Note: `kCFBundleLocalizationsKey`
    /// - Returns: 本地化信息
    static func pd_localization() -> String {
        let infoDict = self.pd_infoDict()
        return (infoDict[String(kCFBundleLocalizationsKey)] as? String).pd_or("")
    }

    /// 获取应用商店的收据信息
    /// - Returns: 信息字典
    static func pd_appStoreReceiptInfo() -> [String: Any] {
        if let receiptUrl = Bundle.main.appStoreReceiptURL,
           let data = try? Data(contentsOf: receiptUrl, options: .alwaysMapped),
           let res = data.pd_jsonObject(for: [String: Any].self)
        {
            return res
        }
        return [:]
    }
}

// MARK: - 方法
public extension Bundle {
    /// 获取项目中文件的`path`
    /// - Parameters:
    ///   - fileName: 文件名称
    ///   - extension: 扩展名
    /// - Returns: 结果`path`字符串
    static func pd_path(for fileName: String?, with extension: String? = nil) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: `extension`) else {
            return nil
        }
        return path
    }

    /// 获取项目中文件的`URL`
    /// - Parameters:
    ///   - fileName: 文件名称
    ///   - extension: 扩展名
    /// - Returns: 结果`URL`
    static func pd_url(for fileName: String?, with extension: String? = nil) -> URL? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: `extension`) else {
            return nil
        }
        return url
    }
}
