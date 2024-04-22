import UIKit

// MARK: - 方法
public extension UICollectionViewCell {
    /// 标识符(使用类名注册时)
    /// - Returns: 标识符
    static func pd_identifier() -> String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Self.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }

    /// 获取`cell`所在的`UICollectionView`
    /// - Returns: `UICollectionView`
    func pd_findCollectionView() -> UICollectionView? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }
}

// MARK: - Defaultable
public extension UICollectionViewCell {
    typealias Associatedtype = UICollectionViewCell

    override class func `default`() -> Associatedtype {
        let cell = UICollectionViewCell()
        return cell
    }
}

// MARK: - 链式语法
public extension UITableViewCell {}
