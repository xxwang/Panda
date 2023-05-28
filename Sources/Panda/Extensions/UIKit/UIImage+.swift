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

// MARK: - Base64
public extension UIImage {
    /// 图像的`Base64`编码`PNG`数据字符串
    ///
    /// - Returns:以字符串形式返回图像的`Base` 64编码`PNG`数据
    func pngBase64String() -> String? {
        pngData()?.base64EncodedString()
    }

    /// 图像的`Base64`编码`JPEG`数据字符串
    /// - Parameter compressionQuality:生成的JPEG图像的质量,表示为0.0到1.0之间的值.值0.0表示最大压缩(或最低质量),而值1.0表示最小压缩(或最佳质量)
    /// - Returns:以字符串形式返回图像的基本64编码JPEG数据
    func jpegBase64String(compressionQuality: CGFloat) -> String? {
        jpegData(compressionQuality: compressionQuality)?.base64EncodedString()
    }
}

// MARK: - 压缩
public extension UIImage {
    // MARK: - 压缩模式
    enum CompressionMode {
        /// 分辨率规则
        static let resolutionRule: (min: CGFloat, max: CGFloat, low: CGFloat, default: CGFloat, high: CGFloat) =
            (10, 4096, 512, 1024, 2048)
        /// 数据大小规则
        static let dataSizeRule: (min: Int, max: Int, low: Int, default: Int, high: Int) =
            (1024 * 10, 1024 * 1024 * 20, 1024 * 512, 1024 * 1024 * 2, 1024 * 1024 * 10)

        // 低质量
        case low
        // 中等质量 默认
        case medium
        // 高质量
        case high
        // 自定义(最大分辨率, 最大输出数据大小)
        case other(CGFloat, Int)

        var maxDataSize: Int {
            switch self {
            case .low:
                return CompressionMode.dataSizeRule.low
            case .medium:
                return CompressionMode.dataSizeRule.default
            case .high:
                return CompressionMode.dataSizeRule.high
            case let .other(_, dataSize):
                if dataSize < CompressionMode.dataSizeRule.min {
                    return CompressionMode.dataSizeRule.default
                }
                if dataSize > CompressionMode.dataSizeRule.max {
                    return CompressionMode.dataSizeRule.max
                }
                return dataSize
            }
        }

        func resize(_ size: CGSize) -> CGSize {
            if size.width < CompressionMode.resolutionRule.min || size.height < CompressionMode.resolutionRule.min {
                return size
            }
            let maxResolution = maxSize
            let aspectRatio = max(size.width, size.height) / maxResolution
            if aspectRatio <= 1.0 {
                return size
            } else {
                let resizeWidth = size.width / aspectRatio
                let resizeHeighth = size.height / aspectRatio
                if resizeHeighth < CompressionMode.resolutionRule.min || resizeWidth < CompressionMode.resolutionRule.min {
                    return size
                } else {
                    return CGSize(width: resizeWidth, height: resizeHeighth)
                }
            }
        }

        var maxSize: CGFloat {
            switch self {
            case .low:
                return CompressionMode.resolutionRule.low
            case .medium:
                return CompressionMode.resolutionRule.default
            case .high:
                return CompressionMode.resolutionRule.high
            case let .other(size, _):
                if size < CompressionMode.resolutionRule.min {
                    return CompressionMode.resolutionRule.default
                }
                if size > CompressionMode.resolutionRule.max {
                    return CompressionMode.resolutionRule.max
                }
                return size
            }
        }
    }

