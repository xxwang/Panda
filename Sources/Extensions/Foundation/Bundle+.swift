import UIKit

public extension Bundle {
    static func sk_infoDict() -> [String: Any] {
        return Bundle.main.infoDictionary.sk_or([:])
    }

    static func sk_appVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String).sk_or("")
    }

    static func sk_buildVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String).sk_or("")
    }

    static func sk_bundleId() -> String {
        return Bundle.main.bundleIdentifier.sk_or("")
    }

    static func sk_namespace() -> String {
        let infoDict = self.sk_infoDict()
        return (infoDict["CFBundleExecutable"] as? String).sk_or("")
    }

    static func sk_executableName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDict = self.sk_infoDict()
        return (infoDict[name] as? String).sk_or("")
    }

    static func sk_bundleName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDict = self.sk_infoDict()
        return (infoDict[name] as? String).sk_or("")
    }

    static func sk_displayName() -> String {
        let infoDict = self.sk_infoDict()
        return (infoDict["CFBundleDisplayName"] as? String).sk_or("")
    }

    static func sk_userAgent() -> String {
        let executable = self.sk_executableName()
        let bundleID = self.sk_bundleId()
        let version = self.sk_buildVersion()
        let osName = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let osNameVersion = "\(osName) \(osVersion)"

        return "\(executable)/\(bundleID) (\(version); \(osNameVersion))"
    }

    static func sk_localization() -> String {
        let infoDict = self.sk_infoDict()
        return (infoDict[String(kCFBundleLocalizationsKey)] as? String).sk_or("")
    }

    static func sk_appStoreReceiptInfo() -> [String: Any] {
        if let receiptUrl = Bundle.main.appStoreReceiptURL,
           let data = try? Data(contentsOf: receiptUrl, options: .alwaysMapped),
           let res = data.sk_jsonObject(for: [String: Any].self)
        {
            return res
        }
        return [:]
    }
}

public extension Bundle {
    static func sk_path(for fileName: String?, with extension: String? = nil) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: `extension`) else {
            return nil
        }
        return path
    }

    static func sk_url(for fileName: String?, with extension: String? = nil) -> URL? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: `extension`) else {
            return nil
        }
        return url
    }
}
