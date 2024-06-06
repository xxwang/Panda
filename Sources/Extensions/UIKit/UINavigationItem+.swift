
import UIKit


public extension UINavigationItem {

    func sk_titleView(with image: UIImage, size: CGSize = CGSize(width: 100, height: 30)) {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: size))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.titleView = imageView
    }
}


extension UINavigationItem: Defaultable {}
extension UINavigationItem {
    public typealias Associatedtype = UINavigationItem

    @objc open class func `default`() -> UINavigationItem {
        let item = UINavigationItem()
        return item
    }
}

public extension UINavigationItem {

    @discardableResult
    func sk_largeTitleDisplayMode(_ mode: LargeTitleDisplayMode) -> Self {
        largeTitleDisplayMode = mode
        return self
    }

    @discardableResult
    func sk_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    @discardableResult
    func sk_titleView(_ view: UIView?) -> Self {
        titleView = view
        return self
    }
}
