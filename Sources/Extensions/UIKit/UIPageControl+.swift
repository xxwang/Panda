import UIKit

public extension UIPageControl {
    typealias Associatedtype = UIPageControl

    @objc override class func `default`() -> Associatedtype {
        let pageControl = UIPageControl()
        return pageControl
    }
}

public extension UIPageControl {

    @discardableResult
    func pd_currentPageIndicatorTintColor(_ color: UIColor) -> Self {
        self.currentPageIndicatorTintColor = color
        return self
    }

    @discardableResult
    func pd_pageIndicatorTintColor(_ color: UIColor) -> Self {
        self.pageIndicatorTintColor = color
        return self
    }

    @discardableResult
    func pd_hidesForSinglePage(_ isHidden: Bool) -> Self {
        self.hidesForSinglePage = isHidden
        return self
    }

    @discardableResult
    func pd_currentPage(_ current: Int) -> Self {
        self.currentPage = current
        return self
    }

    @discardableResult
    func pd_numberOfPages(_ count: Int) -> Self {
        self.numberOfPages = count
        return self
    }
}
