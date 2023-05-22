//
//  UISlider+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - Defaultable
public extension UISlider {
    typealias Associatedtype = UISlider

    override class func `default`() -> Associatedtype {
        let slider = UISlider()
        return slider
    }
}
