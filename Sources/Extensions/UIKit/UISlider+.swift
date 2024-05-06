import UIKit

// MARK: - 方法
public extension UISlider {
    /// 设置`value`值
    /// - Parameters:
    ///   - value:要设置的值
    ///   - animated:是否动画
    ///   - duration:动画时间
    ///   - completion:完成回调
    func pd_setValue(_ value: Float, animated: Bool = true, duration: TimeInterval = 0.15, completion: (() -> Void)? = nil) {
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

// MARK: - 关联键
private class AssociateKeys {
    static var CallbackKey = UnsafeRawPointer(bitPattern: ("UISlider" + "CallbackKey").hashValue)
}

// MARK: - AssociatedAttributes
extension UISlider: AssociatedAttributes {
    public typealias T = Float
    public var callback: Callback? {
        get { AssociatedObject.get(self, &AssociateKeys.CallbackKey) as? Callback }
        set { AssociatedObject.set(self, &AssociateKeys.CallbackKey, newValue) }
    }

    /// 事件处理
    /// - Parameter event:事件发生者
    @objc func sliderValueChanged(_ sender: UISlider) {
        callback?(sender.value)
    }
}

// MARK: - Defaultable
public extension UISlider {
    typealias Associatedtype = UISlider

    override class func `default`() -> Associatedtype {
        let slider = UISlider()
        return slider
    }
}

// MARK: - 链式语法
public extension UISlider {
    /// 设置值
    /// - Parameter value: 值
    /// - Returns: `Self`
    func pd_value(_ value: Float) -> Self {
        self.value = value
        return self
    }

    /// 设置最小值
    /// - Parameter minimumValue: 最小值
    /// - Returns: `Self`
    func pd_minimumValue(_ minimumValue: Float) -> Self {
        self.minimumValue = value
        return self
    }

    /// 设置最大值
    /// - Parameter maximumValue: 最大值
    /// - Returns: `Self`
    func pd_maximumValue(_ maximumValue: Float) -> Self {
        self.maximumValue = maximumValue
        return self
    }

    /// 设置最小值图片
    /// - Parameter minimumValueImage: 最小值图片
    /// - Returns: `Self`
    func pd_minimumValueImage(_ minimumValueImage: UIImage?) -> Self {
        self.minimumValueImage = minimumValueImage
        return self
    }

    /// 设置最大值图片
    /// - Parameter maximumValueImage: 最大值图片
    /// - Returns: `Self`
    func pd_maximumValueImage(_ maximumValueImage: UIImage?) -> Self {
        self.maximumValueImage = maximumValueImage
        return self
    }

    /// 设置是否连续
    /// - Parameter isContinuous: 是否连续
    /// - Returns: `Self`
    func pd_isContinuous(_ isContinuous: Bool) -> Self {
        self.isContinuous = isContinuous
        return self
    }

    /// 设置最小值轨道颜色
    /// - Parameter minimumTrackTintColor: 最小值轨道颜色
    /// - Returns: `Self`
    func pd_minimumTrackTintColor(_ minimumTrackTintColor: UIColor?) -> Self {
        self.minimumTrackTintColor = minimumTrackTintColor
        return self
    }

    /// 设置最大值轨道颜色
    /// - Parameter maximumTrackTintColor: 最大值轨道颜色
    /// - Returns: `Self`
    func pd_maximumTrackTintColor(_ maximumTrackTintColor: UIColor?) -> Self {
        self.maximumTrackTintColor = maximumTrackTintColor
        return self
    }

    /// 设置滑动标识颜色
    /// - Parameter thumbTintColor: 滑动标识颜色
    /// - Returns: `Self`
    func pd_thumbTintColor(_ thumbTintColor: UIColor?) -> Self {
        self.thumbTintColor = thumbTintColor
        return self
    }

    /// 添加事件处理
    /// - Parameters:
    ///   - callback: 响应事件的闭包
    ///   - controlEvent: 事件类型
    /// - Returns: `Self`
    func pd_callback(_ callback: ((Float?) -> Void)?, for controlEvent: UIControl.Event = .valueChanged) -> Self {
        self.callback = callback
        self.addTarget(self, action: #selector(sliderValueChanged), for: controlEvent)
        return self
    }
}