    /// 压缩图片大小(返回`UIImage`)
    /// - Parameter quality:生成的`JPEG`图像的质量,表示为0.0到1.0之间的值.值0.0表示最大压缩(或最低质量),而值1.0表示最小压缩(或最佳质量)(默认值为0.5)
    /// - Returns:压缩后的可选`UIImage`
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }

    /// 压缩`UIImage`并生成`Data`(返回`UIImage`的`Data`)
    ///
    /// - Parameter quality:生成的`JPEG`图像的质量,表示为0.0到1.0之间的值.值0.0表示最大压缩(或最低质量),而值1.0表示最小压缩(或最佳质量)(默认值为0.5)
    /// - Returns:压缩后的可选Data
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        jpegData(compressionQuality: quality)
    }

    /// 压缩图片
    /// - Parameter mode:压缩模式
    /// - Returns:压缩后Data
    func compress(mode: CompressionMode = .medium) -> Data? {
        resizeIO(resizeSize: mode.resize(size))?.compressDataSize(maxSize: mode.maxDataSize)
    }

    /// 异步图片压缩
    /// - Parameters:
    ///   - mode:压缩模式
    ///   - queue:压缩队列
    ///   - complete:完成回调(压缩后Data, 调整后分辨率)
    func asyncCompress(mode: CompressionMode = .medium, queue: DispatchQueue = DispatchQueue.global(), complete: @escaping (Data?, CGSize) -> Void) {
        queue.async {
            let data = self.resizeIO(resizeSize: mode.resize(self.size))?.compressDataSize(maxSize: mode.maxDataSize)
            DispatchQueue.main.async { complete(data, mode.resize(self.size)) }
        }
    }

    /// 压缩图片质量
    /// - Parameter maxSize:最大数据大小
    /// - Returns:压缩后数据
    func compressDataSize(maxSize: Int = 1024 * 1024 * 2) -> Data? {
        let maxSize = maxSize
        var quality: CGFloat = 0.8
        var data = jpegData(compressionQuality: quality)
        var dataCount = data?.count ?? 0

        while (data?.count ?? 0) > maxSize {
            if quality <= 0.6 { break }
            quality = quality - 0.05
            data = jpegData(compressionQuality: quality)
            if (data?.count ?? 0) <= dataCount { break }
            dataCount = data?.count ?? 0
        }
        return data
    }

    /// ImageIO 方式调整图片大小 性能很好
    /// - Parameter resizeSize:图片调整Size
    /// - Returns:调整后图片
    func resizeIO(resizeSize: CGSize) -> UIImage? {
        if size == resizeSize { return self }
        guard let imageData = pngData() else { return nil }
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }

        let maxPixelSize = max(size.width, size.height)
        let options = [kCGImageSourceCreateThumbnailWithTransform: true,
                       kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                       kCGImageSourceThumbnailMaxPixelSize: maxPixelSize] as [CFString: Any] as CFDictionary

        let resizedImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options).flatMap {
            UIImage(cgImage: $0)
        }

        return resizedImage
    }

    /// CoreGraphics 方式调整图片大小 性能很好
    /// - Parameter resizeSize:图片调整Size
    /// - Returns:调整后图片
    func resizeCG(resizeSize: CGSize) -> UIImage? {
        if size == resizeSize { return self }
        guard let cgImage else { return nil }
        guard let colorSpace = cgImage.colorSpace else { return nil }
        guard let context = CGContext(data: nil,
                                      width: Int(resizeSize.width),
                                      height: Int(resizeSize.height),
                                      bitsPerComponent: cgImage.bitsPerComponent,
                                      bytesPerRow: cgImage.bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: cgImage.bitmapInfo.rawValue) else { return nil }
        context.interpolationQuality = .high
        context.draw(cgImage, in: CGRect(origin: .zero, size: resizeSize))
        let resizedImage = context.makeImage().flatMap { UIImage(cgImage: $0) }
        return resizedImage
    }

    /// 压缩图片大小
    /// - Parameters:
    ///   - maxLength:最大长度 0-1
    /// - Returns:处理好的图片
    func compressImageSize(toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1

        // 压缩尺寸
        guard var data = jpegData(compressionQuality: compression) else { return self }

        // 原图大小在要求范围内,不压缩图片
        if data.count < maxLength { return self }

        // 原图大小超过范围,先进行"压处理",这里 压缩比 采用二分法进行处理,6次二分后的最小压缩比是0.015625,已经够小了
        var max: CGFloat = 1
        var min: CGFloat = 0

        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            guard let data = jpegData(compressionQuality: compression) else { return self }

            if data.count < Int(Double(maxLength) * 0.9) {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }

        // 压缩结果符合 直接返回
        guard var resultImage = UIImage(data: data) else { return self }
        if data.count < maxLength { return resultImage }

        var lastDataLength = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count

            // 获取处理后的尺寸
            let ratio = CGFloat(maxLength) / CGFloat(data.count)
            let size = CGSize(width: resultImage.size.width * CGFloat(sqrtf(Float(ratio))),
                              height: resultImage.size.height * CGFloat(sqrtf(Float(ratio))))

            // 通过图片上下文进行处理图片
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()

            // 获取处理后图片的大小
            data = resultImage.jpegData(compressionQuality: compression)!
        }

        return resultImage
    }
}

