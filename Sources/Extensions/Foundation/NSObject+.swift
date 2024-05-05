import Foundation

// MARK: - 方法
public extension NSObject {
    /// 获取对象的类名字符串
    /// - Returns: 类名字符串
    func pd_className() -> String {
        let name = type(of: self).description()
        guard name.contains(".") else { return name }
        return name.components(separatedBy: ".").last ?? ""
    }

    /// 获取类的名称字符串
    /// - Returns: 名称字符串
    static func pd_className() -> String {
        String(describing: Self.self)
    }

    /// 获取类中所有的成员变量名称
    /// - Returns: 成员变量名称数组
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

// MARK: - 交换方法
public extension NSObject {
    /// 交换类的两个方法(方法前需要`@objc dynamic`修饰)
    /// - Parameters:
    ///   - originalSelector: 原始方法
    ///   - newSelector: 新方法
    /// - Returns: 交换结果
    class func pd_hookClassMethod(of originalSelector: Selector, with newSelector: Selector) -> Bool {
        return self.pd_hookMethod(of: originalSelector, with: newSelector, classMethod: true)
    }

    /// 交换对象的两个方法(方法前需要`@objc dynamic`修饰)
    /// - Parameters:
    ///   - originalSelector: 原始方法
    ///   - newSelector: 新方法
    /// - Returns: 交换结果
    class func pd_hookInstanceMethod(of originalSelector: Selector, with newSelector: Selector) -> Bool {
        return self.pd_hookMethod(of: originalSelector, with: newSelector, classMethod: false)
    }

    /// 交换类的两个方法(方法前需要`@objc dynamic`修饰)
    /// - Parameters:
    ///   - originalSelector: 原始方法
    ///   - newSelector: 新方法
    ///   - classMethod: 是否是类的方法
    /// - Returns: 交换结果
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

        // 判断原有类中是否有要替换方法的实现
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

// MARK: - setValue
@objc public extension NSObject {
    /// 初始化方法
    /// - Note: 由于在`swift`中`initialize()`这个方法已经被废弃了,所以需要在`Appdelegate`中调用此方法
    class func pd_initializeMethod() {
        if self != NSObject.self { return }
        // 设值方法交换
        self.pd_hook_setValues()
    }

    /// 交换设值方法
    private class func pd_hook_setValues() {
        let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
        DispatchQueue.once(token: onceToken) {
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

    /// 调用`setValue`方法时如果键不存在会调用这个方法
    /// - Parameters:
    ///   - value: 值
    ///   - key: 键
    private func pd_hook_setValue(_ value: Any?, forUndefinedKey key: String) {
        Logger.warning("setValue(_:forUndefinedKey:), 未知键Key:\(key) 值:\(value ?? "")")
    }

    /// 调用`setValue`方法时如果键不存在会调用这个方法
    /// - Parameters:
    ///   - key: 键
    private func pd_hook_value(forUndefinedKey key: String) -> Any? {
        Logger.warning("value(forUndefinedKey:), 未知键:\(key)")
        return nil
    }

    /// 给一个非指针对象(如`NSInteger`)赋值 `nil`, 直接忽略
    /// - Parameter key: 键
    private func pd_hook_setNilValueForKey(_ key: String) {
        Logger.warning("setNilValueForKey(_:), 不能给非指针对象(如NSInteger)赋值 nil 键:\(key)")
    }

    /// 用于替换`setValuesForKeys(_:)`
    /// - Parameter keyedValues: 键值字典
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
