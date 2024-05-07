import UIKit

public protocol Defaultable: NSObjectProtocol where Self: NSObject {

    associatedtype Associatedtype
    static func `default`() -> Associatedtype
}

public protocol AssociatedAttributes {
    associatedtype T
    typealias Callback = (T?) -> Void
    var callback: Callback? { get set }
}

func configure<T: AnyObject>(_ object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}
