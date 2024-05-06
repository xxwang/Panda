//
//  UICollectionView+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import UIKit

// MARK: - 方法
public extension UICollectionView {
    /// 刷新`UICollectionView`的数据,刷新后调用回调
    /// - Parameter completion:完成回调
    func pd_reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}

// MARK: - UICollectionViewCell复用相关
public extension UICollectionView {
    /// 使用类名注册`UICollectionViewCell`
    /// - Parameter name:`UICollectionViewCell`类型
    func pd_register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    /// 使用类名注册`UICollectionView`
    /// - Parameters:
    ///   - nib:用于创建`collectionView`单元格的`nib`文件
    ///   - name:`UICollectionViewCell`类型
    func pd_register(nib: UINib?, forCellWithClass name: (some UICollectionViewCell).Type) {
        register(nib, forCellWithReuseIdentifier: String(describing: name))
    }

    /// 向注册`UICollectionViewCell`.仅使用其对应类的`xib`文件
    /// 假设xib文件名称和`cell`类具有相同的名称
    /// - Parameters:
    ///   - name:`UICollectionViewCell`类型
    ///   - bundleClass:`Bundle`实例将基于的类
    func pd_register(nibWithCellClass name: (some UICollectionViewCell).Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    /// 使用类名和索引获取可重用`UICollectionViewCell`
    /// - Parameters:
    ///   - name:`UICollectionViewCell`类型
    ///   - indexPath:`UICollectionView`中单元格的位置
    /// - Returns:类名关联的`UICollectionViewCell`对象
    func pd_dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                "Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
        }
        return cell
    }
}

// MARK: - UICollectionReusableView复用相关
public extension UICollectionView {
    /// 使用类名注册`UICollectionReusableView`
    /// - Parameters:
    ///   - kind:要检索的补充视图的种类.该值由布局对象定义
    ///   - name:`UICollectionReusableView`类型
    func pd_register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    /// 使用类名注册`UICollectionReusableView`
    /// - Parameters:
    ///   - nib:用于创建可重用视图的`nib`文件
    ///   - kind:要检索的视图的种类.该值由布局对象定义
    ///   - name:`UICollectionReusableView`类型
    func pd_register(nib: UINib?,
                     forSupplementaryViewOfKind kind: String,
                     withClass name: (some UICollectionReusableView).Type)
    {
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    /// 使用类名和类型获取可重用`UICollectionReusableView`
    /// - Parameters:
    ///   - kind:要检索的视图的种类.该值由布局对象定义
    ///   - name:`UICollectionReusableView`类型
    ///   - indexPath:单元格在`UICollectionView`中的位置
    /// - Returns:类名关联的`UICollectionReusableView`对象
    func pd_dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String,
                                                                          withClass name: T.Type,
                                                                          for indexPath: IndexPath) -> T
    {
        guard let reusableView = dequeueReusableSupplementaryView(ofKind: kind,
                                                                  withReuseIdentifier: String(describing: name),
                                                                  for: indexPath) as? T
        else {
            fatalError(
                "Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
        }
        return reusableView
    }
}

// MARK: - 移动
public extension UICollectionView {
    /// 开启Item移动(添加长按手势)
    func pd_allowMoveItem() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pd_longPressGestureRecognizerHandler))
        addGestureRecognizer(longPressGestureRecognizer)
    }

    /// 禁止Item移动(移除长按手势)
    func pd_disableMoveItem() {
        _ = gestureRecognizers?.map {
            if let gestureRecognizer = $0 as? UILongPressGestureRecognizer {
                self.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }

    /// 长按手势处理
    @objc private func pd_longPressGestureRecognizerHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: gestureRecognizer.view!)
        switch gestureRecognizer.state {
        case .began: // 开始移动
            if let selectedIndexPath = indexPathForItem(at: point) {
                beginInteractiveMovementForItem(at: selectedIndexPath)
            }
        case .changed: // 移动中
            updateInteractiveMovementTargetPosition(point)
        case .ended: // 结束移动
            endInteractiveMovement()
        default: // 取消移动
            cancelInteractiveMovement()
        }
    }
}

// MARK: - Defaultable
public extension UICollectionView {
    typealias Associatedtype = UICollectionView

    override class func `default`() -> Associatedtype {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }
}

// MARK: - 链式语法
public extension UICollectionView {
    /// 设置 `delegate` 代理
    /// - Parameter delegate:`delegate`
    /// - Returns:`Self`
    @discardableResult
    func pd_delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 dataSource 代理
    /// - Parameter dataSource:`dataSource`
    /// - Returns:`Self`
    @discardableResult
    func pd_dataSource(_ dataSource: UICollectionViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    /// 注册`UICollectionViewCell`(类名方式)
    /// - Returns:`Self`
    @discardableResult
    func pd_register<T: UICollectionViewCell>(_ cell: T.Type) -> Self {
        pd_register(cellWithClass: T.self)
        return self
    }

    /// 设置`Layout`
    /// - Parameters:
    ///   - layout:布局
    ///   - animated:是否动画
    ///   - completion:完成回调
    /// - Returns:`Self`
    @discardableResult
    func pd_layout(_ layout: UICollectionViewLayout, animated: Bool = true, completion: ((Bool) -> Void)? = nil) -> Self {
        setCollectionViewLayout(layout, animated: animated, completion: completion)
        return self
    }

    /// 键盘消息模式
    /// - Parameter mode:模式
    /// - Returns:`Self`
    @discardableResult
    func pd_keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        keyboardDismissMode = mode
        return self
    }

    /// 滚动到指定`IndexPath`
    /// - Parameters:
    ///   - indexPath:第几个IndexPath
    ///   - scrollPosition:滚动的方式
    ///   - animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollTo(_ indexPath: IndexPath, at scrollPosition: ScrollPosition = .top, animated: Bool = true) -> Self {
        if indexPath.section < 0
            || indexPath.item < 0
            || indexPath.section > numberOfSections
            || indexPath.row > numberOfItems(inSection: indexPath.section)
        {
            return self
        }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到指定`CGRect`(让指定区域可见)
    /// - Parameters:
    ///   - rect: 要显示的区域
    ///   - animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollTo(_ rect: CGRect, animated: Bool = true) -> Self {
        guard rect.maxY <= pd_maxY else { return self }
        scrollRectToVisible(rect, animated: animated)
        return self
    }

    /// 是否滚动到顶部
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollToTop(animated: Bool = true) -> Self {
        setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        return self
    }

    /// 是否滚动到底部
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollToBottom(animated: Bool = true) -> Self {
        let y = contentSize.height - frame.size.height
        if y < 0 { return self }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        return self
    }

    /// 滚动到什么位置(`CGPoint`)
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollToContentOffset(_ contentOffset: CGPoint = .zero, animated: Bool = true) -> Self {
        setContentOffset(contentOffset, animated: animated)
        return self
    }
}
