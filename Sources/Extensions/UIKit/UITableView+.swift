import UIKit

public extension UITableView {

    func xx_fitTableView() {
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

    static func xx_fitAllTableView() {
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

public extension UITableView {

    func xx_reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}

public extension UITableView {

    func xx_register(nib: UINib?, withCellClass name: (some UITableViewCell).Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }

    func xx_register(nibWithCellClass name: (some UITableViewCell).Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        self.register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }

    func xx_dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

    func xx_dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }
}

public extension UITableView {

    func xx_register(nib: UINib?, withHeaderFooterViewClass name: (some UITableViewHeaderFooterView).Type) {
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    func xx_register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

    func xx_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewHeaderFooterView for \(String(describing: name)), make sure the view is registered with table view")
        }
        return headerFooterView
    }
}

public extension UITableView {
    typealias Associatedtype = UITableView

    override class func `default`() -> Associatedtype {
        let tableView = UITableView(frame: .zero, style: .grouped)
            .xx_rowHeight(UITableView.automaticDimension)
            .xx_estimatedRowHeight(50)
            .xx_backgroundColor(.clear)
            .xx_sectionHeaderHeight(0.001)
            .xx_sectionFooterHeight(0.001)
            .xx_showsHorizontalScrollIndicator(false)
            .xx_showsVerticalScrollIndicator(false)
            .xx_cellLayoutMarginsFollowReadableWidth(false)
            .xx_separatorStyle(.none)
            .xx_keyboardDismissMode(.onDrag)
            .xx_showsHorizontalScrollIndicator(false)
            .xx_showsVerticalScrollIndicator(false)
            .xx_contentInsetAdjustmentBehavior(.never)
            .xx_sectionHeaderTopPadding(0)
        return tableView
    }
}


public extension UITableView {

    @discardableResult
    func xx_delegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func xx_dataSource(_ dataSource: UITableViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    @discardableResult
    func xx_register<T: UITableViewCell>(cellWithClass name: T.Type) -> Self {
        register(T.self, forCellReuseIdentifier: String(describing: name))
        return self
    }

    @discardableResult
    func xx_rowHeight(_ height: CGFloat) -> Self {
        rowHeight = height
        return self
    }

    @discardableResult
    func xx_sectionHeaderHeight(_ height: CGFloat) -> Self {
        sectionHeaderHeight = height
        return self
    }

    @discardableResult
    func xx_sectionFooterHeight(_ height: CGFloat) -> Self {
        sectionFooterHeight = height
        return self
    }

    @discardableResult
    func xx_estimatedRowHeight(_ height: CGFloat) -> Self {
        estimatedRowHeight = height
        return self
    }

    @discardableResult
    func xx_estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        estimatedSectionHeaderHeight = height
        return self
    }

    @discardableResult
    func xx_estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        estimatedSectionFooterHeight = height
        return self
    }

    @discardableResult
    func xx_keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        keyboardDismissMode = mode
        return self
    }

    @discardableResult
    func xx_cellLayoutMarginsFollowReadableWidth(_ cellLayoutMarginsFollowReadableWidth: Bool) -> Self {
        self.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth
        return self
    }

    @discardableResult
    func xx_separatorStyle(_ style: UITableViewCell.SeparatorStyle = .none) -> Self {
        separatorStyle = style
        return self
    }

    @discardableResult
    func xx_tableHeaderView(_ head: UIView?) -> Self {
        tableHeaderView = head
        return self
    }

    @discardableResult
    func xx_tableFooterView(_ foot: UIView?) -> Self {
        tableFooterView = foot
        return self
    }

    @discardableResult
    func removeTableHeaderView() -> Self {
        tableHeaderView = nil
        return self
    }

    @discardableResult
    func removeTableFooterView() -> Self {
        tableFooterView = nil
        return self
    }

    @discardableResult
    func xx_contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        if #available(iOS 11, *) {
            self.contentInsetAdjustmentBehavior = behavior
        }
        return self
    }

    @discardableResult
    func xx_sectionHeaderTopPadding(_ topPadding: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = topPadding
        }
        return self
    }

    @discardableResult
    func xx_scrollTo(_ indexPath: IndexPath, at scrollPosition: ScrollPosition = .middle, animated: Bool = true) -> Self {
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

    @discardableResult
    func xx_scrollToNearestSelectedRow(at scrollPosition: ScrollPosition = .middle, animated: Bool = true) -> Self {
        scrollToNearestSelectedRow(at: scrollPosition, animated: animated)
        return self
    }

    @discardableResult
    func xx_scrollToTop(animated: Bool) -> Self {
        setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        return self
    }

    @discardableResult
    func xx_scrollToBottom(animated: Bool) -> Self {
        let y = contentSize.height - frame.size.height
        if y < 0 { return self }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        return self
    }

    @discardableResult
    func xx_scrollToContentOffset(_ contentOffset: CGPoint, animated: Bool) -> Self {
        setContentOffset(contentOffset, animated: animated)
        return self
    }
}