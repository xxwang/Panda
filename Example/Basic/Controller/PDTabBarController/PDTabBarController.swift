//
//  PDTabBarController.swift
//  Example
//
//  Created by 奥尔良小短腿 on 2024/4/4.
//

import UIKit

class PDTabBarController: UITabBarController {

    private var viewModel: PDTabBarViewModel!
    
    lazy var tabBar: PDTabBar = {
        let tabBar = PDTabBar(frame: CGRect(
            x: 0, y: 0,
            width: SizeUtils.screenWidth,
            height: SizeUtils.tabBarFullHeight
        ))
        return tabBar
    }()
    
    init(vm: PDTabBarViewModel) {
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置自定义tabBar
        self.setValue(tabBar, forKey: "tabBar")
        
        self.pd_overrideUserInterfaceStyle(self.selectedViewController?.overrideUserInterfaceStyle ?? .light)
            .pd_backgroundColor(.white)
            .pd_delegate(self)
            .pd_viewControllers(viewModel.controllers())
            .pd_selectedIndex(self.viewModel.selectedIndex)
        
        self.tabBar
            .pd_isTranslucent(false)
            .pd_backgroundColor(with: .gray.alpha(0.3))
            .pd_shadowImage(UIImage(with: .clear))
            .pd_titleFont(UIFont.boldSystemFont(ofSize: 12), state: .normal)
            .pd_titleFont(UIFont.systemFont(ofSize: 15), state: .selected)
            .pd_titleColor("#515151".toHexColor(), state: .normal)
            .pd_titleColor("#40DE5A".toHexColor(), state: .selected)
    }
}

extension PDTabBarController {
    /// 更新WBTabBar
    func updateWBTabBar() {
        // 更新布局
        let top = SizeUtils.screenHeight - SizeUtils.tabBarFullHeight
        WBTabBar.frame = CGRect(x: 0, y: top, width: SizeUtils.screenWidth, height: SizeUtils.tabBarFullHeight)

        // 重新布局子控件
        WBTabBar.relayout()

        // 绘制tabBar背景图层
        WBTabBar.drawMaskLayer()
    }
}

// MARK: - 系统方法
extension PDTabBarController {
    /// 是否接收屏幕旋转
    override var shouldAutorotate: Bool {
        self.selectedViewController?.shouldAutorotate ?? false
    }

    /// 屏幕支持的方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }

    /// 子控制器状态栏样式
    override var childForStatusBarStyle: UIViewController? {
        self.selectedViewController
    }

    /// 子控制器状态栏是否隐藏
    override var childForStatusBarHidden: UIViewController? {
        self.selectedViewController
    }

    /// 是否隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        self.selectedViewController?.prefersStatusBarHidden ?? false
    }

    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        selectedViewController?.preferredStatusBarStyle ?? .default
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
        selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
}

// MARK: - UITabBarDelegate
extension PDTabBarController: UITabBarDelegate {
    
}


// MARK: - PDTabBarDelegate
extension PDTabBarController: PDTabBarDelegate {
    
}
