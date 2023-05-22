//
//  UIScrollView+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 属性
public extension UIScrollView {
    /// 滚动视图的当前可见区域
    var visibleRect: CGRect {
        let contentWidth = contentSize.width - contentOffset.x
        let contentHeight = contentSize.height - contentOffset.y
        return CGRect(
            origin: contentOffset,
            size: CGSize(width: Swift.min(Swift.min(bounds.size.width, contentSize.width), contentWidth),
                         height: Swift.min(Swift.min(bounds.size.height, contentSize.height), contentHeight))
        )
    }
}

// MARK: - 适配
public extension UIScrollView {
    /// 适配当前`UIScrollView`
    func fitScrollView() {
        if #available(iOS 11.0, *) {
            // 取消滚动视图自动缩进
            self.contentInsetAdjustmentBehavior = .never
        }
    }

    /// 适配项目中所有`UIScrollView`
    static func fitAllScrollView() {
        if #available(iOS 11.0, *) {
            // 取消滚动视图自动缩进
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
    }
}

// MARK: - Defaultable
public extension UIScrollView {
    typealias Associatedtype = UIScrollView

    override class func `default`() -> UIScrollView {
        let scrollView = UIScrollView()
        return scrollView
    }
}

// MARK: - 链式语法
public extension UIScrollView {
    /// 设置代理
    /// - Parameter delegate:代理
    /// - Returns:`Self`
    @discardableResult
    func pd_delegate(_ delegate: UIScrollViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置偏移量
    /// - Parameter offset:偏移量
    /// - Returns:`Self`
    @discardableResult
    func pd_contentOffset(_ offset: CGPoint) -> Self {
        contentOffset = offset
        return self
    }

    /// 设置滑动区域大小`CGSize`
    /// - Parameter size:滑动区域大小
    /// - Returns:`Self`
    @discardableResult
    func pd_contentSize(_ size: CGSize) -> Self {
        contentSize = size
        return self
    }

    /// 设置边缘插入内容以外的可滑动区域(`UIEdgeInsets`),默认是`UIEdgeInsetsZero`(提示:必须设置`contentSize`后才有效)
    /// - Parameter inset:`UIEdgeInsets`
    /// - Returns:`Self`
    @discardableResult
    func pd_contentInset(_ inset: UIEdgeInsets) -> Self {
        contentInset = inset
        return self
    }

    ///  设置弹性效果,默认是`true`, 如果设置成`false`,则当你滑动到边缘时将不具有弹性效果
    /// - Parameter bounces:是否有弹性
    /// - Returns:`Self`
    @discardableResult
    func pd_bounces(_ bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }

    /// 水平方向 总是可以弹性滑动,默认是 `false`
    /// - Parameter bounces:是否有弹性
    /// - Returns:`Self`
    @discardableResult
    func pd_alwaysBounceHorizontal(_ bounces: Bool) -> Self {
        alwaysBounceHorizontal = bounces
        return self
    }

    /// 竖直方向总是可以弹性滑动,默认是 `false`
    /// - Parameter bounces:是否有弹性
    /// - Returns:`Self`
    @discardableResult
    func pd_alwaysBounceVertical(_ bounces: Bool) -> Self {
        alwaysBounceVertical = bounces
        return self
    }

    /// 设置是否可分页,默认是`false`, 如果设置成`true`, 则可分页
    /// - Parameter enabled:是否可分页
    /// - Returns:`Self`
    @discardableResult
    func pd_isPagingEnabled(_ enabled: Bool) -> Self {
        isPagingEnabled = enabled
        return self
    }

    /// 是否显示 水平 方向滑动条,默认是`true`, 如果设置为`false`,当滑动的时候则不会显示水平滑动条
    /// - Parameter enabled:是否显示水平方向滑动条
    /// - Returns:`Self`
    @discardableResult
    func pd_showsHorizontalScrollIndicator(_ enabled: Bool) -> Self {
        showsHorizontalScrollIndicator = enabled
        return self
    }

    /// 是否显示 垂直 方向滑动条,默认是`true`, 如果设置为`false`,当滑动的时候则不会显示水平滑动条
    /// - Parameter enabled:是否显示垂直方向滑动条
    /// - Returns:`Self`
    @discardableResult
    func pd_showsVerticalScrollIndicator(_ enabled: Bool) -> Self {
        showsVerticalScrollIndicator = enabled
        return self
    }

    /// 设置滑动条的边缘插入,即是距离上、左、下、右的距离,比如:top(20) 当向下滑动时,滑动条距离顶部的距离总是 20
    /// - Parameter inset:`UIEdgeInset`
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollIndicatorInsets(_ inset: UIEdgeInsets) -> Self {
        scrollIndicatorInsets = inset
        return self
    }

    /// 是否可滑动,默认是true, 如果默认为`false`, 则无法滑动
    /// - Parameter enabled:是否可滑动
    /// - Returns:`Self`
    @discardableResult
    func pd_isScrollEnabled(_ enabled: Bool) -> Self {
        isScrollEnabled = enabled
        return self
    }

    /// 设置滑动条颜色,默认是灰白色
    /// - Parameter indicatorStyle:滑动条颜色
    /// - Returns:`Self`
    @discardableResult
    func pd_indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        indicatorStyle = style
        return self
    }

    /// 设置减速率,`CGFloat`类型,当你滑动松开手指后的减速速率, 但是尽管`decelerationRate`是一个`CGFloat`类型,但是目前系统只支持以下两种速率设置选择:`fast` 和 `normal`
    /// - Parameter rate:减速率
    /// - Returns:`Self`
    @discardableResult
    func pd_decelerationRate(_ rate: UIScrollView.DecelerationRate) -> Self {
        decelerationRate = rate
        return self
    }

    /// 锁住水平或竖直方向的滑动, 默认为`false`,如果设置为TRUE,那么在推拖拽`UIScrollView`的时候,会锁住水平或竖直方向的滑动
    /// - Parameter enabled:是否锁住
    /// - Returns:`Self`
    @discardableResult
    func pd_isDirectionalLockEnabled(_ enabled: Bool) -> Self {
        isDirectionalLockEnabled = enabled
        return self
    }
}
