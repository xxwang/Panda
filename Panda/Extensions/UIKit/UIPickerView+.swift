import UIKit

public extension UIPickerView {
    typealias Associatedtype = UIPickerView

    override class func `default`() -> Associatedtype {
        let pickerView = UIPickerView()
        return pickerView
    }
}

public extension UIPickerView {
    
    /// 设置代理
    /// - Parameter delegate: 代理
    /// - Returns: `Self`
    @discardableResult
    func pd_delegate(_ delegate: UIPickerViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置数据源
    /// - Parameter dataSource: 数据源
    /// - Returns: `Self`
    @discardableResult
    func pd_dataSource(_ dataSource: UIPickerViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
}
