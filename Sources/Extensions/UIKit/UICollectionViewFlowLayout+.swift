
import UIKit

extension UICollectionViewFlowLayout {

    @discardableResult
    func sk_minimumLineSpacing(_ spacing: CGFloat) -> Self {
        self.minimumLineSpacing = spacing
        return self
    }

    @discardableResult
    func sk_minimumInteritemSpacing(_ spacing: CGFloat) -> Self {
        self.minimumInteritemSpacing = spacing
        return self
    }

    @discardableResult
    func sk_itemSize(_ size: CGSize) -> Self {
        self.itemSize = size
        return self
    }

    @discardableResult
    func sk_estimatedItemSize(_ size: CGSize) -> Self {
        self.estimatedItemSize = size
        return self
    }

    @discardableResult
    func sk_scrollDirection(_ scrollDirection: UICollectionView.ScrollDirection) -> Self {
        self.scrollDirection = scrollDirection
        return self
    }

    @discardableResult
    func sk_headerReferenceSize(_ size: CGSize) -> Self {
        self.headerReferenceSize = size
        return self
    }

    @discardableResult
    func sk_footerReferenceSize(_ size: CGSize) -> Self {
        self.footerReferenceSize = size
        return self
    }

    @discardableResult
    func sk_sectionInset(_ sectionInset: UIEdgeInsets) -> Self {
        self.sectionInset = sectionInset
        return self
    }

    @discardableResult
    func sk_sectionInsetReference(_ sectionInsetReference: UICollectionViewFlowLayout.SectionInsetReference) -> Self {
        self.sectionInsetReference = sectionInsetReference
        return self
    }

    @discardableResult
    func sk_sectionHeadersPinToVisibleBounds(_ sectionHeadersPinToVisibleBounds: Bool) -> Self {
        self.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        return self
    }

    @discardableResult
    func sk_sectionFootersPinToVisibleBounds(_ sectionFootersPinToVisibleBounds: Bool) -> Self {
        self.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        return self
    }
}
