//
//  UIApplication+.swift
//
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

public extension UIApplication {
    /// 清理图标上的角标
    func clearApplicationIconBadge() {
        applicationIconBadgeNumber = 0
    }
}
