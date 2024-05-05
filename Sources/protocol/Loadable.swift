import UIKit

public protocol Loadable {}

public extension Loadable where Self: UIView {
    /// 加载与类同名的`xib`视图
    /// - Parameter nibName: `xib`文件名称
    /// - Returns: 类对象
    static func pd_loadNib(_ nibName: String? = nil) -> Self {
        let nibName = nibName ?? "\(self)"
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! Self
    }
}

public extension Loadable where Self: UIViewController {
    /// 加载`storyboard`中的控制器
    /// - Parameters:
    ///   - name: 要加载的控制器(与`storyboard`中的`Identifier`一致)
    ///   - bundle: `storyboard`所在`bundle`
    ///   - fileName: `storyboard`文件名称
    /// - Returns: 指定的控制器
    static func pd_loadStoryboard(withClass name: Self.Type, in bundle: Bundle? = nil, fileName: String? = nil) -> Self? {
        let bundle = bundle ?? Bundle.main
        guard let storyboardFileName = fileName ?? bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        let storyboard = UIStoryboard(name: storyboardFileName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: String(describing: name)) as? Self
    }
}
