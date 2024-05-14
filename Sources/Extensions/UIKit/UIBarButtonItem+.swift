
import UIKit

public extension UIBarButtonItem {

    convenience init(flexible spacing: CGFloat) {
        self.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        width = spacing
    }

    convenience init(image: UIImage? = nil,
                     highlightedImage: UIImage? = nil,
                     title: String? = nil,
                     font: UIFont? = nil,
                     titleColor: UIColor? = nil,
                     highlightedTitleColor: UIColor? = nil,
                     target: Any? = nil,
                     action: Selector?)
    {
        let button = UIButton(type: .custom)
        if let image { button.setImage(image, for: .normal) }
        if let highlightedImage { button.setImage(highlightedImage, for: .highlighted) }
        if let title { button.setTitle(title, for: .normal) }
        if let font { button.titleLabel?.font = font }
        if let titleColor { button.setTitleColor(titleColor, for: .normal) }
        if let highlightedTitleColor { button.setTitleColor(highlightedTitleColor, for: .highlighted) }
        if let target, let action { button.addTarget(target, action: action, for: .touchUpInside) }
        button.xx_spacing(3)

        self.init(customView: button)
    }
}

private class AssociateKeys {
    static var CallbackKey = UnsafeRawPointer(bitPattern: ("UIBarButtonItem" + "CallbackKey").hashValue)
}

extension UIBarButtonItem: AssociatedAttributes {
    public typealias T = UIBarButtonItem
    public var callback: Callback? {
        get { AssociatedObject.get(self, &AssociateKeys.CallbackKey) as? Callback }
        set { AssociatedObject.set(self, &AssociateKeys.CallbackKey, newValue) }
    }

    @objc func eventHandler(_ event: UIBarButtonItem) {
        callback?(event)
    }
}

extension UIBarButtonItem: Defaultable {}
extension UIBarButtonItem {
    public typealias Associatedtype = UIBarButtonItem

    @objc open class func `default`() -> Associatedtype {
        let item = UIBarButtonItem()
        return item
    }
}

public extension UIBarButtonItem {

    @discardableResult
    func xx_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    @discardableResult
    func xx_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    @discardableResult
    func xx_width(_ width: CGFloat) -> Self {
        self.width = width
        return self
    }

    @discardableResult
    func xx_addTarget(_ target: AnyObject, action: Selector) -> Self {
        self.target = target
        self.action = action
        return self
    }

    @discardableResult
    func xx_target(_ target: AnyObject) -> Self {
        self.target = target
        return self
    }

    @discardableResult
    func xx_action(_ action: Selector) -> Self {
        self.action = action
        return self
    }

    @discardableResult
    func xx_callback(_ callback: ((UIBarButtonItem?) -> Void)?) -> Self {
        self.callback = callback
        xx_addTarget(self, action: #selector(eventHandler(_:)))
        return self
    }
}
