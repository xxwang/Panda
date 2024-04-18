//
//  UICollectionViewFlowLayout++.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/3/30.
//

import UIKit

//MARK: - 链式语法
extension UICollectionViewFlowLayout {
    /// 设置滚动方向间距
    /// - Parameter spacing: 间距
    /// - Returns: `Self`
    @discardableResult
    func pd_minimumLineSpacing(_ spacing: CGFloat) -> Self {
        self.minimumLineSpacing = spacing
        return self
    }

    /// 设置垂直于滚动方向间距
    /// - Parameter spacing: 间距
    /// - Returns: `Self`
    @discardableResult
    func pd_minimumInteritemSpacing(_ spacing: CGFloat) -> Self {
        self.minimumInteritemSpacing = spacing
        return self
    }

    /// 设置`cell`大小
    /// - Parameter size: `cell`大小
    /// - Returns: `Self`
    @discardableResult
    func pd_itemSize(_ size: CGSize) -> Self {
        self.itemSize = size
        return self
    }

    /// 设置预估`cell`大小
    /// - Parameter size: 预估`cell`大小
    /// - Returns: `Self`
    @discardableResult
    func pd_estimatedItemSize(_ size: CGSize) -> Self {
        self.estimatedItemSize = size
        return self
    }

    /// 设置滚动方向
    /// - Parameter scrollDirection: 滚动方向
    /// - Returns: `Self`
    @discardableResult
    func pd_scrollDirection(_ scrollDirection: UICollectionView.ScrollDirection) -> Self {
        self.scrollDirection = scrollDirection
        return self
    }

    /// 设置头部视图大小
    /// - Parameter size: 大小
    /// - Returns: `Self`
    @discardableResult
    func pd_headerReferenceSize(_ size: CGSize) -> Self {
        self.headerReferenceSize = size
        return self
    }

    /// 设置底部视图大小
    /// - Parameter size: 大小
    /// - Returns: `Self`
    @discardableResult
    func pd_footerReferenceSize(_ size: CGSize) -> Self {
        self.footerReferenceSize = size
        return self
    }

    @discardableResult
    /// 设置组的内间距
    /// - Parameter sectionInset: 内间距
    /// - Returns: `Self`
    func pd_sectionInset(_ sectionInset: UIEdgeInsets) -> Self {
        self.sectionInset = sectionInset
        return self
    }

    /// 设置布局参考
    /// - Parameter sectionInsetReference: 布局参考枚举
    /// - Returns: `Self`
    @discardableResult
    func pd_sectionInsetReference(_ sectionInsetReference: UICollectionViewFlowLayout.SectionInsetReference) -> Self {
        self.sectionInsetReference = sectionInsetReference
        return self
    }

    /// 设置组头是否悬停
    /// - Parameter sectionHeadersPinToVisibleBounds: 是否悬停
    /// - Returns: `Self`
    @discardableResult
    func pd_sectionHeadersPinToVisibleBounds(_ sectionHeadersPinToVisibleBounds: Bool) -> Self {
        self.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        return self
    }

    /// 设置组尾是否悬停
    /// - Parameter sectionHeadersPinToVisibleBounds: 是否悬停
    /// - Returns: `Self`
    @discardableResult
    func pd_sectionFootersPinToVisibleBounds(_ sectionFootersPinToVisibleBounds: Bool) -> Self {
        self.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        return self
    }
}
