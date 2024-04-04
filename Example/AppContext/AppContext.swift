//
//  AppContext.swift
//  Example
//
//  Created by 奥尔良小短腿 on 2024/4/4.
//

import UIKit
import AVFoundation
import Panda
import SnapKit
 import IQKeyboardManagerSwift

class AppContext {
    /// 是否允许旋转
    var allowRotation = true

    /// 单例
    static let current = AppContext()
    private init() {}
}

extension AppContext {
    /// 应用启动时加载
    @MainActor func launch(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // 清空桌面图标角标数量
        UIApplication.shared.applicationIconBadgeNumber = 0

        // 设置设计图尺寸(适配使用)
        SizeUtils.setupSketch(size: CGSize(width: 375, height: 812))

        // 适配Appearance
        setupAppearance()

        // 设置第三方
        initVendor()
    }
}

// MARK: - 适配
extension AppContext {
    /// 适配Appearance
    private func setupAppearance() {
        UIView.fitAllView(userInterfaceStyle: .light)
        UIScrollView.fitAllScrollView()
        UITableView.fitAllTableView()
        UINavigationBar.fitAllNavigationBar()
    }
}

// MARK: - 第三方设置
extension AppContext {
    /// 初始化第三方框架
    @MainActor private func initVendor() {
        // 设置键盘管理
        setupIQKeyboardManager()
    }

    /// 设置键盘管理
    @MainActor private func setupIQKeyboardManager() {
        // 初始化键盘管理
        let keyboardManager = IQKeyboardManager.shared
        // 控制整个功能是否启用.
        keyboardManager.enable = true
        // 控制点击背景是否收起键盘
        keyboardManager.resignOnTouchOutside = true
        // 控制是否显示键盘上的工具条
        keyboardManager.enableAutoToolbar = true
        // 最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键,自动跳转到下一个输入框,最后一个输入框点击完成,自动收起键盘
        keyboardManager.toolbarConfiguration.manageBehavior = .byPosition
        // 将右边Done改成完成
        keyboardManager.toolbarConfiguration.doneBarButtonConfiguration = IQBarButtonItemConfiguration(title: "完成")
        
        
    }
}

extension AppContext {
    func tabBarController() -> PDTabBarController {
        let vm = PDTabBarViewModel()
        vm.normalColor = .gray
        vm.selectedColor = .black
        vm.titleFont = UIFont.pingFang(.semibold, size: 13)
        vm.titles = ["首页", "日历", "广场", "我的"]
        vm.imageNames = ["tab_home", "tab_calendar", "tab_square", "tab_mine"]
        vm.controllers = [HomeViewController(), CalendarViewController(), SquareViewController(), MineViewController()]
        let tabBarVC = PDTabBarController(vm: vm)
        return tabBarVC
    }
}
