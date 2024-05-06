//
//  UITableView+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import UIKit

// MARK: - 适配
public extension UITableView {
    /// 适配当前`UITableView`
    func pd_fitTableView() {
        if #available(iOS 11, *) {
            self.estimatedRowHeight = 0
            self.estimatedSectionFooterHeight = 0
            self.estimatedSectionHeaderHeight = 0
            self.contentInsetAdjustmentBehavior = .never
        }

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }

    /// 适配项目中所有`UITableView`
    static func pd_fitAllTableView() {
        if #available(iOS 11.0, *) {
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
        }

        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
}

// MARK: - 方法
public extension UITableView {
    
    /// 重新加载数据后调用`completion`回调
    /// - Parameter completion:完成回调
    func pd_reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}

// MARK: - UITableViewCell复用相关
public extension UITableView {

    /// 使用类名注册`UITableViewCell`
    /// - Parameters:
    ///   - nib:用于创建`UITableViewCell`的nib文件
    ///   - name:`UITableViewCell`类型
    func pd_register(nib: UINib?, withCellClass name: (some UITableViewCell).Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }

    /// 注册`UITableViewCell`,使用其对应类的xib文件
    /// 假设`xib`文件名和cell类具有相同的名称
    /// - Parameters:
    ///   - name:`UITableViewCell`类型
    ///   - bundleClass:`bundle`实例基于的类
    func pd_register(nibWithCellClass name: (some UITableViewCell).Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        self.register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }

    /// 使用类名获取可重用`UITableViewCell`
    /// - Parameter name:`UITableViewCell`类型
    /// - Returns:类名关联的`UITableViewCell`对象
    func pd_dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

    /// 使用`类名`和`indexPath`获取可重用`UITableViewCell`
    /// - Parameters:
    ///   - name:`UITableViewCell`类型
    ///   - indexPath:单元格在`tableView`中的位置
    /// - Returns:类名关联的`UITableViewCell`对象
    func pd_dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }
}

// MARK: - UITableViewHeaderFooterView复用相关
public extension UITableView {
    /// 使用类名注册`UITableViewHeaderFooterView`
    /// - Parameters:
    ///   - nib:用于创建页眉或页脚视图的`nib`文件
    ///   - name:`UITableViewHeaderFooterView`类型
    func pd_register(nib: UINib?, withHeaderFooterViewClass name: (some UITableViewHeaderFooterView).Type) {
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    /// 使用类名注册`UITableViewHeaderFooterView`
    /// - Parameter name:`UITableViewHeaderFooterView`类型
    func pd_register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    /// 使用类名获取可重用`UITableViewHeaderFooterView`
    /// - Parameter name:`UITableViewHeaderFooterView`类型
    /// - Returns:类名关联的`UITableViewHeaderFooterView`对象
    func pd_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewHeaderFooterView for \(String(describing: name)), make sure the view is registered with table view")
        }
        return headerFooterView
    }
}

// MARK: - Defaultable
public extension UITableView {
    typealias Associatedtype = UITableView

    override class func `default`() -> Associatedtype {
        let tableView = UITableView(frame: .zero, style: .grouped)
            .pd_rowHeight(UITableView.automaticDimension)
            .pd_estimatedRowHeight(50)
            .pd_backgroundColor(.clear)
            .pd_sectionHeaderHeight(0.001)
            .pd_sectionFooterHeight(0.001)
            .pd_showsHorizontalScrollIndicator(false)
            .pd_showsVerticalScrollIndicator(false)
            .pd_cellLayoutMarginsFollowReadableWidth(false)
            .pd_separatorStyle(.none)
            .pd_keyboardDismissMode(.onDrag)
            .pd_showsHorizontalScrollIndicator(false)
            .pd_showsVerticalScrollIndicator(false)
            .pd_contentInsetAdjustmentBehavior(.never)
            .pd_sectionHeaderTopPadding(0)
        return tableView
    }
}

