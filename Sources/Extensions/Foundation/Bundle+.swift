import UIKit

public extension Bundle {

    static func pd_infoDict() -> [String: Any] {
        return Bundle.main.infoDictionary.pd_or([:])
    }

    static func pd_appVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String).pd_or("")
    }

    static func pd_buildVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String).pd_or("")
    }

    static func pd_bundleId() -> String {
        return Bundle.main.bundleIdentifier.pd_or("")
    }

    static func pd_namespace() -> String {
        let infoDict = self.pd_infoDict()
        return (infoDict["CFBundleExecutable"] as? String).pd_or("")
    }

    static func pd_executableName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDict = self.pd_infoDict()
        return (infoDict[name] as? String).pd_or("")
    }

    static func pd_bundleName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDict = self.pd_infoDict()
        return (infoDict[name] as? String).pd_or("")
    }

    static func pd_displayName() -> String {
        let infoDict = self.pd_infoDict()
        return (infoDict["CFBundleDisplayName"] as? String).pd_or("")
    }

    static func pd_userAgent() -> String {
        let executable = self.pd_executableName()
        let bundleID = self.pd_bundleId()
        let version = self.pd_buildVersion()
        let osName = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let osNameVersion = "\(osName) \(osVersion)"

        return "\(executable)/\(bundleID) (\(version); \(osNameVersion))"
    }

    static func pd_localization() -> String {
        let infoDict = self.pd_infoDict()
        return (infoDict[String(kCFBundleLocalizationsKey)] as? String).pd_or("")
    }

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

public extension Bundle {

    static func pd_path(for fileName: String?, with extension: String? = nil) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: `extension`) else {
            return nil
        }
        return path
    }

    static func pd_url(for fileName: String?, with extension: String? = nil) -> URL? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: `extension`) else {
            return nil
        }
        return url
    }
}
