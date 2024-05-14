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
    func xx_currentPageIndicatorTintColor(_ color: UIColor) -> Self {
        self.currentPageIndicatorTintColor = color
        return self
    }

    @discardableResult
    func xx_pageIndicatorTintColor(_ color: UIColor) -> Self {
        self.pageIndicatorTintColor = color
        return self
    }

    @discardableResult
    func xx_hidesForSinglePage(_ isHidden: Bool) -> Self {
        self.hidesForSinglePage = isHidden
        return self
    }

    @discardableResult
    func xx_currentPage(_ current: Int) -> Self {
        self.currentPage = current
        return self
    }

    @discardableResult
    func xx_numberOfPages(_ count: Int) -> Self {
        self.numberOfPages = count
        return self
    }
}
