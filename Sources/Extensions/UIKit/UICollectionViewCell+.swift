import UIKit

public extension UICollectionViewCell {

    static func xx_identifier() -> String {
        let classNameString = NSStringFromClass(Self.self)
        return classNameString.components(separatedBy: ".").last!
    }

    func xx_findCollectionView() -> UICollectionView? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }
}


public extension UICollectionViewCell {
    typealias Associatedtype = UICollectionViewCell

    override class func `default`() -> Associatedtype {
        let cell = UICollectionViewCell()
        return cell
    }
}

public extension UITableViewCell {}
