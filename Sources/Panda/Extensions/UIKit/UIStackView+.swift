//
//  UIStackView+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - Defaultable
public extension UIStackView {
    typealias Associatedtype = UIStackView

    override class func `default`() -> Associatedtype {
        let stackView = UIStackView()
        return stackView
    }
}

// MARK: - 链式语法
public extension UIStackView {
    /// 布局时是否参照基准线,默认是 `false`(决定了垂直轴如果是文本的话,是否按照 `baseline` 来参与布局)
    /// - Parameter arrangement:是否参照基线
    /// - Returns:`Self`
    @discardableResult
    func pd_isBaselineRelativeArrangement(_ arrangement: Bool) -> Self {
        isBaselineRelativeArrangement = arrangement
        return self
    }

    /// 设置布局时是否以控件的`LayoutMargins`为标准,默认为 `false`,是以控件的`bounds`为标准
    /// - Parameter arrangement:是否以控件的`LayoutMargins`为标准
    /// - Returns:`Self`
    @discardableResult
    func pd_isLayoutMarginsRelativeArrangement(_ arrangement: Bool) -> Self {
        isLayoutMarginsRelativeArrangement = arrangement
        return self
    }

    /// 子控件布局方向(水平或者垂直),也就是轴方向
    /// - Parameter axis:轴方向
    /// - Returns:`Self`
    @discardableResult
    func pd_axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }

    /// 子视图在轴向上的分布方式
    /// - Parameter distribution:分布方式
    /// - Returns:`Self`
    @discardableResult
    func pd_distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }

    /// 对齐模式
    /// - Parameter alignment:对齐模式
    /// - Returns:`Self`
    @discardableResult
    func pd_alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }

    /// 设置子控件间距
    /// - Parameter spacing:子控件间距
    /// - Returns:`Self`
    @discardableResult
    func pd_spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

    /// 添加排列子视图
    /// - Parameter items:子视图
    /// - Returns:`Self`
    @discardableResult
    func pd_addArrangedSubviews(_ items: UIView...) -> Self {
        if items.isEmpty {
            return self
        }

        items.compactMap { $0 }.forEach {
            addArrangedSubview($0)
        }
        return self
    }
}
