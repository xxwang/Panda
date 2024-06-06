import UIKit

public extension UIPickerView {
    typealias Associatedtype = UIPickerView

    override class func `default`() -> Associatedtype {
        let pickerView = UIPickerView()
        return pickerView
    }
}

public extension UIPickerView {

    @discardableResult
    func sk_delegate(_ delegate: UIPickerViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func sk_dataSource(_ dataSource: UIPickerViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
}
