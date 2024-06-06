
import UIKit


public extension UIScrollView {

    var sk_visibleRect: CGRect {
        let contentWidth = contentSize.width - contentOffset.x
        let contentHeight = contentSize.height - contentOffset.y
        return CGRect(
            origin: contentOffset,
            size: CGSize(width: Swift.min(Swift.min(bounds.size.width, contentSize.width), contentWidth),
                         height: Swift.min(Swift.min(bounds.size.height, contentSize.height), contentHeight))
        )
    }
}


public extension UIScrollView {

    func sk_fitScrollView() {
        if #available(iOS 11.0, *) {

            self.contentInsetAdjustmentBehavior = .never
        }
    }


    static func sk_fitAllScrollView() {
        if #available(iOS 11.0, *) {

            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
    }
}


public extension UIScrollView {

    override func sk_captureScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = frame
        frame = CGRect(origin: frame.origin, size: contentSize)
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        frame = previousFrame

        return image
    }

    func sk_captureLongScreenshot(_ completion: @escaping (_ image: UIImage?) -> Void) {

        let snapshotView = snapshotView(afterScreenUpdates: true)
        snapshotView?.frame = CGRect(
            x: frame.minX,
            y: frame.minY,
            width: (snapshotView?.frame.width)!,
            height: (snapshotView?.frame.height)!
        )
        superview?.addSubview(snapshotView!)


        let originOffset = contentOffset

        let page = floorf(Float(contentSize.height / bounds.height))

        UIGraphicsBeginImageContextWithOptions(contentSize, false, UIScreen.main.scale)


        sk_screenshot(index: 0, maxIndex: page.sk_int()) {
            let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.setContentOffset(originOffset, animated: false)
 
            snapshotView?.removeFromSuperview()
        
            completion(screenShotImage)
        }
    }

    func sk_screenshot(index: Int, maxIndex: Int, callback: @escaping () -> Void) {
        setContentOffset(
            CGPoint(
                x: 0,
                y: index.sk_cgFloat() * frame.size.height
            ),
            animated: false
        )
        let splitFrame = CGRect(
            x: 0,
            y: index.sk_cgFloat() * frame.size.height,
            width: bounds.width,
            height: bounds.height
        )

        DispatchQueue.sk_delay_execute(delay: 0.3) {
            self.drawHierarchy(in: splitFrame, afterScreenUpdates: true)
            if index < maxIndex {
                self.sk_screenshot(index: index + 1, maxIndex: maxIndex, callback: callback)
            } else {
                callback()
            }
        }
    }
}


public extension UIScrollView {
    typealias Associatedtype = UIScrollView

    override class func `default`() -> UIScrollView {
        let scrollView = UIScrollView()
        return scrollView
    }
}


public extension UIScrollView {

    @discardableResult
    func sk_delegate(_ delegate: UIScrollViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }


    @discardableResult
    func sk_contentOffset(_ offset: CGPoint) -> Self {
        contentOffset = offset
        return self
    }

    @discardableResult
    func sk_contentSize(_ size: CGSize) -> Self {
        contentSize = size
        return self
    }

    @discardableResult
    func sk_contentInset(_ inset: UIEdgeInsets) -> Self {
        contentInset = inset
        return self
    }

    @discardableResult
    func sk_bounces(_ bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }

    @discardableResult
    func sk_alwaysBounceHorizontal(_ bounces: Bool) -> Self {
        alwaysBounceHorizontal = bounces
        return self
    }

    @discardableResult
    func sk_alwaysBounceVertical(_ bounces: Bool) -> Self {
        alwaysBounceVertical = bounces
        return self
    }

    @discardableResult
    func sk_isPagingEnabled(_ enabled: Bool) -> Self {
        isPagingEnabled = enabled
        return self
    }

    @discardableResult
    func sk_showsHorizontalScrollIndicator(_ enabled: Bool) -> Self {
        showsHorizontalScrollIndicator = enabled
        return self
    }

    @discardableResult
    func sk_showsVerticalScrollIndicator(_ enabled: Bool) -> Self {
        showsVerticalScrollIndicator = enabled
        return self
    }

    @discardableResult
    func sk_scrollIndicatorInsets(_ inset: UIEdgeInsets) -> Self {
        scrollIndicatorInsets = inset
        return self
    }

