
import UIKit


public extension UISwitch {
    typealias Associatedtype = UISwitch

    override class func `default`() -> Associatedtype {
        let switchButton = UISwitch()
        return switchButton
    }
}


public extension UISwitch {

    @discardableResult
    func pd_toggle(animated: Bool = true) -> Self {
        setOn(!isOn, animated: animated)
        return self
    }
}
