
import UIKit

private class AssociateKeys {
    static var CallbackKey = UnsafeRawPointer(bitPattern: ("UIControl" + "CallbackKey").hashValue)
    static var HitTimerKey = UnsafeRawPointer(bitPattern: ("UIControl" + "HitTimerKey").hashValue)
}

public extension UIControl {}

private extension UIControl {
    var sk_hitTime: Double? {
        get { AssociatedObject.get(self, &AssociateKeys.HitTimerKey) as? Double }
        set { AssociatedObject.set(self, &AssociateKeys.HitTimerKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }

    var sk_callback: ((_ control: UIControl) -> Void)? {
        get { AssociatedObject.get(self, &AssociateKeys.CallbackKey) as? ((_ control: UIControl) -> Void) }
        set { AssociatedObject.set(self, &AssociateKeys.CallbackKey, newValue) }
    }

    func sk_doubleHit(hitTime: Double = 1) {
        self.sk_hitTime = hitTime
        self.addTarget(self, action: #selector(preventDoubleHit), for: .touchUpInside)
    }

    @objc func preventDoubleHit(_ sender: UIControl) {
        self.isUserInteractionEnabled = false
        DispatchQueue.sk_delay_execute(delay: self.sk_hitTime ?? 1.0) { [weak self] in
            guard let self else { return }
            self.isUserInteractionEnabled = true
        }
    }

    @objc func controlEventHandler(_ sender: UIControl) {
        if let block = self.sk_callback { block(sender) }
    }
}

extension UIControl {
    public typealias Associatedtype = UIControl

    override open class func `default`() -> Associatedtype {
        let control = UIControl()
        return control
    }
}

public extension UIControl {

    @discardableResult
    func sk_isEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }

    @discardableResult
    func sk_isSelected(_ isSelected: Bool) -> Self {
        self.isSelected = isSelected
        return self
    }

    @discardableResult
    func sk_isHighlighted(_ isHighlighted: Bool) -> Self {
        self.isHighlighted = isHighlighted
        return self
    }

    @discardableResult
    func sk_contentVerticalAlignment(_ contentVerticalAlignment: UIControl.ContentVerticalAlignment) -> Self {
        self.contentVerticalAlignment = contentVerticalAlignment
        return self
    }

    @discardableResult
    func sk_contentHorizontalAlignment(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = contentHorizontalAlignment
        return self
    }

    @discardableResult
    func sk_addTarget(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        self.addTarget(target, action: action, for: event)
        return self
    }

    @discardableResult
    func sk_removeAction(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        removeTarget(target, action: action, for: event)
        return self
    }

    @discardableResult
    func sk_disableMultiTouch(_ hitTime: Double = 1) -> Self {
        self.sk_doubleHit(hitTime: hitTime)
        return self
    }

    @discardableResult
    func sk_callback(_ callback: ((_ control: UIControl) -> Void)?, for controlEvent: UIControl.Event = .touchUpInside) -> Self {
        self.sk_callback = callback
        addTarget(self, action: #selector(controlEventHandler(_:)), for: controlEvent)
        return self
    }
}
