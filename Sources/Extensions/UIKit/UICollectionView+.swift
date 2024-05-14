
import UIKit


public extension UICollectionView {

    func xx_reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}

public extension UICollectionView {

    func xx_register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    func xx_register(nib: UINib?, forCellWithClass name: (some UICollectionViewCell).Type) {
        register(nib, forCellWithReuseIdentifier: String(describing: name))
    }

    func xx_register(nibWithCellClass name: (some UICollectionViewCell).Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    func xx_dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                "Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
        }
        return cell
    }
}

public extension UICollectionView {

    func xx_register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    func xx_register(nib: UINib?,
                     forSupplementaryViewOfKind kind: String,
                     withClass name: (some UICollectionReusableView).Type)
    {
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    func xx_dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String,
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

public extension UICollectionView {
    func xx_allowMoveItem() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(xx_longPressGestureRecognizerHandler))
        addGestureRecognizer(longPressGestureRecognizer)
    }

    func xx_disableMoveItem() {
        _ = gestureRecognizers?.map {
            if let gestureRecognizer = $0 as? UILongPressGestureRecognizer {
                self.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }

    @objc private func xx_longPressGestureRecognizerHandler(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: gestureRecognizer.view!)
        switch gestureRecognizer.state {
        case .began:
            if let selectedIndexPath = indexPathForItem(at: point) {
                beginInteractiveMovementForItem(at: selectedIndexPath)
            }
        case .changed:
            updateInteractiveMovementTargetPosition(point)
        case .ended:
            endInteractiveMovement()
        default:
            cancelInteractiveMovement()
        }
    }
}

public extension UICollectionView {
    typealias Associatedtype = UICollectionView

    override class func `default`() -> Associatedtype {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }
}

public extension UICollectionView {

    @discardableResult
    func xx_delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func xx_dataSource(_ dataSource: UICollectionViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    @discardableResult
    func xx_register<T: UICollectionViewCell>(_ cell: T.Type) -> Self {
        xx_register(cellWithClass: T.self)
        return self
    }

    @discardableResult
    func xx_layout(_ layout: UICollectionViewLayout, animated: Bool = true, completion: ((Bool) -> Void)? = nil) -> Self {
        setCollectionViewLayout(layout, animated: animated, completion: completion)
        return self
    }

    @discardableResult
    func xx_keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        keyboardDismissMode = mode
        return self
    }

    @discardableResult
    func xx_scrollTo(_ indexPath: IndexPath, at scrollPosition: ScrollPosition = .top, animated: Bool = true) -> Self {
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

    @discardableResult
    func xx_scrollTo(_ rect: CGRect, animated: Bool = true) -> Self {
        guard rect.maxY <= xx_maxY else { return self }
        scrollRectToVisible(rect, animated: animated)
        return self
    }

    @discardableResult
    func xx_scrollToTop(animated: Bool = true) -> Self {
        setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        return self
    }

    @discardableResult
    func xx_scrollToBottom(animated: Bool = true) -> Self {
        let y = contentSize.height - frame.size.height
        if y < 0 { return self }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        return self
    }

    @discardableResult
    func xx_scrollToContentOffset(_ contentOffset: CGPoint = .zero, animated: Bool = true) -> Self {
        setContentOffset(contentOffset, animated: animated)
        return self
    }
}
