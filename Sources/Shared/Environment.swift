import UIKit

public class environment {
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}

public extension environment {
    static var system: String {
        #if os(macOS)
            return "macOS"
        #elseif os(iOS)
            return "iOS"
        #elseif os(tvOS)
            return "tvOS"
        #elseif os(watchOS)
            return "watchOS"
        #elseif os(Linux)
            return "Linux"
        #endif
    }

    static var runEnv: String {
        #if DEBUG
            return "development"
        #elseif targetEnvironment(simulator)
            return "development"
        #else
            if let _ = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") {
                return "testFlight"
            }

            guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
                return "development"
            }

            if appStoreReceiptURL.lastPathComponent.lowercased() == "sandboxreceipt" {
                return "testFlight"
            }

            if appStoreReceiptURL.path.lowercased().contains("simulator") {
                return "development"
            }
            return "appStore"
        #endif
    }
}

public extension environment {

    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    static var isIPhoneX: Bool {
        if #available(iOS 11, *) {
            return max(sizer.safeArea.left, sizer.safeArea.bottom) > 0
        }
        return false
    }

    static var isLandscape: Bool {
        var isLandscape = false
        if #available(iOS 13, *) {
            isLandscape = [.landscapeLeft, .landscapeRight].contains(UIDevice.current.orientation)
        } else {
            isLandscape = UIApplication.shared.statusBarOrientation.isLandscape
        }

        if let window = UIWindow.xx_main, isLandscape == false {
            isLandscape = window.xx_width > window.xx_height
        }
        return isLandscape
    }
}