// MARK: - 缩放
public extension UIImage {
    /// 把`UIImage`裁剪为指定`CGRect`大小
    ///
    /// - Parameter rect:目标`CGRect`
    /// - Returns:裁剪后的`UIImage`
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= size.width, rect.size.height <= size.height else { return self }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        guard let image = cgImage?.cropping(to: scaledRect) else { return self }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    /// 返回指定尺寸的图片
    /// - Parameter size:目标图片大小
    /// - Returns:缩放完成的图片
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }

    /// 指定大小的image
    /// - Parameter maxSize:图片最大尺寸(不会超过)
    /// - Returns:固定大小的 image
    func solidTo(maxSize: CGSize) -> UIImage? {
        if size.height <= size.width {
            if size.width >= maxSize.width {
                let scaleSize = CGSize(width: maxSize.width, height: maxSize.width * size.height / size.width)
                return fixOrientation().scaleTo(size: scaleSize)
            } else {
                return fixOrientation()
            }
        } else {
            if size.height >= maxSize.height {
                let scaleSize = CGSize(width: maxSize.height * size.width / size.height, height: maxSize.height)
                return fixOrientation().scaleTo(size: scaleSize)
            } else {
                return fixOrientation()
            }
        }
    }

    /// 按指定尺寸等比缩放
    /// - Parameter size:要缩放的尺寸
    /// - Returns:缩放后的图片
    func scaleTo(size: CGSize) -> UIImage? {
        if cgImage == nil { return nil }
        var w = CGFloat(cgImage!.width)
        var h = CGFloat(cgImage!.height)
        let verticalRadio = size.height / h
        let horizontalRadio = size.width / w
        var radio: CGFloat = 1
        if verticalRadio > 1, horizontalRadio > 1 {
            radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio
        } else {
            radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio
        }
        w = w * radio
        h = h * radio
        let xPos = (size.width - w) / 2
        let yPos = (size.height - h) / 2
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: xPos, y: yPos, width: w, height: h))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }

    /// 按宽高比系数:等比缩放
    /// - Parameter scale:要缩放的 宽高比 系数
    /// - Returns:等比缩放 后的图片
    func scaleTo(scale: CGFloat) -> UIImage? {
        let w = size.width
        let h = size.height
        let scaledW = w * scale
        let scaledH = h * scale
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: scaledW, height: scaledH))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 等比例把`UIImage`缩放至指定宽度
    ///
    /// - Parameters:
    ///   - newWidth:新宽度
    ///   - opaque:是否不透明
    /// - Returns:缩放后的`UIImage`(可选)
    func scaleTo(newWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 等比例把`UIImage`缩放至指定高度
    ///
    /// - Parameters:
    ///   - newHeight:新高度
    ///   - opaque:是否不透明
    /// - Returns:缩放后的`UIImage`(可选)
    func scaleTo(newHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = newHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 从图片的中心点拉伸
    /// - Returns:拉伸后的图片
    func strechAsBubble() -> UIImage {
        let edgeInsets = UIEdgeInsets(
            top: size.height * 0.5,
            left: size.width * 0.5,
            bottom: size.height * 0.5,
            right: size.width * 0.5
        )
        return resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
    }

    /// 按`edgeInsets`与`resizingMode`拉伸图片
    /// - Parameters:
    ///   - edgeInsets:拉伸区域
    ///   - resizingMode:拉伸模式
    /// - Returns:返回拉伸后的图片
    func strechBubble(edgeInsets: UIEdgeInsets,
                      resizingMode: UIImage.ResizingMode = .stretch) -> UIImage
    {
        // 拉伸
        resizableImage(withCapInsets: edgeInsets, resizingMode: resizingMode)
    }
}

// MARK: - 旋转
public extension UIImage {
    /// 调整图像方向 避免图像有旋转
    /// - Returns:返正常的图片
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -.pi / 2)
        default:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: (cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (cgImage?.colorSpace)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        let cgImage: CGImage = ctx.makeImage()!
        return UIImage(cgImage: cgImage)
    }

    /// 创建按给定角度旋转的图片
    ///
    ///     // 将图像旋转180°
    ///     image.rotated(by:Measurement(value:180, unit:.degrees))
    ///
    /// - Parameter angle:旋转(按:测量值(值:180,单位:度))
    /// - Returns:按给定角度旋转的新图像
    @available(tvOS 10.0, watchOS 3.0, *)
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)

        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        draw(in: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2),
                        size: size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 创建按给定角度(弧度)旋转的图片
    ///
    ///     // 将图像旋转180°
    ///     image.rotated(by:.pi)
    ///
    /// - Parameter radians:旋转图像的角度(以弧度为单位)
    /// - Returns:按给定角度旋转的新图像
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        draw(in: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2),
                        size: size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: - 圆角