    @discardableResult
    func sk_isScrollEnabled(_ enabled: Bool) -> Self {
        isScrollEnabled = enabled
        return self
    }

    @discardableResult
    func sk_indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        indicatorStyle = style
        return self
    }

    @discardableResult
    func sk_decelerationRate(_ rate: UIScrollView.DecelerationRate) -> Self {
        decelerationRate = rate
        return self
    }

    @discardableResult
    func sk_isDirectionalLockEnabled(_ enabled: Bool) -> Self {
        isDirectionalLockEnabled = enabled
        return self
    }

    @discardableResult
    func sk_scrollsToTop(_ scrollsToTop: Bool) -> Self {
        self.scrollsToTop = scrollsToTop
        return self
    }

    @discardableResult
    func sk_scrollToEndTop(_ animated: Bool = true) -> Self {
        setContentOffset(CGPoint(x: contentOffset.x, y: -contentInset.top), animated: animated)
        return self
    }

    @discardableResult
    func sk_scrollToEndBottom(_ animated: Bool = true) -> Self {
        setContentOffset(CGPoint(
            x: contentOffset.x,
            y: Swift.max(0, contentSize.height - bounds.height) + contentInset.bottom
        ),
        animated: animated)
        return self
    }

    @discardableResult
    func sk_scrollToEndLeft(_ animated: Bool = true) -> Self {
        setContentOffset(CGPoint(x: -contentInset.left, y: contentOffset.y), animated: animated)
        return self
    }

    @discardableResult
    func sk_scrollToEndRight(_ animated: Bool = true) -> Self {
        setContentOffset(
            CGPoint(
                x: Swift.max(0, contentSize.width - bounds.width) + contentInset.right,
                y: contentOffset.y
            ),
            animated: animated
        )
        return self
    }

    @discardableResult
    func sk_scrollUp(_ animated: Bool = true) -> Self {
        let minY = -contentInset.top
        var y = Swift.max(minY, contentOffset.y - bounds.height)
        #if !os(tvOS)
            if isPagingEnabled, bounds.height != 0 {
                let page = Swift.max(0, ((y + contentInset.top) / bounds.height).rounded(.down))
                y = Swift.max(minY, page * bounds.height - contentInset.top)
            }
        #endif
        setContentOffset(CGPoint(x: contentOffset.x, y: y), animated: animated)
        return self
    }

    @discardableResult
    func sk_scrollDown(_ animated: Bool = true) -> Self {
        let maxY = Swift.max(0, contentSize.height - bounds.height) + contentInset.bottom
        var y = Swift.min(maxY, contentOffset.y + bounds.height)
        #if !os(tvOS)
            if isPagingEnabled, bounds.height != 0 {
                let page = ((y + contentInset.top) / bounds.height).rounded(.down)
                y = Swift.min(maxY, page * bounds.height - contentInset.top)
            }
        #endif
        setContentOffset(CGPoint(x: contentOffset.x, y: y), animated: animated)
        return self
    }

    @discardableResult
    func sk_scrollLeft(_ animated: Bool = true) -> Self {
        let minX = -contentInset.left
        var x = Swift.max(minX, contentOffset.x - bounds.width)
        #if !os(tvOS)
            if isPagingEnabled, bounds.width != 0 {
                let page = ((x + contentInset.left) / bounds.width).rounded(.down)
                x = Swift.max(minX, page * bounds.width - contentInset.left)
            }
        #endif
        setContentOffset(CGPoint(x: x, y: contentOffset.y), animated: animated)
        return self
    }

    @discardableResult
    func sk_scrollRight(_ animated: Bool = true) -> Self {
        let maxX = Swift.max(0, contentSize.width - bounds.width) + contentInset.right
        var x = Swift.min(maxX, contentOffset.x + bounds.width)
        #if !os(tvOS)
            if isPagingEnabled, bounds.width != 0 {
                let page = ((x + contentInset.left) / bounds.width).rounded(.down)
                x = Swift.min(maxX, page * bounds.width - contentInset.left)
            }
        #endif
        setContentOffset(CGPoint(x: x, y: contentOffset.y), animated: animated)
        return self
    }
}