// MARK: - 链式语法
public extension UITableView {
    /// 设置 `delegate`
    /// - Parameter delegate:`delegate`
    /// - Returns:`Self`
    @discardableResult
    func pd_delegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 `dataSource` 代理
    /// - Parameter dataSource:`dataSource`
    /// - Returns:`Self`
    @discardableResult
    func pd_dataSource(_ dataSource: UITableViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    /// 注册`cell`
    /// - Returns:`Self`
    @discardableResult
    func pd_register<T: UITableViewCell>(cellWithClass name: T.Type) -> Self {
        register(T.self, forCellReuseIdentifier: String(describing: name))
        return self
    }

    /// 设置行高
    /// - Parameter height:行高
    /// - Returns:`Self`
    @discardableResult
    func pd_rowHeight(_ height: CGFloat) -> Self {
        rowHeight = height
        return self
    }

    /// 设置段头(`sectionHeaderHeight`)的高度
    /// - Parameter height:组头的高度
    /// - Returns:`Self`
    @discardableResult
    func pd_sectionHeaderHeight(_ height: CGFloat) -> Self {
        sectionHeaderHeight = height
        return self
    }

    /// 设置组脚(`sectionFooterHeight`)的高度
    /// - Parameter height:组脚的高度
    /// - Returns:`Self`
    @discardableResult
    func pd_sectionFooterHeight(_ height: CGFloat) -> Self {
        sectionFooterHeight = height
        return self
    }

    /// 设置一个默认(预估)`cell`高度
    /// - Parameter height:默认`cell`高度
    /// - Returns:`Self`
    @discardableResult
    func pd_estimatedRowHeight(_ height: CGFloat) -> Self {
        estimatedRowHeight = height
        return self
    }

    /// 设置默认段头(`estimatedSectionHeaderHeight`)高度
    /// - Parameter height:组头高度
    /// - Returns:`Self`
    @discardableResult
    func pd_estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        estimatedSectionHeaderHeight = height
        return self
    }

    /// 设置默认组脚(`estimatedSectionFooterHeight`)高度
    /// - Parameter height:组脚高度
    /// - Returns:`Self`
    @discardableResult
    func pd_estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        estimatedSectionFooterHeight = height
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

    /// `Cell`是否自动缩进
    /// - Parameter cellLayoutMarginsFollowReadableWidth:是否留白
    /// - Returns:`Self`
    @discardableResult
    func pd_cellLayoutMarginsFollowReadableWidth(_ cellLayoutMarginsFollowReadableWidth: Bool) -> Self {
        self.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth
        return self
    }

    /// 设置分割线的样式
    /// - Parameter style:分割线的样式
    /// - Returns:`Self`
    @discardableResult
    func pd_separatorStyle(_ style: UITableViewCell.SeparatorStyle = .none) -> Self {
        separatorStyle = style
        return self
    }

    /// 设置 `UITableView` 的头部 `tableHeaderView`
    /// - Parameter head:头部 View
    /// - Returns:`Self`
    @discardableResult
    func pd_tableHeaderView(_ head: UIView?) -> Self {
        tableHeaderView = head
        return self
    }

    /// 设置 `UITableView` 的尾部 `tableFooterView`
    /// - Parameter foot:尾部 `View`
    /// - Returns:`Self`
    @discardableResult
    func pd_tableFooterView(_ foot: UIView?) -> Self {
        tableFooterView = foot
        return self
    }

    /// 移除`tableHeaderView`
    /// - Returns:`Self`
    @discardableResult
    func removeTableHeaderView() -> Self {
        tableHeaderView = nil
        return self
    }

    /// 移除`tableFooterView`
    /// - Returns:`Self`
    @discardableResult
    func removeTableFooterView() -> Self {
        tableFooterView = nil
        return self
    }

    /// 设置内容调整行为
    /// - Parameter behavior: 行为
    /// - Returns: `Self`
    @discardableResult
    func pd_contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        if #available(iOS 11, *) {
            self.contentInsetAdjustmentBehavior = behavior
        }
        return self
    }

    /// 设置组头间距
    /// - Parameter topPadding: 间距
    /// - Returns: `Self`
    @discardableResult
    func pd_sectionHeaderTopPadding(_ topPadding: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = topPadding
        }
        return self
    }

    /// 滚动到指定`IndexPath`
    /// - Parameters:
    ///   - indexPath:要滚动到的`cell``IndexPath`
    ///   - scrollPosition:滚动的方式
    ///   - animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollTo(_ indexPath: IndexPath, at scrollPosition: ScrollPosition = .middle, animated: Bool = true) -> Self {
        if indexPath.section < 0
            || indexPath.row < 0
            || indexPath.section > numberOfSections
            || indexPath.row > numberOfRows(inSection: indexPath.section)
        {
            return self
        }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到最近选中的`cell`(选中的`cell`消失在屏幕中,触发事件可以滚动到选中的`cell`)
    /// - Parameters:
    ///   - scrollPosition:滚动的方式
    ///   - animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollToNearestSelectedRow(at scrollPosition: ScrollPosition = .middle, animated: Bool = true) -> Self {
        scrollToNearestSelectedRow(at: scrollPosition, animated: animated)
        return self
    }

    /// 是否滚动到顶部
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollToTop(animated: Bool) -> Self {
        setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        return self
    }

    /// 是否滚动到底部
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollToBottom(animated: Bool) -> Self {
        let y = contentSize.height - frame.size.height
        if y < 0 { return self }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        return self
    }

    /// 滚动到什么位置(CGPoint)
    /// - Parameter animated:是否要动画
    /// - Returns:`Self`
    @discardableResult
    func pd_scrollToContentOffset(_ contentOffset: CGPoint, animated: Bool) -> Self {
        setContentOffset(contentOffset, animated: animated)
        return self
    }
}
