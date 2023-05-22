//
//  UISlider+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - 方法
public extension UISlider {
    /// 设置`value`值
    /// - Parameters:
    ///   - value:要设置的值
    ///   - animated:是否动画
    ///   - duration:动画时间
    ///   - completion:完成回调
    func setValue(_ value: Float, animated: Bool = true, duration: TimeInterval = 0.15, completion: (() -> Void)? = nil) {
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
private enum AssociateKeys {
    static var CallbackKey = "UISlider" + "CallbackKey"
}

// MARK: - AssociatedAttributes
extension UISlider: AssociatedAttributes {
    internal typealias T = Float
    internal var callback: Callback? {
        get { AssociatedObject.object(self, &AssociateKeys.CallbackKey) }
        set { AssociatedObject.associate(self, &AssociateKeys.CallbackKey, newValue) }
    }

    /// 事件处理
    /// - Parameter event:事件发生者
    @objc internal func sliderValueChanged(_ sender: UISlider) {
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
    /// 添加事件处理
    /// - Parameters:
    ///   - action:响应事件的闭包
    ///   - controlEvent:事件类型
    func pd_callback(_ callback: ((Float?) -> Void)?, for controlEvent: UIControl.Event = .valueChanged) -> Self {
        self.callback = callback
        addTarget(self, action: #selector(sliderValueChanged), for: controlEvent)
        return self
    }
}
