//
//  UIPickerView+.swift
//  BaseFramework
//
//  Created by apple on 2024/3/28.
//

import UIKit

public extension UIPickerView {
    typealias Associatedtype = UIPickerView

    override class func `default`() -> Associatedtype {
        let pickerView = UIPickerView()
        return pickerView
    }
}

extension UIPickerView {
    @discardableResult
    func pd_delegate(_ delegate: UIPickerViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    @discardableResult
    func pd_dataSource(_ dataSource: UIPickerViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
}
