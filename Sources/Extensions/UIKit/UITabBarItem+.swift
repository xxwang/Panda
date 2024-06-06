import UIKit


extension UITabBarItem: Defaultable {}
extension UITabBarItem {
    public typealias Associatedtype = UITabBarItem

    @objc open class func `default`() -> Associatedtype {
        let item = UITabBarItem()
        return item
    }
}


public extension UITabBarItem {

    @discardableResult
    func sk_title(_ title: String) -> Self {
        self.title = title
        return self
    }

    @discardableResult
    func sk_image(_ image: UIImage) -> Self {
        self.image = image.withRenderingMode(.alwaysOriginal)
        return self
    }

    @discardableResult
    func sk_selectedImage(_ image: UIImage) -> Self {
        self.selectedImage = image
        return self
    }

    @discardableResult
    func sk_badgeColor(_ color: UIColor) -> Self {
        self.badgeColor = color
        return self
    }

    @discardableResult
    func sk_badgeValue(_ value: String) -> Self {
        self.badgeValue = value
        return self
    }
}
