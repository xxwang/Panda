//
//  PDViewController.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import UIKit

open class PDViewController: UIViewController {
    /// 是否允许侧滑返回
    public var canSideBack = true

    /// 完整导航栏(状态栏 + 标题栏)
    public lazy var navigationBar: PDNavigationBar = {
        let navigationBar = PDNavigationBar()
            .backButtonImage("navbar_back_icon".toImage(), for: .normal)
            .backButtonImage("navbar_back_icon".toImage(), for: .highlighted)
            .backButtonCallback { [weak self] in
                guard let self else { return }
                let count = navigationController?.children.count ?? 0
                if count > 1 {
                    return popViewController()
                } else {
                    return dismissViewController()
                }
            }
            .titleFont(UIFont(PingFang: .semibold, size: 18))
            .titleColor(.black)
            .hiddenSeparator(false)
            .hiddenShadow(false)
            .navigationBarBackgroundColor(.white)
            .pd_rasterize()
        return navigationBar
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.pd_backgroundColor(.white)
            // 是否自动调整UIScrollView的内间距
            .pd_automaticallyAdjustsScrollViewInsets(false)
            // 界面样式
            .pd_overrideUserInterfaceStyle(.light)

        self.navigationBar.hiddenNavigationBar(self.navigationController == nil)
        self.navigationBar.add2(self.view)
    }
}

// MARK: - 生命周期
extension PDViewController {
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

// MARK: - 控制器设置
extension PDViewController {
    /// 屏幕是否可以旋转
    override open var shouldAutorotate: Bool { false }

    /// 屏幕方向
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    /// 是否隐藏状态栏
    override open var prefersStatusBarHidden: Bool { false }

    /// 状态栏样式
    override open var preferredStatusBarStyle: UIStatusBarStyle { .default }

    /// 监听屏幕旋转
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}

// MARK: UIGestureRecognizerDelegate
extension PDViewController: UIGestureRecognizerDelegate {
    open func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        if (navigationController?.children.count ?? 0) > 1 { return canSideBack }
        return false
    }
}
