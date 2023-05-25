//
//  NSObject+.swift
//
//
//  Created by 王斌 on 2023/5/23.
//

import Foundation

// MARK: - 属性
public extension NSObject {
    /// 获取类中所有成员变量
    static var memberVariables: [String] {
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

// MARK: - 方法
public extension NSObject {
    /// 获取`对象`的`类名字符串`(类需要继承自`NSObject`)
    func className() -> String {
        let name = type(of: self).description()
        guard name.contains(".") else { return name }
        return name.components(separatedBy: ".").last ?? ""
    }

    /// 获取`类`的`类名字符串`
    static func className() -> String {
        String(describing: Self.self)
    }
}

// MARK: - 交换方法
public extension NSObject {
    /// 交换类的两个方法(方法前需要`@objc dynamic`修饰)
    /// - Parameters:
    ///   - originalSelector:原始方法
    ///   - newSelector:新方法
    /// - Returns:是否交换成功
    class func hookClassMethod(of originalSelector: Selector, with newSelector: Selector) -> Bool {
        hookMethod(of: originalSelector, with: newSelector, classMethod: true)
    }

    /// 交换对象的两个方法(方法前需要`@objc dynamic`修饰)
    /// - Parameters:
    ///   - originalSelector:原始方法
    ///   - newSelector:新方法
    /// - Returns:是否交换成功
    class func hookInstanceMethod(of originalSelector: Selector, with newSelector: Selector) -> Bool {
        hookMethod(of: originalSelector, with: newSelector, classMethod: false)
    }

    /// 交换类的两个方法(方法前需要`@objc dynamic`修饰)
    /// - Parameters:
    ///   - originalSelector:原始方法
    ///   - newSelector:新方法
    ///   - isClassMethod:是否是类的方法
    /// - Returns:是否交换成功
    class func hookMethod(of originalSelector: Selector, with newSelector: Selector, classMethod: Bool) -> Bool {
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
    // FIXME: - 需要完善
    /// 由于在`swift`中`initialize()`这个方法已经被废弃了,所以需要在`Appdelegate`中调用此方法
    class func initializeMethod() {
        if self != NSObject.self { return }
        // 设值方法交换
        Self.hook_setValues()
    }

    // FIXME: - 需要完善
    /// 交换设值方法
    private class func hook_setValues() {
        let onceToken = "Hook_\(NSStringFromClass(classForCoder()))"
        DispatchQueue.once(token: onceToken) {
            let oriSel = #selector(self.setValue(_:forUndefinedKey:))
            let repSel = #selector(self.hook_setValue(_:forUndefinedKey:))
            _ = self.hookInstanceMethod(of: oriSel, with: repSel)

            let oriSel0 = #selector(self.value(forUndefinedKey:))
            let repSel0 = #selector(self.hook_value(forUndefinedKey:))
            _ = self.hookInstanceMethod(of: oriSel0, with: repSel0)

            let oriSel1 = #selector(self.setNilValueForKey(_:))
            let repSel1 = #selector(self.hook_setNilValueForKey(_:))
            _ = self.hookInstanceMethod(of: oriSel1, with: repSel1)

            let oriSel2 = #selector(self.setValuesForKeys(_:))
            let repSel2 = #selector(self.hook_setValuesForKeys(_:))
            _ = self.hookInstanceMethod(of: oriSel2, with: repSel2)
        }
    }

    // FIXME: - 需要完善
    /// 如果键不存在会调用这个方法
    private func hook_setValue(_ value: Any?, forUndefinedKey key: String) {
        Log.warning("setValue(_:forUndefinedKey:), 未知键Key:\(key) 值:\(value ?? "")")
    }

    // FIXME: - 需要完善
    /// 如果键不存在会调用这个方法
    private func hook_value(forUndefinedKey key: String) -> Any? {
        Log.warning("value(forUndefinedKey:), 未知键:\(key)")
        return nil
    }

    // FIXME: - 需要完善
    /// 给一个非指针对象(如`NSInteger`)赋值 `nil`, 直接忽略
    private func hook_setNilValueForKey(_ key: String) {
        Log.warning("setNilValueForKey(_:), 不能给非指针对象(如NSInteger)赋值 nil 键:\(key)")
    }

    // FIXME: - 需要完善
    /// 用于替换`setValuesForKeys(_:)`
    private func hook_setValuesForKeys(_ keyedValues: [String: Any]) {
        for (key, value) in keyedValues {
            Log.info("\(key) -- \(value)")
            if value is Int || value is CGFloat || value is Double {
                setValue("\(value)", forKey: key)
            } else {
                setValue(value, forKey: key)
            }
        }
    }
}
