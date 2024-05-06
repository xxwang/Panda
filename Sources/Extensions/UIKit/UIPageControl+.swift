import UIKit

// MARK: - Defaultable
public extension UIPageControl {
    typealias Associatedtype = UIPageControl

    @objc override class func `default`() -> Associatedtype {
        let pageControl = UIPageControl()
        return pageControl
    }
}

// MARK: - 链式语法
public extension UIPageControl {
    /// 设置当前选中指示器颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func pd_currentPageIndicatorTintColor(_ color: UIColor) -> Self {
        self.currentPageIndicatorTintColor = color
        return self
    }

    /// 设置没有选中时的指示器颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func pd_pageIndicatorTintColor(_ color: UIColor) -> Self {
        self.pageIndicatorTintColor = color
        return self
    }

    /// 只有一页的时候是否隐藏分页指示器
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func pd_hidesForSinglePage(_ isHidden: Bool) -> Self {
        self.hidesForSinglePage = isHidden
        return self
    }

    /// 设置当前页码
    /// - Parameter current: 当前页码
    /// - Returns: `Self`
    @discardableResult
    func pd_currentPage(_ current: Int) -> Self {
        self.currentPage = current
        return self
    }

    /// 设置总页数
    /// - Parameter count: 总页数
    /// - Returns: `Self`
    @discardableResult
    func pd_numberOfPages(_ count: Int) -> Self {
        self.numberOfPages = count
        return self
    }
}
