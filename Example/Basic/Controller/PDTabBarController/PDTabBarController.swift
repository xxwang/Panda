//
//  PDTabBarController.swift
//  Example
//
//  Created by 奥尔良小短腿 on 2024/4/4.
//

import Panda
import UIKit

class PDTabBarController: UITabBarController {
    private var viewModel: PDTabBarViewModel!

    lazy var customTabBar: PDTabBar = {
        let tabBar = PDTabBar(
            vm: self.viewModel,
            frame: CGRect(x: 0, y: 0, width: sizer.screen.width, height: sizer.tab.fullHeight)
        )
        tabBar.customDelegate = self
        tabBar.delegate = self
        return tabBar
    }()
    
    init(vm: PDTabBarViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置自定义tabBar
        self.setValue(customTabBar, forKey: "tabBar")

        self.pd_overrideUserInterfaceStyle(self.selectedViewController?.overrideUserInterfaceStyle ?? .light)
            .pd_backgroundColor(.white)
            .pd_delegate(self)
            .pd_viewControllers(viewModel.viewControllers())
            .pd_selectedIndex(self.viewModel.selectedIndex)

        self.customTabBar
            .pd_isTranslucent(false)
            .pd_backgroundColor(with: .clear)
            .pd_shadowImage(UIImage(with: .clear))
            .pd_titleFont(UIFont.boldSystemFont(ofSize: 12), state: .normal)
            .pd_titleFont(UIFont.systemFont(ofSize: 15), state: .selected)
            .pd_titleColor("#515151".pd_hexColor(), state: .normal)
            .pd_titleColor("#40DE5A".pd_hexColor(), state: .selected)
    }
}

extension PDTabBarController {
    /// 更新PDTabBar
    func updateTabBar() {
        // 更新布局
        let top = sizer.screen.height - sizer.tab.fullHeight
        self.customTabBar.frame = CGRect(x: 0, y: top, width: sizer.screen.width, height: sizer.tab.fullHeight)

        // 重新布局子控件
        self.customTabBar.relayout()

        // 绘制tabBar背景图层
        self.customTabBar.drawMask()
    }
}

// MARK: - 系统方法
extension PDTabBarController {
    /// 是否接收屏幕旋转
    override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }

    /// 屏幕支持的方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }

    /// 子控制器状态栏样式
    override var childForStatusBarStyle: UIViewController? {
        return self.selectedViewController
    }

    /// 子控制器状态栏是否隐藏
    override var childForStatusBarHidden: UIViewController? {
        return self.selectedViewController
    }

    /// 是否隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return self.selectedViewController?.prefersStatusBarHidden ?? false
    }

    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.selectedViewController?.preferredStatusBarStyle ?? .default
    }

    /// 安全区域发生变化
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        self.updateTabBar()
    }

    /// 转场
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.updateTabBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateTabBar()
    }
}

// MARK: UITabBarControllerDelegate
extension PDTabBarController: UITabBarControllerDelegate {
    /// 即将选中
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    /// 已经选中
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.selectedViewController = viewController
    }

    /// 屏幕支持的方向
    func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
}

// MARK: - UITabBarDelegate
extension PDTabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {}

    override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {}

    override func tabBar(_ tabBar: UITabBar, didBeginCustomizing items: [UITabBarItem]) {}

    override func tabBar(_ tabBar: UITabBar, willEndCustomizing items: [UITabBarItem], changed: Bool) {}

    override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {}
}

// MARK: - PDTabBarDelegate
extension PDTabBarController: PDTabBarDelegate {
    func tabBarButtonClick(_ tabBar: PDTabBar, clicked index: Int) {
        if selectedIndex == index { return }

        self.selectedIndex = index
    }

    func middleButtonClick(tabBar: PDTabBar, button: UIButton, rect: CGRect) {
        Logger.info("123")
    }
}
