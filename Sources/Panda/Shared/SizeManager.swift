//
//  SizeManager.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

import UIKit

public class SizeManager {}

// MARK: - 屏幕
public extension SizeManager {
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
            return UIWindow.mainWindow?.safeAreaInsets ?? .zero
        }
        return .zero
    }
}

// MARK: - 导航
public extension SizeManager {
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            if let statusbar = UIWindow.mainWindow?.windowScene?.statusBarManager {
                return statusbar.statusBarFrame.size.height
            }
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
        return 0
    }

    /// 标题栏高度
    static var titleBarHeight: CGFloat {
        if DevTool.isIPad {
            if DevTool.isLandscape {}
            return 44
        }

        if DevTool.isLandscape {}
        return 44
    }

    /// 状态栏 + 标题栏
    static var navigationBarHeight: CGFloat {
        statusBarHeight + titleBarHeight
    }
}

/// 标签栏
public extension SizeManager {
    /// 按钮区域高度
    static var tabBarItemHeight: CGFloat {
        49
    }

    /// 底部缩进高度
    static var indentHeight: CGFloat {
        DevTool.isIphoneXSeries ? 34 : 0
    }

    /// 整个tabBar高度
    static var tabBarHeight: CGFloat {
        tabBarItemHeight + indentHeight
    }
}

//MARK: - 设计图尺寸
public extension SizeManager {
    /// 设计图对应的屏幕尺寸
    fileprivate static var sketchSize = CGSize(width: 375, height: 812)
    /// 设置设计图尺寸
    static func setupSketch(size: CGSize) {
        sketchSize = size
    }
}

//MARK: - 计算比例
fileprivate extension SizeManager {
    /// 宽度比例
    static var widthRatio: CGFloat {
        var sketchW: CGFloat = min(sketchSize.width, sketchSize.height)
        var screenW: CGFloat = min(screenWidth, screenHeight)
        if DevTool.isLandscape {
            sketchW = max(sketchSize.width, sketchSize.height)
            screenW = max(screenWidth, screenHeight)
        }
        return screenW / sketchW
    }

    /// 高度比例
    static var heightRatio: CGFloat {
        var sketchH: CGFloat = max(sketchSize.width, sketchSize.height)
        var screenH: CGFloat = max(screenWidth, screenHeight)
        if DevTool.isLandscape {
            sketchH = min(sketchSize.width, sketchSize.height)
            screenH = min(screenWidth, screenHeight)
        }
        return screenH / sketchH
    }

    /// 把尺寸数据转换成`CGFloat`格式
    /// - Parameter value: 要转换的数据
    /// - Returns: `CGFloat`格式
    static func toCGFloat(from value: Any) -> CGFloat {
        if let value = value as? CGFloat {
            return value
        }

        if let value = value as? Double {
            return value
        }

        if let value = value as? Float {
            return value.toCGFloat()
        }

        if let value = value as? Int {
            return value.toCGFloat()
        }
        return 0
    }
}

// MARK: - 计算方法
fileprivate extension SizeManager {
    
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
        DevTool.isIPad ? toCGFloat(from: value) * 1.5 : toCGFloat(from: value)
    }
    
}

// MARK: - 屏幕适配(整形)
public extension BinaryInteger {
    /// 适配宽度
    var w: CGFloat { SizeManager.fitMax(from: self) }

    /// 适配高度
    var h: CGFloat { SizeManager.fitHeight(from: self) }

    /// 最大适配(特殊情况)
    var max: CGFloat { SizeManager.fitMax(from: self) }

    /// 最小适配(特殊情况)
    var min: CGFloat { SizeManager.fitMin(from: self) }

    /// 字体大小配置
    var font: CGFloat { SizeManager.fitFont(from: self) }
}

// MARK: - 屏幕适配(浮点)
public extension BinaryFloatingPoint {
    /// 适配宽度
    var w: CGFloat { SizeManager.fitMax(from: self) }

    /// 适配高度
    var h: CGFloat { SizeManager.fitHeight(from: self) }

    /// 最大适配(特殊情况)
    var max: CGFloat { SizeManager.fitMax(from: self) }

    /// 最小适配(特殊情况)
    var min: CGFloat { SizeManager.fitMin(from: self) }

    /// 字体大小配置
    var font: CGFloat { SizeManager.fitFont(from: self) }
}
