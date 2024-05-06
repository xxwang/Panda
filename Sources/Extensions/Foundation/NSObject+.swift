import Foundation

public extension NSObject {
    func pd_className() -> String {
        let name = type(of: self).description()
        guard name.contains(".") else { return name }
        return name.components(separatedBy: ".").last ?? ""
    }

    static func pd_className() -> String {
        String(describing: Self.self)
    }

    static func pd_members() -> [String] {
        var varNames = [String]()
        var count: UInt32 = 0
        let ivarList = class_copyIvarList(Self.self, &count)

        for i in 0 ..< count {
            let ivar = ivarList![Int(i)]
            let cName = ivar_getName(ivar)
            if let name = String(cString: cName!, encoding: String.Encoding.utf8) {
                varNames.append(name)
            }
        }
        free(ivarList)

        return varNames
    }
}

public extension NSObject {
    class func pd_hookClassMethod(of originalSelector: Selector, with newSelector: Selector) -> Bool {
        return self.pd_hookMethod(of: originalSelector, with: newSelector, classMethod: true)
    }

    class func pd_hookInstanceMethod(of originalSelector: Selector, with newSelector: Selector) -> Bool {
        return self.pd_hookMethod(of: originalSelector, with: newSelector, classMethod: false)
    }

    class func pd_hookMethod(of originalSelector: Selector, with newSelector: Selector, classMethod: Bool) -> Bool {
        if self != NSObject.self { return false }
        let selfClass: AnyClass = Self.classForCoder()

        guard
            let originalMethod = (classMethod
                ? class_getClassMethod(selfClass, originalSelector)
                : class_getInstanceMethod(selfClass, originalSelector)),
            let newMethod = (classMethod
                ? class_getClassMethod(selfClass, newSelector)
                : class_getInstanceMethod(selfClass, newSelector))
        else { return false }

        let didAddMethod = class_addMethod(
            selfClass,
            originalSelector,
            method_getImplementation(newMethod),
            method_getTypeEncoding(newMethod)
        )

        if didAddMethod {
            class_replaceMethod(
                selfClass,
                newSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, newMethod)
        }
        return true
    }
}

@objc public extension NSObject {
    class func pd_initializeMethod() {
        if self != NSObject.self { return }
        self.pd_hook_setValues()
    }

    private class func pd_hook_setValues() {
        let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
        DispatchQueue.pd_once(token: onceToken) {
            let oriSel = #selector(self.setValue(_:forUndefinedKey:))
            let repSel = #selector(self.pd_hook_setValue(_:forUndefinedKey:))
            _ = self.pd_hookInstanceMethod(of: oriSel, with: repSel)

            let oriSel0 = #selector(self.value(forUndefinedKey:))
            let repSel0 = #selector(self.pd_hook_value(forUndefinedKey:))
            _ = self.pd_hookInstanceMethod(of: oriSel0, with: repSel0)

            let oriSel1 = #selector(self.setNilValueForKey(_:))
            let repSel1 = #selector(self.pd_hook_setNilValueForKey(_:))
            _ = self.pd_hookInstanceMethod(of: oriSel1, with: repSel1)

            let oriSel2 = #selector(self.setValuesForKeys(_:))
            let repSel2 = #selector(self.pd_hook_setValuesForKeys(_:))
            _ = self.pd_hookInstanceMethod(of: oriSel2, with: repSel2)
        }
    }

    private func pd_hook_setValue(_ value: Any?, forUndefinedKey key: String) {
        Logger.warning("setValue(_:forUndefinedKey:), UndefinedKey:\(key) 值:\(value ?? "")")
    }

    private func pd_hook_value(forUndefinedKey key: String) -> Any? {
        Logger.warning("value(forUndefinedKey:), UndefinedKey:\(key)")
        return nil
    }

    private func pd_hook_setNilValueForKey(_ key: String) {
        Logger.warning("setNilValueForKey(_:), key:\(key)")
    }

    private func pd_hook_setValuesForKeys(_ keyedValues: [String: Any]) {
        for (key, value) in keyedValues {
            Logger.info("\(key) -- \(value)")
            if value is Int || value is CGFloat || value is Double {
                setValue("\(value)", forKey: key)
            } else {
                setValue(value, forKey: key)
            }
        }
    }
}
