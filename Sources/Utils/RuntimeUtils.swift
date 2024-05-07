
import UIKit

public class RuntimeUtils: NSObject {}


public extension RuntimeUtils {

    @discardableResult
    static func ivars(_ type: AnyClass) -> [String] {
        var listName = [String]()
        var count: UInt32 = 0
        let ivars = class_copyIvarList(type, &count)
        for i in 0 ..< count {
            let nameP = ivar_getName(ivars![Int(i)])!
            let name = String(cString: nameP)
            listName.append(name)
        }
      
        free(ivars)
        return listName
    }

    @discardableResult
    static func getAllPropertyName(_ aClass: AnyClass) -> [String] {
        var count = UInt32()
        let properties = class_copyPropertyList(aClass, &count)
        var propertyNames = [String]()
        let intCount = Int(count)
        for i in 0 ..< intCount {
            let property: objc_property_t = properties![i]

            guard let propertyName = NSString(utf8String: property_getName(property)) as String? else {
                print("Couldn't unwrap property name for \(property)")
                break
            }
            propertyNames.append(propertyName)
        }
        free(properties)
        return propertyNames
    }

    @discardableResult
    static func methods(from classType: AnyClass) -> [Selector] {
        var methodNum: UInt32 = 0
        var list = [Selector]()
        let methods = class_copyMethodList(classType, &methodNum)
        for index in 0 ..< numericCast(methodNum) {
            if let met = methods?[index] {
                let selector = method_getName(met)
                list.append(selector)
            }
        }
        free(methods)
        return list
    }
}

public extension RuntimeUtils {

    static func exchangeMethod(target: String,
                               replace: String,
                               class classType: AnyClass)
    {
        exchangeMethod(selector: Selector(target),
                       replace: Selector(replace),
                       class: classType)
    }

    static func exchangeMethod(selector: Selector,
                               replace: Selector,
                               class classType: AnyClass)
    {
        let select1 = selector
        let select2 = replace

        let select1Method = class_getInstanceMethod(classType, select1)
        let select2Method = class_getInstanceMethod(classType, select2)

        let didAddMethod = class_addMethod(classType, select1, method_getImplementation(select2Method!), method_getTypeEncoding(select2Method!))
        if didAddMethod {
            class_replaceMethod(classType, select2, method_getImplementation(select1Method!), method_getTypeEncoding(select1Method!))
        } else {
            method_exchangeImplementations(select1Method!, select2Method!)
        }
    }
}
