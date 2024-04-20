import UIKit

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
