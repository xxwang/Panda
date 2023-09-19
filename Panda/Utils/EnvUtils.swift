//
//  EnvUtils.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

import UIKit

public class EnvUtils {
    public static let shared = EnvUtils()
    private init() {}
}

// MARK: - 开发环境
public extension EnvUtils {
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

// MARK: - 设备
public extension EnvUtils {
    /// 是否是`iPad`
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    /// 是否是`iPhone`
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    /// 是否是`iPhoneX`系列
    static var isIPhoneX: Bool {
        if #available(iOS 11, *) {
            return max(SizeUtils.safeDistanceLeft, SizeUtils.safeDistanceBottom) > 0
        }
        return false
    }

    /// 是否是横屏
    static var isLandscape: Bool {
        var isLand = false
        if #available(iOS 13, *) {
            isLand = [.landscapeLeft, .landscapeRight].contains(UIDevice.current.orientation)
        } else {
            isLand = UIApplication.shared.statusBarOrientation.isLandscape
        }

        if let window = UIWindow.main, isLand == false {
            isLand = window.pd_width > window.pd_height
        }
        return isLand
    }
}

// MARK: - 系统
public extension EnvUtils {
    /// 系统类型枚举
    enum OSType: String {
        case macOS
        case iOS
        case tvOS
        case watchOS
        case Linux
    }

    /// 系统类型
    static var current: OSType {
        #if os(macOS)
            return .macOS
        #elseif os(iOS)
            return .iOS
        #elseif os(tvOS)
            return .tvOS
        #elseif os(watchOS)
            return .watchOS
        #elseif os(Linux)
            return .Linux
        #endif
    }
}

// MARK: - 应用运行环境
public extension EnvUtils {
    // MARK: - 应用程序运行环境枚举
    enum RunEnv {
        /// 应用程序正在调试模式下运行
        case debug
        /// 应用程序是从testFlight安装的
        case testFlight
        /// 应用程序是从应用商店安装的
        case appStore
    }

    /// 当前应用程序的运行环境
    static var runEnv: RunEnv {
        #if DEBUG
            return .debug
        #elseif targetEnvironment(simulator)
            return .debug
        #else
            if let _ = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") {
                return .testFlight
            }

            guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
                return .debug
            }

            if appStoreReceiptURL.lastPathComponent.lowercased() == "sandboxreceipt" {
                return .testFlight
            }

            if appStoreReceiptURL.path.lowercased().contains("simulator") {
                return .debug
            }
            return .appStore
        #endif
    }
}