public extension UIImage {
    /// 带圆角的`UIImage`
    ///
    /// - Parameters:
    ///   - radius:角半径(可选),如果未指定,结果图像将为圆形
    /// - Returns:带圆角的`UIImage`
    func roundCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius, radius > 0, radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 设置图片的圆角
    /// - Parameters:
    ///   - size:图片的大小
    ///   - radius:圆角大小 (默认:3.0,图片大小)
    ///   - corners:切圆角的方式
    /// - Returns:剪切后的图片
    func roundCorners(size: CGSize?,
                      radius: CGFloat,
                      corners: UIRectCorner = .allCorners) -> UIImage?
    {
        let weakSize = size ?? self.size
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: weakSize)
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(weakSize, false, UIScreen.main.scale)
        guard let contentRef: CGContext = UIGraphicsGetCurrentContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 绘制路线
        contentRef.addPath(UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        // 裁剪
        contentRef.clip()
        // 将原图片画到图形上下文
        draw(in: rect)
        contentRef.drawPath(using: .fillStroke)
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 关闭上下文
        UIGraphicsEndImageContext()
        return output
    }

    /// 设置图片圆角(带边框)
    /// - Parameters:
    ///   - size:最终生成的图片尺寸
    ///   - radius:圆角半径
    ///   - corners:圆角方向
    ///   - borderWidth:边框线宽
    ///   - borderColor:边框颜色
    ///   - backgroundColor:背景颜色
    /// - Returns:最终图片
    func roundCorners(size: CGSize,
                      radius: CGFloat,
                      corners: UIRectCorner = .allCorners,
                      borderWidth: CGFloat = 0,
                      borderColor: UIColor? = nil,
                      backgroundColor: UIColor? = nil,
                      completion: ((UIImage?) -> Void)? = nil) -> UIImage
    {
        // 图形上下文设置
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        // 获取当前图形上下文
        let context = UIGraphicsGetCurrentContext()!

        // 填充背景色
        if let backgroundColor {
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }

        // 绘制区域的大小
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        // 路径
        var path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        if rect.size.width == rect.size.height, radius == rect.size.width / 2 {
            path = UIBezierPath(ovalIn: rect)
        }
        // 添加裁剪
        path.addClip()

        // 绘制图片到上下文
        draw(in: rect)

        // 设置边框
        if let borderColor, borderWidth > 0 {
            path.lineWidth = borderWidth * 2
            borderColor.setStroke()
            path.stroke()
        }

        // 从上下文获取图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()

        // 回调
        DispatchQueue.async_execute_on_main {
            completion?(resultImage)
        }
        return resultImage!
    }

