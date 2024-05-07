
import AudioToolbox
import UIKit

public extension UIAlertController {

    convenience init(_ title: String? = nil,
                     message: String? = nil,
                     titles: [String] = [],
                     style: UIAlertController.Style = .alert,
                     tintColor: UIColor? = nil,
                     highlightedIndex: Int? = nil,
                     completion: ((Int) -> Void)? = nil)
    {
        self.init(title: title, message: message, preferredStyle: style)

        if let color = tintColor { view.tintColor = color }

        for (index, title) in titles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: { _ in
                completion?(index)
            })
            addAction(action)

            if let highlightedIndex, index == highlightedIndex { preferredAction = action }
        }
    }
}


public extension UIAlertController {

    @discardableResult
    static func pd_showAlertController(_ title: String? = nil,
                                       message: String? = nil,
                                       titles: [String] = [],
                                       tintColor: UIColor? = nil,
                                       highlightedIndex: Int? = nil,
                                       completion: ((Int) -> Void)? = nil) -> UIAlertController
    {

        let alertController = UIAlertController(title, message: message, style: .alert, highlightedIndex: highlightedIndex, completion: completion)

        UIWindow.pd_rootViewController()?.present(alertController, animated: true, completion: nil)

        return alertController
    }

    @discardableResult
    static func pd_showSheetController(_ title: String? = nil,
                                       message: String? = nil,
                                       titles: [String] = [],
                                       tintColor: UIColor? = nil,
                                       highlightedIndex: Int? = nil,
                                       completion: ((Int) -> Void)? = nil) -> UIAlertController
    {
        let alertController = UIAlertController(title, message: message, style: .actionSheet, highlightedIndex: highlightedIndex, completion: completion)
        UIWindow.pd_rootViewController()?.present(alertController, animated: true, completion: nil)

        return alertController
    }

    func pd_show(animated: Bool = true, shake: Bool = false, deadline: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        UIWindow.pd_main?.rootViewController?.present(self, animated: animated, completion: completion)
        if shake { AudioServicesPlayAlertSound(kSystemSoundID_Vibrate) }
        guard let deadline else { return }
        DispatchQueue.pd_delay_execute(delay: deadline) { [weak self] in
            guard let self else { return }
            dismiss(animated: animated, completion: nil)
        }
    }
}

public extension UIAlertController {
    typealias Associatedtype = UIAlertController

    override class func `default`() -> Associatedtype {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        return alertController
    }
}

public extension UIAlertController {

    @discardableResult
    func pd_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    @discardableResult
    func pd_message(_ message: String?) -> Self {
        self.message = message
        return self
    }

    @discardableResult
    func pd_addAction(_ action: UIAlertAction) -> Self {
        addAction(action)
        return self
    }

    @discardableResult
    func pd_addAction_(title: String, style: UIAlertAction.Style = .default, action: ((UIAlertAction) -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: action)
        addAction(action)
        return self
    }

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
