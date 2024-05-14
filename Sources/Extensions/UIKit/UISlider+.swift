import UIKit

public extension UISlider {

    func xx_setValue(_ value: Float, animated: Bool = true, duration: TimeInterval = 0.15, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.setValue(value, animated: true)
            }, completion: { _ in
                completion?()
            })
        } else {
            setValue(value, animated: false)
            completion?()
        }
    }
}

private class AssociateKeys {
    static var CallbackKey = UnsafeRawPointer(bitPattern: ("UISlider" + "CallbackKey").hashValue)
}

extension UISlider: AssociatedAttributes {
    public typealias T = Float
    public var callback: Callback? {
        get { AssociatedObject.get(self, &AssociateKeys.CallbackKey) as? Callback }
        set { AssociatedObject.set(self, &AssociateKeys.CallbackKey, newValue) }
    }

    @objc func sliderValueChanged(_ sender: UISlider) {
        callback?(sender.value)
    }
}

public extension UISlider {
    typealias Associatedtype = UISlider

    override class func `default`() -> Associatedtype {
        let slider = UISlider()
        return slider
    }
}

public extension UISlider {

    func xx_value(_ value: Float) -> Self {
        self.value = value
        return self
    }

    func xx_minimumValue(_ minimumValue: Float) -> Self {
        self.minimumValue = value
        return self
    }

    func xx_maximumValue(_ maximumValue: Float) -> Self {
        self.maximumValue = maximumValue
        return self
    }

    func xx_minimumValueImage(_ minimumValueImage: UIImage?) -> Self {
        self.minimumValueImage = minimumValueImage
        return self
    }

    func xx_maximumValueImage(_ maximumValueImage: UIImage?) -> Self {
        self.maximumValueImage = maximumValueImage
        return self
    }

    func xx_isContinuous(_ isContinuous: Bool) -> Self {
        self.isContinuous = isContinuous
        return self
    }

    func xx_minimumTrackTintColor(_ minimumTrackTintColor: UIColor?) -> Self {
        self.minimumTrackTintColor = minimumTrackTintColor
        return self
    }

    func xx_maximumTrackTintColor(_ maximumTrackTintColor: UIColor?) -> Self {
        self.maximumTrackTintColor = maximumTrackTintColor
        return self
    }

    func xx_thumbTintColor(_ thumbTintColor: UIColor?) -> Self {
        self.thumbTintColor = thumbTintColor
        return self
    }

    func xx_callback(_ callback: ((Float?) -> Void)?, for controlEvent: UIControl.Event = .valueChanged) -> Self {
        self.callback = callback
        self.addTarget(self, action: #selector(sliderValueChanged), for: controlEvent)
        return self
    }
}
