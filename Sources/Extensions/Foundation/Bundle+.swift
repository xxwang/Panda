import UIKit

public extension Bundle {
    static func xx_infoDict() -> [String: Any] {
        return Bundle.main.infoDictionary.xx_or([:])
    }

    static func xx_appVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String).xx_or("")
    }

    static func xx_buildVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String).xx_or("")
    }

    static func xx_bundleId() -> String {
        return Bundle.main.bundleIdentifier.xx_or("")
    }

    static func xx_namespace() -> String {
        let infoDict = self.xx_infoDict()
        return (infoDict["CFBundleExecutable"] as? String).xx_or("")
    }

    static func xx_executableName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDict = self.xx_infoDict()
        return (infoDict[name] as? String).xx_or("")
    }

    static func xx_bundleName() -> String {
        let name = kCFBundleExecutableKey as String
        let infoDict = self.xx_infoDict()
        return (infoDict[name] as? String).xx_or("")
    }

    static func xx_displayName() -> String {
        let infoDict = self.xx_infoDict()
        return (infoDict["CFBundleDisplayName"] as? String).xx_or("")
    }

    static func xx_userAgent() -> String {
        let executable = self.xx_executableName()
        let bundleID = self.xx_bundleId()
        let version = self.xx_buildVersion()
        let osName = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let osNameVersion = "\(osName) \(osVersion)"

        return "\(executable)/\(bundleID) (\(version); \(osNameVersion))"
    }

    static func xx_localization() -> String {
        let infoDict = self.xx_infoDict()
        return (infoDict[String(kCFBundleLocalizationsKey)] as? String).xx_or("")
    }

    static func xx_appStoreReceiptInfo() -> [String: Any] {
        if let receiptUrl = Bundle.main.appStoreReceiptURL,
           let data = try? Data(contentsOf: receiptUrl, options: .alwaysMapped),
           let res = data.xx_jsonObject(for: [String: Any].self)
        {
            return res
        }
        return [:]
    }
}

public extension Bundle {
    static func xx_path(for fileName: String?, with extension: String? = nil) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: `extension`) else {
            return nil
        }
        return path
    }

    static func xx_url(for fileName: String?, with extension: String? = nil) -> URL? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: `extension`) else {
            return nil
        }
        return url
    }
}
