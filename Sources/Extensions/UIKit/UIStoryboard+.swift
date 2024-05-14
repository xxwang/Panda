
import UIKit

public extension UIStoryboard {

    static var xx_main: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else { return nil }
        return UIStoryboard(name: name, bundle: bundle)
    }
}


public extension UIStoryboard {

    func xx_instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
}