    /// 设置圆形图片
    /// - Returns:圆形图片
    func roundImage() -> UIImage? {
        roundCorners(size: size,
                     radius: (size.width < size.height ? size.width : size.height) / 2.0,
                     corners: .allCorners)
    }
}

// MARK: - 颜色
public extension UIImage {
    /// 图像的平均颜色
    func averageColor() -> UIColor? {
        guard let ciImage = ciImage ?? CIImage(image: self) else { return nil }

        // CIAreaAverage返回包含给定图像区域平均颜色的单像素图像
        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }

        // 从过滤器中获取单像素图像后,提取像素的RGBA8数据
        var bitmap = [UInt8](repeating: 0, count: 4)
        let workingColorSpace: Any = cgImage?.colorSpace ?? NSNull()
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // 将像素数据转换为UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255.0,
                       green: CGFloat(bitmap[1]) / 255.0,
                       blue: CGFloat(bitmap[2]) / 255.0,
                       alpha: CGFloat(bitmap[3]) / 255.0)
    }

    /// 获取图片某一个位置像素的颜色
    /// - Parameter point:图片上某个点
    /// - Returns:返回某个点的 UIColor
    func pixelColor(_ point: CGPoint) -> UIColor? {
        if point.x < 0 || point.x > size.width || point.y < 0 || point.y > size.height {
            return nil
        }

        let provider = cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)

        let numberOfComponents: CGFloat = 4.0
        let pixelData = (size.width * point.y + point.x) * numberOfComponents

        let r = CGFloat(data![Int(pixelData)]) / 255.0
        let g = CGFloat(data![Int(pixelData) + 1]) / 255.0
        let b = CGFloat(data![Int(pixelData) + 2]) / 255.0
        let a = CGFloat(data![Int(pixelData) + 3]) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    /// 异步获取指定CGPoint位置颜色
    func pixelColor(at point: CGPoint, completion: @escaping (UIColor?) -> Void) {
        let size = size
        let cgImage = cgImage

        DispatchQueue.global(qos: .userInteractive).async {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let imgRef = cgImage,
                  let dataProvider = imgRef.dataProvider,
                  let dataCopy = dataProvider.data,
                  let data = CFDataGetBytePtr(dataCopy), rect.contains(point)
            else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            let pixelInfo = (Int(size.width) * Int(point.y) + Int(point.x)) * 4
            let red = CGFloat(data[pixelInfo]) / 255.0
            let green = CGFloat(data[pixelInfo + 1]) / 255.0
            let blue = CGFloat(data[pixelInfo + 2]) / 255.0
            let alpha = CGFloat(data[pixelInfo + 3]) / 255.0

            DispatchQueue.main.async {
                completion(UIColor(red: red, green: green, blue: blue, alpha: alpha))
            }
        }
    }

    /// 获取图片主题颜色
    func themeColor(_ completion: @escaping (_ color: UIColor?) -> Void) {
        DispatchQueue.global().async {
            if self.cgImage == nil { DispatchQueue.main.async { completion(nil) }}
            let bitmapInfo = CGBitmapInfo(rawValue: 0).rawValue | CGImageAlphaInfo.premultipliedLast.rawValue

            // 第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
            let thumbSize = CGSize(width: 40, height: 40)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let context = CGContext(data: nil,
                                          width: Int(thumbSize.width),
                                          height: Int(thumbSize.height),
                                          bitsPerComponent: 8,
                                          bytesPerRow: Int(thumbSize.width) * 4,
                                          space: colorSpace,
                                          bitmapInfo: bitmapInfo) else { return completion(nil) }

            let drawRect = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
            context.draw(self.cgImage!, in: drawRect)

            // 第二步 取每个点的像素值
            if context.data == nil { return completion(nil) }
            let countedSet = NSCountedSet(capacity: Int(thumbSize.width * thumbSize.height))
            for x in 0 ..< Int(thumbSize.width) {
                for y in 0 ..< Int(thumbSize.height) {
                    let offset = 4 * x * y
                    let red = context.data!.load(fromByteOffset: offset, as: UInt8.self)
                    let green = context.data!.load(fromByteOffset: offset + 1, as: UInt8.self)
                    let blue = context.data!.load(fromByteOffset: offset + 2, as: UInt8.self)
                    let alpha = context.data!.load(fromByteOffset: offset + 3, as: UInt8.self)
                    // 过滤透明的、基本白色、基本黑色
                    if alpha > 0, red < 250, green < 250, blue < 250, red > 5, green > 5, blue > 5 {
                        let array = [red, green, blue, alpha]
                        countedSet.add(array)
                    }
                }
            }

            // 第三步 找到出现次数最多的那个颜色
            let enumerator = countedSet.objectEnumerator()
            var maxColor: [Int] = []
            var maxCount = 0
            while let curColor = enumerator.nextObject() as? [Int], !curColor.isEmpty {
                let tmpCount = countedSet.count(for: curColor)
                if tmpCount < maxCount { continue }
                maxCount = tmpCount
                maxColor = curColor
            }
            let color = UIColor(red: CGFloat(maxColor[0]) / 255.0, green: CGFloat(maxColor[1]) / 255.0, blue: CGFloat(maxColor[2]) / 255.0, alpha: CGFloat(maxColor[3]) / 255.0)
            DispatchQueue.main.async { completion(color) }
        }
    }

    /// 获取图片背景/主要/次要/细节 颜色
    /// - Parameter scaleDownSize:指定图片大小
    /// - Returns:背景/主要/次要/细节 颜色
    func colors(scaleDownSize: CGSize? = nil) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
        let cgImage: CGImage

        if let scaleDownSize {
            cgImage = resize(to: scaleDownSize).cgImage!
        } else {
            let ratio = size.width / size.height
            let r_width: CGFloat = 250
            cgImage = resize(to: CGSize(width: r_width, height: r_width / ratio)).cgImage!
        }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8
        let randomColorsThreshold = Int(CGFloat(height) * 0.01)
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let raw = malloc(bytesPerRow * height)
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        let context = CGContext(data: raw, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let data = UnsafePointer<UInt8>(context?.data?.assumingMemoryBound(to: UInt8.self))
        let imageBackgroundColors = NSCountedSet(capacity: height)
        let imageColors = NSCountedSet(capacity: width * height)

        let sortComparator: (CountedColor, CountedColor) -> Bool = { a, b -> Bool in
            a.count <= b.count
        }

        for x in 0 ..< width {
            for y in 0 ..< height {
                let pixel = ((width * y) + x) * bytesPerPixel
                let color = UIColor(
                    /*
                     red:CGFloat(data?[pixel + 1]!) / 255,
                     green:CGFloat(data?[pixel + 2]!) / 255,
                     blue:CGFloat(data?[pixel + 3]!) / 255,
                     */
                    red: CGFloat(data?[pixel + 1] ?? 0) / 255,
                    green: CGFloat(data?[pixel + 2] ?? 0) / 255,
                    blue: CGFloat(data?[pixel + 3] ?? 0) / 255,
                    alpha: 1
                )

                if x >= 5, x <= 10 {
                    imageBackgroundColors.add(color)
                }

                imageColors.add(color)
            }
        }

        var sortedColors = [CountedColor]()

        for color in imageBackgroundColors {
            guard let color = color as? UIColor else { continue }

            let colorCount = imageBackgroundColors.count(for: color)

            if randomColorsThreshold <= colorCount {
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }

        sortedColors.sort(by: sortComparator)

        var proposedEdgeColor = CountedColor(color: blackColor, count: 1)

        if let first = sortedColors.first { proposedEdgeColor = first }

        if proposedEdgeColor.color.isBlackOrWhite, !sortedColors.isEmpty {
            for countedColor in sortedColors where CGFloat(countedColor.count / proposedEdgeColor.count) > 0.3 {
                if !countedColor.color.isBlackOrWhite {
                    proposedEdgeColor = countedColor
                    break
                }
            }
        }

        let imageBackgroundColor = proposedEdgeColor.color
        let isDarkBackgound = imageBackgroundColor.isDark

        sortedColors.removeAll()

        for imageColor in imageColors {
            guard let imageColor = imageColor as? UIColor else { continue }

            let color = imageColor.color(minSaturation: 0.15)

            if color.isDark == !isDarkBackgound {
                let colorCount = imageColors.count(for: color)
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }

        sortedColors.sort(by: sortComparator)

        var primaryColor, secondaryColor, detailColor: UIColor?

        for countedColor in sortedColors {
            let color = countedColor.color

            if primaryColor == nil,
               color.isContrasting(with: imageBackgroundColor)
            {
                primaryColor = color
            } else if secondaryColor == nil,
                      primaryColor != nil,
                      primaryColor!.isDistinct(from: color),
                      color.isContrasting(with: imageBackgroundColor)
            {
                secondaryColor = color
            } else if secondaryColor != nil,
                      secondaryColor!.isDistinct(from: color),
                      primaryColor!.isDistinct(from: color),
                      color.isContrasting(with: imageBackgroundColor)
            {
                detailColor = color
                break
            }
        }

        free(raw)

        return (
            imageBackgroundColor,
            primaryColor ?? (isDarkBackgound ? whiteColor : blackColor),
            secondaryColor ?? (isDarkBackgound ? whiteColor : blackColor),
            detailColor ?? (isDarkBackgound ? whiteColor : blackColor)
        )
    }

    /// `UIImage`填充颜色
    ///
    /// - Parameter color:填充图像的颜色
    /// - Returns:用给定颜色填充的`UIImage`
    func filled(with color: UIColor) -> UIImage {
        #if !os(watchOS)
            if #available(tvOS 10.0, *) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = scale
                let renderer = UIGraphicsImageRenderer(size: size, format: format)
                return renderer.image { context in
                    color.setFill()
                    context.fill(CGRect(origin: .zero, size: size))
                }
            }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /// 指定颜色为`UIImage`着色
    ///
    /// - Parameters:
    ///   - color:为图像着色的颜色
    ///   - blendMode:混合模式
    ///   - alpha:用于绘制的`alpha`值
    /// - Returns:使用给定颜色着色的`UIImage`
    func tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> UIImage {
        let drawRect = CGRect(origin: .zero, size: size)

        #if !os(watchOS)
            if #available(tvOS 10.0, *) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = scale
                return UIGraphicsImageRenderer(size: size, format: format).image { context in
                    color.setFill()
                    context.fill(drawRect)
                    draw(in: drawRect, blendMode: blendMode, alpha: alpha)
                }
            }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// 带背景色的`UImage`
    ///
    /// - Parameters:
    ///   - backgroundColor:用作背景色的颜色
    /// - Returns:带背景色的`UImage`
    func withBackgroundColor(_ backgroundColor: UIColor) -> UIImage {
        #if !os(watchOS)
            if #available(tvOS 10.0, *) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = scale
                return UIGraphicsImageRenderer(size: size, format: format).image { context in
                    backgroundColor.setFill()
                    context.fill(context.format.bounds)
                    draw(at: .zero)
                }
            }
        #endif

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }

        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        draw(at: .zero)

        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

// MARK: - 方法
public extension UIImage {}
