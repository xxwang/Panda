import UIKit

public extension NSTextAttachment {
    func toAttributedString() -> NSAttributedString {
        return NSAttributedString(attachment: self)
    }
}

extension NSTextAttachment: Defaultable {}
extension NSTextAttachment {
    public typealias Associatedtype = NSTextAttachment

    @objc open class func `default`() -> Associatedtype {
        return NSTextAttachment()
    }
}

public extension NSTextAttachment {
    @discardableResult
    func pd_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    @discardableResult
    func pd_bounds(_ bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
}
