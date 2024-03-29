//
//  SizeUtils.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

import UIKit

public class SizeUtils {}

// MARK: - 屏幕
public extension SizeUtils {
    /// 屏幕Bounds
    static var screenBounds: CGRect { UIScreen.main.bounds }
    /// 屏幕尺寸
    static var screenSize: CGSize { screenBounds.size }
    /// 屏幕宽度
    static var screenWidth: CGFloat { screenSize.width }
    /// 屏幕高度
    static var screenHeight: CGFloat { screenSize.height }

    /// 屏幕安全区
    static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIWindow.main?.safeAreaInsets ?? .zero
        }
        return .zero
    }

    /// 顶部安全距离
    static var safeDistanceTop: CGFloat { safeAreaInsets.top }
    /// 底部安全距离
    static var safeDistanceBottom: CGFloat { safeAreaInsets.bottom }
    /// 左边安全距离
    static var safeDistanceLeft: CGFloat { safeAreaInsets.left }
    /// 右边安全距离
    static var safeDistanceRight: CGFloat { safeAreaInsets.right }
}

// MARK: - 导航
public extension SizeUtils {
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            if let statusbar = UIWindow.main?.windowScene?.statusBarManager {
                return statusbar.statusBarFrame.size.height
            }
            return 0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }

    /// 标题栏高度
    static var titleBarHeight: CGFloat { 44 }
    /// 状态栏 + 标题栏
    static var navigationFullHeight: CGFloat { statusBarHeight + titleBarHeight }
}

/// 标签栏
public extension SizeUtils {
    /// 按钮区域高度
    static var tabBarHeight: CGFloat { 49 }
    /// 底部缩进高度
    static var indentHeight: CGFloat { safeDistanceBottom }
    /// 整个tabBar高度
    static var tabBarFullHeight: CGFloat { tabBarHeight + indentHeight }
}

// MARK: - 设计图尺寸
public extension SizeUtils {
    /// 设计图对应的屏幕尺寸
    fileprivate static var sketchSize = CGSize(width: 375, height: 812)
    /// 设置设计图尺寸
    static func setupSketch(size: CGSize) { sketchSize = size }
}

// MARK: - 计算比例
private extension SizeUtils {
    /// 宽度比例
    static var widthRatio: CGFloat {
        var sketchW: CGFloat = min(sketchSize.width, sketchSize.height)
        var screenW: CGFloat = min(screenWidth, screenHeight)
        if EnvUtils.isLandscape {
            sketchW = max(sketchSize.width, sketchSize.height)
            screenW = max(screenWidth, screenHeight)
        }
        return screenW / sketchW
    }

    /// 高度比例
    static var heightRatio: CGFloat {
        var sketchH: CGFloat = max(sketchSize.width, sketchSize.height)
        var screenH: CGFloat = max(screenWidth, screenHeight)
        if EnvUtils.isLandscape {
            sketchH = min(sketchSize.width, sketchSize.height)
            screenH = min(screenWidth, screenHeight)
        }
        return screenH / sketchH
    }

    /// 把尺寸数据转换成`CGFloat`格式
    /// - Parameter value: 要转换的数据
    /// - Returns: `CGFloat`格式
    static func toCGFloat(from value: Any) -> CGFloat {
        if let value = value as? CGFloat { return value }
        if let value = value as? Double { return value }
        if let value = value as? Float { return value.toCGFloat() }
        if let value = value as? Int { return value.toCGFloat() }
        return 0
    }
}

// MARK: - 计算方法
private extension SizeUtils {
    /// 计算`宽度`
    static func fitWidth(from value: Any) -> CGFloat {
        widthRatio * toCGFloat(from: value)
    }

    /// 计算`高度`
    static func fitHeight(from value: Any) -> CGFloat {
        heightRatio * toCGFloat(from: value)
    }

    /// 计算`最大宽高`
    static func fitMax(from value: Any) -> CGFloat {
        Swift.max(fitWidth(from: value), fitHeight(from: value))
    }

    /// 计算`最小宽高`
    static func fitMin(from value: Any) -> CGFloat {
        Swift.min(fitWidth(from: value), fitHeight(from: value))
    }

    /// 适配`字体大小`
    static func fitFont(from value: Any) -> CGFloat {
        EnvUtils.isIPad ? toCGFloat(from: value) * 1.5 : toCGFloat(from: value)
    }
}

// MARK: - 屏幕适配(整形)
public extension BinaryInteger {
    /// 适配宽度
    var w: CGFloat { SizeUtils.fitMax(from: self) }

    /// 适配高度
    var h: CGFloat { SizeUtils.fitHeight(from: self) }

    /// 最大适配(特殊情况)
    var max: CGFloat { SizeUtils.fitMax(from: self) }

    /// 最小适配(特殊情况)
    var min: CGFloat { SizeUtils.fitMin(from: self) }

    /// 字体大小配置
    var font: CGFloat { SizeUtils.fitFont(from: self) }
}

// MARK: - 屏幕适配(浮点)
public extension BinaryFloatingPoint {
    /// 适配宽度
    var w: CGFloat { SizeUtils.fitMax(from: self) }

    /// 适配高度
    var h: CGFloat { SizeUtils.fitHeight(from: self) }

    /// 最大适配(特殊情况)
    var max: CGFloat { SizeUtils.fitMax(from: self) }

    /// 最小适配(特殊情况)
    var min: CGFloat { SizeUtils.fitMin(from: self) }

    /// 字体大小配置
    var font: CGFloat { SizeUtils.fitFont(from: self) }
}
