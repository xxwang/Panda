//
//  UIImage+.swift
//  
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

// MARK: - 构造方法
public extension UIImage {
    /// 根据颜色和大小创建UIImage
    /// - Parameters:
    ///   - color:图像填充颜色
    ///   - size:图像尺寸
    convenience init(with color: UIColor, size: CGSize = 1.toCGSize()) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    
    
}
