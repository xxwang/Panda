//
//  DevTool.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

import UIKit

public class DevTool {}

// MARK: - 开发环境
public extension DevTool {
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
public extension DevTool {
    /// 是否是`iPad`
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    /// 是否是`iPhone`
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    /// 是否是`iPhoneX`系列
    static var isIPhoneXSeries: Bool {
        if #available(iOS 11, *) {
            return max(SizeManager.safeDistanceLeft, SizeManager.safeDistanceBottom) > 0
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

        if let window = UIWindow.mainWindow, isLand == false {
            isLand = window.pd_width > window.pd_height
        }
        return isLand
    }
}

// MARK: - 系统
public extension DevTool {
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
