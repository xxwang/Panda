
import UIKit

private class AssociateKeys {
    static var FunctionNameKey = UnsafeRawPointer(bitPattern: ("UIGestureRecognizer" + "FunctionNameKey").hashValue)
    static var CallbackKey = UnsafeRawPointer(bitPattern: ("UIGestureRecognizer" + "CallbackKey").hashValue)
}


public extension UIGestureRecognizer {
    var pd_functionName: String {
        get {
            if let obj = AssociatedObject.get(self, &AssociateKeys.FunctionNameKey) as? String {
                return obj
            }
            let string = String(describing: classForCoder)
            AssociatedObject.set(self, &AssociateKeys.FunctionNameKey, string, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return string
        }
        set {
            AssociatedObject.set(self, &AssociateKeys.FunctionNameKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


public extension UIGestureRecognizer {
    func pd_remove() { view?.removeGestureRecognizer(self) }
}

public extension UIGestureRecognizer {
    @objc private func pd_p_invoke() {
        if let callback = AssociatedObject.get(self, &AssociateKeys.CallbackKey) as? (_ recognizer: UIGestureRecognizer) -> Void {
            callback(self)
        }
    }
}

extension UIGestureRecognizer: Defaultable {}
extension UIGestureRecognizer {
    public typealias Associatedtype = UIGestureRecognizer

    @objc open class func `default`() -> Associatedtype {
        let gestureRecognizer = UIGestureRecognizer()
        return gestureRecognizer
    }
}

public extension UIGestureRecognizer {

    @discardableResult
    func pd_callback(_ callback: @escaping (_ recognizer: UIGestureRecognizer) -> Void) -> Self {
        addTarget(self, action: #selector(pd_p_invoke))
        AssociatedObject.set(self, &AssociateKeys.CallbackKey, callback, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return self
    }

    @discardableResult
    func pd_addTarget(_ target: Any, action: Selector) -> Self {
        addTarget(target, action: action)
        return self
    }
}
