//
//  UIImage+.swift
//
//
//  Created by 王斌 on 2023/5/21.
//

import AVFoundation
import CoreImage
import Dispatch
import Photos
import UIKit

// MARK: - 属性
public extension UIImage {
    /// `UIImage`的大小(单位:bytes/字节)
    var size_bytes: Int {
        jpegData(compressionQuality: 1)?.count ?? 0
    }

    /// `UIImage`的大小(单位:`KB`)
    var size_kb: Int {
        (jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }

    /// 获取原始渲染模式下的图片
    var original: UIImage {
        withRenderingMode(.alwaysOriginal)
    }

    /// 获取模板渲染模式下的图片
    var template: UIImage {
        withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - 构造方法
public extension UIImage {
    /// 根据颜色和大小创建UIImage
    /// - Parameters:
    ///   - color:图像填充颜色
    ///   - size:图像尺寸
    convenience init(with color: UIColor, size: CGSize = 1.toCGSize()) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer { UIGraphicsEndImageContext() }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }

    /// 从URL创建新图像
    /// - Parameters:
    ///   - imageUrl: 图片Url地址
    ///   - scale: 缩放比例
    convenience init?(imageUrl: URL, scale: CGFloat = 1.0) throws {
        let data = try Data(contentsOf: imageUrl)
        self.init(data: data, scale: scale)
    }

    /// 用不同的图片名称创建动态图片
    /// - Parameters:
    ///   - lightImageName:高亮图片名称
    ///   - darkImageName:暗调图片名称
    convenience init(lightImageName: String, darkImageName: String? = nil) {
        self.init(lightImage: lightImageName.toImage(),
                  darkImage: (darkImageName ?? lightImageName).toImage())
    }

    /// 用不同的图片创建动态图片
    /// - Parameters:
    ///   - lightImage:高亮图片
    ///   - darkImage:暗调图片
    convenience init(lightImage: UIImage?, darkImage: UIImage?) {
        if #available(iOS 13.0, *) {
            guard var lightImage else { self.init(); return }
            guard var darkImage else { self.init(); return }
            guard let config = lightImage.configuration else { self.init(); return }

            lightImage = lightImage.withConfiguration(
                config.withTraitCollection(UITraitCollection(userInterfaceStyle: .light)))
            lightImage.imageAsset?.register(
                darkImage,
                with: config.withTraitCollection(UITraitCollection(userInterfaceStyle: .dark))
            )
            let currentImage = lightImage.imageAsset?.image(with: .current) ?? lightImage
            self.init(cgImage: currentImage.cgImage!)
        } else {
            self.init(cgImage: lightImage!.cgImage!)
        }
    }
}

// MARK: - 动态图片的使用
public extension UIImage {
    /// 深色图片和浅色图片切换 (深色模式适配)
    /// - Parameters:
    ///   - lightImage:浅色模式的图片名称
    ///   - darkImage:深色模式的图片名称
    /// - Returns:最终图片
    static func darkModeImage(_ lightImageName: String, darkImageName: String? = nil) -> UIImage? {
        darkModeImage(UIImage(named: lightImageName), darkImage: UIImage(named: darkImageName ?? lightImageName))
    }

    /// 深色图片和浅色图片切换 (深色模式适配)
    /// - Parameters:
    ///   - lightImage:浅色模式的图片
    ///   - darkImage:深色模式的图片
    /// - Returns:最终图片
    static func darkModeImage(_ lightImage: UIImage?, darkImage: UIImage?) -> UIImage? {
        if #available(iOS 13.0, *) {
            guard var lightImage else { return lightImage }
            guard var darkImage else { return lightImage }
            guard let config = lightImage.configuration else { return lightImage }

            lightImage = lightImage.withConfiguration(
                config.withTraitCollection(UITraitCollection(userInterfaceStyle: .light)))
            lightImage.imageAsset?.register(
                darkImage, with:
                config.withTraitCollection(UITraitCollection(userInterfaceStyle: .dark))
            )
            return lightImage.imageAsset?.image(with: .current) ?? lightImage
        } else {
            return lightImage
        }
    }
}
