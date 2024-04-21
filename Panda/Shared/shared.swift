import UIKit

// public protocol Defaultable: NSObjectProtocol where Self: NSObject {
public protocol Defaultable {
    /// 关联类型
    associatedtype Associatedtype

    /// 生成默认对象
    /// - Returns: 对象
    static func `default`() -> Associatedtype
}

// MARK: - 关联属性(增加callback属性)`协议`
public protocol AssociatedAttributes {
    associatedtype T
    typealias Callback = (T?) -> Void
    var callback: Callback? { get set }
}

/// 对对象进行配置
///
/// - Note: 需要对象是引用类型
/// - Parameters:
///   - object: 要配置的对象
///   - closure: 进行配置的闭包
/// - Returns: 配置完的对象
func configure<T: AnyObject>(_ object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}
