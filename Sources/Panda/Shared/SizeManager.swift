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
        if Panda.dev.isIPad {
            if Panda.dev.isLandscape {}
            return 44
        }

        if Panda.dev.isLandscape {}
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
        Panda.dev.isIphoneXSeries ? 34 : 0
    }

    /// 整个tabBar高度
    static var tabBarHeight: CGFloat {
        tabBarItemHeight + indentHeight
    }
}
