//
//  PDViewController.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import UIKit

class PDViewController: UIViewController {
    /// 是否允许侧滑返回
    var canSideBack = true

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 生命周期
extension PDViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 控制器背景颜色
        self.view.pd_backgroundColor(.white)

        // 取消滚动视图自动缩进
        if #available(iOS 11, *) {} else {
            // iOS11以下版本
            automaticallyAdjustsScrollViewInsets = false
        }

        // 设置页面为高亮模式 不自动适应暗黑模式
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

// MARK: - 控制器设置
extension PDViewController {
    /// 屏幕是否可以旋转
    override var shouldAutorotate: Bool { false }

    /// 屏幕方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    /// 是否隐藏状态栏
    override var prefersStatusBarHidden: Bool { false }

    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle { .default }

    /// 监听屏幕旋转
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}

// MARK: UIGestureRecognizerDelegate
extension PDViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        if (navigationController?.children.count ?? 0) > 1 { return canSideBack }
        return false
    }
}
