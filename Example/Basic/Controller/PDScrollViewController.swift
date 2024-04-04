//
//  PDScrollViewController.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import UIKit

class PDScrollViewController: PDViewController {
    /// 滚动视图
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.default()
            .pd_delegate(self)
            .pd_showsHorizontalScrollIndicator(false)
            .pd_showsVerticalScrollIndicator(false)
        return scrollView
    }()

    /// 内容视图
    lazy var contentView: UIView = {
        let view = UIView.default()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加到导航栏下面 确保导航栏阴影可以正常显示
        self.view.insertSubview(self.scrollView, belowSubview: self.navigationBar)
        self.scrollView.pd_frame(CGRect(
            x: 0,
            y: self.navigationBar.isHidden ? 0 : self.navigationBar.pd_height,
            width: self.view.pd_width,
            height: self.view.pd_height - (self.navigationBar.isHidden ? 0 : self.navigationBar.pd_height)
        ))

        // 内容容器
        self.contentView.add2(self.scrollView)

        // 使内容容器填充滚动视图
        self.fill(scrollWhenNotFilled: true)
    }
}

// MARK: - 常用方法
extension PDScrollViewController {
    /// 填充内容视图
    /// - Parameter scrollWhenNotFilled: 是否在未撑满时允许滚动
    func fill(scrollWhenNotFilled: Bool) {
        self.contentView.pd_frame(CGRect(
            x: 0,
            y: 0,
            width: self.scrollView.pd_width,
            height: self.scrollView.pd_height + (scrollWhenNotFilled ? 1 : 0)
        ))

        self.scrollView.pd_contentSize(CGSize(
            width: self.scrollView.pd_width,
            height: self.scrollView.pd_height + (scrollWhenNotFilled ? 1 : 0)
        ))
    }

    /// 更新内容视图高度
    /// - Parameter heightForContentView: 内容容器高度
    func update(heightForContentView: CGFloat) {
        self.contentView.pd_frame(CGRect(
            x: 0,
            y: 0,
            width: self.scrollView.pd_width,
            height: heightForContentView
        ))

        self.scrollView.pd_contentSize(CGSize(
            width: self.scrollView.pd_width,
            height: heightForContentView
        ))
    }
}

// MARK: - UIScrollViewDelegate
extension PDScrollViewController: UIScrollViewDelegate {}
