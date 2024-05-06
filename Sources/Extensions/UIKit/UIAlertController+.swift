//
//  UIAlertController+.swift
//
//
//  Created by xxwang on 2023/5/21.
//

import AudioToolbox
import UIKit

// MARK: - 构造方法
public extension UIAlertController {
    /// 创建 `UIAlertController`
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 详细的信息
    ///   - titles: 按钮标题数组
    ///   - style: 弹出样式
    ///   - tintColor: `UIAlertController`的`tintColor`
    ///   - highlightedIndex: 高亮按钮索引
    ///   - completion: 按钮点击回调
    convenience init(_ title: String? = nil,
                     message: String? = nil,
                     titles: [String] = [],
                     style: UIAlertController.Style = .alert,
                     tintColor: UIColor? = nil,
                     highlightedIndex: Int? = nil,
                     completion: ((Int) -> Void)? = nil)
    {
        self.init(title: title, message: message, preferredStyle: style)

        // 设置tintColor
        if let color = tintColor { view.tintColor = color }

        // 添加选项按钮
        for (index, title) in titles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: { _ in
                completion?(index)
            })
            addAction(action)

            // 高亮按钮
            if let highlightedIndex, index == highlightedIndex { preferredAction = action }
        }
    }
}

// MARK: - 显示弹窗
public extension UIAlertController {
    /// 用于在做任意控制器上显示`UIAlertController`(alert样式)
    /// - Parameters:
    ///   - title:提示标题
    ///   - message:提示内容
    ///   - titles:按钮标题数组
    ///   - tintColor: `UIAlertController`的`tintColor`
    ///   - highlightedIndex:高亮按钮索引
    ///   - completion:完成回调
    /// - Returns:`UIAlertController`实例
    @discardableResult
    static func showAlertController(_ title: String? = nil,
                                    message: String? = nil,
                                    titles: [String] = [],
                                    tintColor: UIColor? = nil,
                                    highlightedIndex: Int? = nil,
                                    completion: ((Int) -> Void)? = nil) -> UIAlertController
    {
        // 初始化UIAlertController
        let alertController = UIAlertController(title, message: message, style: .alert, highlightedIndex: highlightedIndex, completion: completion)

        // 弹出UIAlertController
        UIWindow.rootViewController()?.present(alertController, animated: true, completion: nil)

        return alertController
    }

    /// 用于在做任意控制器上显示`UIAlertController`(sheet样式)
    /// - Parameters:
    ///   - title:提示标题
    ///   - message:提示内容
    ///   - titles:按钮标题数组
    ///   - tintColor: `UIAlertController`的`tintColor`
    ///   - highlightedIndex:高亮按钮索引
    ///   - completion:完成回调
    /// - Returns:`UIAlertController`实例
    @discardableResult
    static func showSheetController(_ title: String? = nil,
                                    message: String? = nil,
                                    titles: [String] = [],
                                    tintColor: UIColor? = nil,
                                    highlightedIndex: Int? = nil,
                                    completion: ((Int) -> Void)? = nil) -> UIAlertController
    {
        // 初始化UIAlertController
        let alertController = UIAlertController(title, message: message, style: .actionSheet, highlightedIndex: highlightedIndex, completion: completion)

        // 弹出UIAlertController
        UIWindow.rootViewController()?.present(alertController, animated: true, completion: nil)

        return alertController
    }

    /// 用于弹起`UIAlertController`实例
    /// - Parameters:
    ///   - animated:是否动画
    ///   - shake:是否震动
    ///   - deadline:消失时间
    ///   - completion:完成回调
    func show(animated: Bool = true, shake: Bool = false, deadline: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        // 弹起UIAlertController实例
        UIWindow.main?.rootViewController?.present(self, animated: animated, completion: completion)
        // 是否震动
        if shake { AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) }

        // 是否需要自动消失
        guard let deadline else { return }

        // 根据deadline来让UIAlertController实例消失
        DispatchQueue.pd_delay_execute(delay: deadline) { [weak self] in
            guard let self else { return }
            dismiss(animated: animated, completion: nil)
        }
    }
}

// MARK: - Defaultable
public extension UIAlertController {
    typealias Associatedtype = UIAlertController

    override class func `default`() -> Associatedtype {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        return alertController
    }
}

// MARK: - 链式语法
public extension UIAlertController {
    /// 设置标题
    /// - Parameter title:标题
    /// - Returns:`Self`
    @discardableResult
    func pd_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置消息(副标题)
    /// - Parameter message:消息内容
    /// - Returns:`Self`
    @discardableResult
    func pd_message(_ message: String?) -> Self {
        self.message = message
        return self
    }

    /// 添加 `UIAlertAction`
    /// - Parameter action:`UIAlertAction` 事件
    /// - Returns:`Self`
    @discardableResult
    func pd_addAction(_ action: UIAlertAction) -> Self {
        addAction(action)
        return self
    }

    /// 添加一个`UIAlertAction`
    /// - Parameters:
    ///   - title:标题
    ///   - style:样式
    ///   - isEnable:是否激活
    ///   - action:点击处理回调
    /// - Returns:`Self`
    @discardableResult
    func pd_addAction_(title: String, style: UIAlertAction.Style = .default, action: ((UIAlertAction) -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: action)
        addAction(action)
        return self
    }

    /// 添加一个`UITextField`
    /// - Parameters:
    ///   - text:输入框默认文字
    ///   - placeholder:占位文本
    ///   - target:事件响应者
    ///   - action:事件响应方法
    /// - Returns:`Self`
    @discardableResult
    func pd_addTextField(_ text: String? = nil, placeholder: String? = nil, target: Any?, action: Selector?) -> Self {
        addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
            if let target,
               let action
            {
                textField.addTarget(target, action: action, for: .editingChanged)
            }
        }
        return self
    }
}
