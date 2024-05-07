import UIKit


public class AssociatedObject {

    static func set(
        _ object: Any,
        _ key: UnsafeRawPointer,
        _ value: some Any,
        _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    ) {
        objc_setAssociatedObject(object, key, value, policy)
    }

    static func get(_ object: Any, _ key: UnsafeRawPointer) -> Any? {
        objc_getAssociatedObject(object, key)
    }

    static func remove(_ object: Any) {
        objc_removeAssociatedObjects(object)
    }
}
