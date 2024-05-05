import UIKit

public class environment {
    /// 是否是模拟器
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    /// 是否是调试模式
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}

public extension environment {
    /// 系统类型
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

    /// 当前应用程序的运行环境
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
    /// 是否是`iPad`
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    /// 是否是`iPhone`
    static var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    /// 是否是`iPhoneX`系列
    static var isIPhoneX: Bool {
        if #available(iOS 11, *) {
            return max(sizer.safeArea.left, sizer.safeArea.bottom) > 0
        }
        return false
    }

    /// 是否是横屏
    static var isLandscape: Bool {
        var isLandscape = false
        if #available(iOS 13, *) {
            isLandscape = [.landscapeLeft, .landscapeRight].contains(UIDevice.current.orientation)
        } else {
            isLandscape = UIApplication.shared.statusBarOrientation.isLandscape
        }

        if let window = UIWindow.main, isLandscape == false {
            isLandscape = window.pd_width > window.pd_height
        }
        return isLandscape
    }
}
