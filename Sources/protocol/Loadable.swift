import UIKit

public protocol Loadable {}

public extension Loadable where Self: UIView {

    static func pd_loadNib(_ nibName: String? = nil) -> Self {
        let nibName = nibName ?? "\(self)"
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! Self
    }
}

public extension Loadable where Self: UIViewController {

    static func pd_loadStoryboard(withClass name: Self.Type, in bundle: Bundle? = nil, fileName: String? = nil) -> Self? {
        let bundle = bundle ?? Bundle.main
        guard let storyboardFileName = fileName ?? bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        let storyboard = UIStoryboard(name: storyboardFileName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: String(describing: name)) as? Self
    }
}
