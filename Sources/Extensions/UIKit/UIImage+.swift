
import AVFoundation
import CoreImage
import Dispatch
import Photos
import UIKit

private class AssociateKeys {
    static let SaveBlockKey = UnsafeRawPointer(bitPattern: "saveBlock".hashValue)
}

public extension UIImage {
    var pd_size_bytes: Int {
        jpegData(compressionQuality: 1)?.count ?? 0
    }

    var pd_size_kb: Int {
        (jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }

    var pd_original: UIImage {
        withRenderingMode(.alwaysOriginal)
    }

    var pd_template: UIImage {
        withRenderingMode(.alwaysTemplate)
    }
}

public extension UIImage {

    convenience init(with color: UIColor, size: CGSize = 1.pd_cgSize()) {
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

    convenience init?(imageUrl: URL, scale: CGFloat = 1.0) throws {
        let data = try Data(contentsOf: imageUrl)
        self.init(data: data, scale: scale)
    }

    convenience init(lightImageName: String, darkImageName: String? = nil) {
        self.init(lightImage: lightImageName.pd_image(),
                  darkImage: (darkImageName ?? lightImageName).pd_image())
    }

    convenience init(lightImage: UIImage?, darkImage: UIImage?) {
        if #available(iOS 13.0, *) {
            guard var lightImage else { self.init(); return }
            guard let darkImage else { self.init(); return }
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

public extension UIImage {
    static func pd_darkModeImage(_ lightImageName: String, darkImageName: String? = nil) -> UIImage? {
        pd_darkModeImage(UIImage(named: lightImageName), darkImage: UIImage(named: darkImageName ?? lightImageName))
    }

    static func pd_darkModeImage(_ lightImage: UIImage?, darkImage: UIImage?) -> UIImage? {
        if #available(iOS 13.0, *) {
            guard var lightImage else { return lightImage }
            guard let darkImage else { return lightImage }
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


public extension UIImage {

    func pd_pngBase64String() -> String? {
        pngData()?.base64EncodedString()
    }

    func pd_jpegBase64String(compressionQuality: CGFloat) -> String? {
        jpegData(compressionQuality: compressionQuality)?.base64EncodedString()
    }
}

public extension UIImage {

    enum CompressionMode {

        static let resolutionRule: (min: CGFloat, max: CGFloat, low: CGFloat, default: CGFloat, high: CGFloat) =
            (10, 4096, 512, 1024, 2048)
        static let dataSizeRule: (min: Int, max: Int, low: Int, default: Int, high: Int) =
            (1024 * 10, 1024 * 1024 * 20, 1024 * 512, 1024 * 1024 * 2, 1024 * 1024 * 10)

        case low
        case medium
        case high
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

    func pd_compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }

    func pd_compressedData(quality: CGFloat = 0.5) -> Data? {
        jpegData(compressionQuality: quality)
    }

    func pd_compress(mode: CompressionMode = .medium) -> Data? {
        pd_resizeIO(resizeSize: mode.resize(size))?.pd_compressDataSize(maxSize: mode.maxDataSize)
    }

    func pd_asyncCompress(mode: CompressionMode = .medium, queue: DispatchQueue = DispatchQueue.global(), complete: @escaping (Data?, CGSize) -> Void) {
        queue.async {
            let data = self.pd_resizeIO(resizeSize: mode.resize(self.size))?.pd_compressDataSize(maxSize: mode.maxDataSize)
            DispatchQueue.main.async { complete(data, mode.resize(self.size)) }
        }
    }

    func pd_compressDataSize(maxSize: Int = 1024 * 1024 * 2) -> Data? {
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

    func pd_resizeIO(resizeSize: CGSize) -> UIImage? {
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

    func pd_resizeCG(resizeSize: CGSize) -> UIImage? {
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

    func pd_compressImageSize(toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1

        guard var data = jpegData(compressionQuality: compression) else { return self }
        if data.count < maxLength { return self }
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

        guard var resultImage = UIImage(data: data) else { return self }
        if data.count < maxLength { return resultImage }

        var lastDataLength = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count

            let ratio = CGFloat(maxLength) / CGFloat(data.count)
            let size = CGSize(width: resultImage.size.width * CGFloat(sqrtf(Float(ratio))),
                              height: resultImage.size.height * CGFloat(sqrtf(Float(ratio))))

            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()

            data = resultImage.jpegData(compressionQuality: compression)!
        }

        return resultImage
    }
}

public extension UIImage {

    func pd_cropWithCropRect(_ crop: CGRect) -> UIImage? {
        let cropRect = CGRect(x: crop.origin.x * scale,
                              y: crop.origin.y * scale,
                              width: crop.size.width * scale,
                              height: crop.size.height * scale)
        if cropRect.size.width <= 0 || cropRect.size.height <= 0 { return nil }
        var image: UIImage?
        autoreleasepool {
            let imageRef: CGImage? = self.cgImage!.cropping(to: cropRect)
            if let imageRef { image = UIImage(cgImage: imageRef) }
        }
        return image
    }

    func pd_cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= size.width, rect.size.height <= size.height else { return self }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        guard let image = cgImage?.cropping(to: scaledRect) else { return self }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    func pd_resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }

    func pd_solidTo(maxSize: CGSize) -> UIImage? {
        if size.height <= size.width {
            if size.width >= maxSize.width {
                let scaleSize = CGSize(width: maxSize.width, height: maxSize.width * size.height / size.width)
                return pd_fixOrientation().pd_scaleTo(size: scaleSize)
            } else {
                return pd_fixOrientation()
            }
        } else {
            if size.height >= maxSize.height {
                let scaleSize = CGSize(width: maxSize.height * size.width / size.height, height: maxSize.height)
                return pd_fixOrientation().pd_scaleTo(size: scaleSize)
            } else {
                return pd_fixOrientation()
            }
        }
    }

    func pd_scaleTo(size: CGSize) -> UIImage? {
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

    func pd_scaleTo(scale: CGFloat) -> UIImage? {
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

    func pd_scaleTo(newWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func pd_scaleTo(newHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = newHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), opaque, self.scale)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func pd_strechAsBubble() -> UIImage {
        let edgeInsets = UIEdgeInsets(
            top: size.height * 0.5,
            left: size.width * 0.5,
            bottom: size.height * 0.5,
            right: size.width * 0.5
        )
        return resizableImage(withCapInsets: edgeInsets, resizingMode: .stretch)
    }

    func pd_strechBubble(edgeInsets: UIEdgeInsets,
                         resizingMode: UIImage.ResizingMode = .stretch) -> UIImage
    {
        resizableImage(withCapInsets: edgeInsets, resizingMode: resizingMode)
    }
}

public extension UIImage {

    func pd_fixOrientation() -> UIImage {
        if imageOrientation == .up { return self }

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
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }

        let ctx = CGContext(data: nil,
                            width: Int(size.width),
                            height: Int(size.height),
                            bitsPerComponent: (cgImage?.bitsPerComponent)!,
                            bytesPerRow: 0,
                            space: (cgImage?.colorSpace)!,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
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

    func pd_rotatedTo(degree: CGFloat) -> UIImage? {
        let radians = Double(degree) / 180 * Double.pi
        return pd_rotatedTo(radians: CGFloat(radians))
    }

    func pd_rotatedTo(radians: CGFloat) -> UIImage? {
        guard let weakCGImage = cgImage else { return nil }
        let rotateViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let transform = CGAffineTransform(rotationAngle: radians)
        rotateViewBox.transform = transform
        UIGraphicsBeginImageContext(rotateViewBox.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.translateBy(x: rotateViewBox.frame.width / 2, y: rotateViewBox.frame.height / 2)
        context.rotate(by: radians)
        context.scaleBy(x: 1, y: -1)
        let rect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
        context.draw(weakCGImage, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    @available(tvOS 10.0, watchOS 3.0, *)
    func pd_rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
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

    func pd_rotated(by radians: CGFloat) -> UIImage? {
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

    func pd_flipHorizontal() -> UIImage? {
        pd_rotate(orientation: .upMirrored)
    }

    func pd_flipVertical() -> UIImage? {
        pd_rotate(orientation: .downMirrored)
    }

    func pd_flipDown() -> UIImage? {
        pd_rotate(orientation: .down)
    }

    func pd_flipLeft() -> UIImage? {
        pd_rotate(orientation: .left)
    }

    func pd_flipLeftMirrored() -> UIImage? {
        pd_rotate(orientation: .leftMirrored)
    }

    func pd_flipRight() -> UIImage? {
        pd_rotate(orientation: .right)
    }

    func pd_flipRightMirrored() -> UIImage? {
        pd_rotate(orientation: .rightMirrored)
    }

    private func pd_rotate(orientation: UIImage.Orientation) -> UIImage? {
        guard let imageRef = cgImage else { return nil }

        let rect = CGRect(x: 0, y: 0, width: imageRef.width, height: imageRef.height)
        var bounds = rect
        var transform = CGAffineTransform.identity

        switch orientation {
        case .up:
            return self
        case .upMirrored:
            transform = CGAffineTransform(translationX: rect.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .down:
            transform = CGAffineTransform(translationX: rect.size.width, y: rect.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0, y: rect.size.height)
            transform = transform.scaledBy(x: 1, y: -1)
        case .left:
            pd_swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: 0, y: rect.size.width)
            transform = transform.rotated(by: CGFloat(Double.pi * 1.5))
        case .leftMirrored:
            pd_swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: rect.size.height, y: rect.size.width)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat(Double.pi * 1.5))
        case .right:
            pd_swapWidthAndHeight(rect: &bounds)
            transform = CGAffineTransform(translationX: rect.size.height, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case .rightMirrored:
            pd_swapWidthAndHeight(rect: &bounds)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        default:
            return nil
        }

        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        switch orientation {
        case .left:
            fallthrough
        case .leftMirrored:
            fallthrough
        case .right:
            fallthrough
        case .rightMirrored:
            context.scaleBy(x: -1.0, y: 1.0)
            context.translateBy(x: -bounds.size.width, y: 0.0)
        default:
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0.0, y: -rect.size.height)
        }
        context.concatenate(transform)
        context.draw(imageRef, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    private func pd_swapWidthAndHeight(rect: inout CGRect) {
        let swap = rect.size.width
        rect.size.width = rect.size.height
        rect.size.height = swap
    }
}

public extension UIImage {

    func pd_roundCorners(radius: CGFloat? = nil) -> UIImage? {
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

    func pd_roundCorners(size: CGSize?,
                         radius: CGFloat,
                         corners: UIRectCorner = .allCorners) -> UIImage?
    {
        let weakSize = size ?? self.size
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: weakSize)
        UIGraphicsBeginImageContextWithOptions(weakSize, false, UIScreen.main.scale)
        guard let contentRef: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        contentRef.addPath(UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        contentRef.clip()
        draw(in: rect)
        contentRef.drawPath(using: .fillStroke)
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return output
    }

    func pd_roundCorners(size: CGSize,
                         radius: CGFloat,
                         corners: UIRectCorner = .allCorners,
                         borderWidth: CGFloat,
                         borderColor: UIColor?,
                         backgroundColor: UIColor? = nil,
                         completion: ((UIImage?) -> Void)? = nil) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        let context = UIGraphicsGetCurrentContext()!

        if let backgroundColor {
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        var path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        if rect.size.width == rect.size.height, radius == rect.size.width / 2 {
            path = UIBezierPath(ovalIn: rect)
        }
        path.addClip()
        draw(in: rect)

        if let borderColor, borderWidth > 0 {
            path.lineWidth = borderWidth * 2
            borderColor.setStroke()
            path.stroke()
        }

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()

        DispatchQueue.pd_async_execute_on_main {
            completion?(resultImage)
        }
        return resultImage!
    }

    func pd_roundImage() -> UIImage? {
        pd_roundCorners(size: size,
                        radius: (size.width < size.height ? size.width : size.height) / 2.0,
                        corners: .allCorners)
    }

    static func pd_createImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        pd_createImage(with: color, size: size, corners: .allCorners, radius: 0)
    }

    static func pd_createImage(with color: UIColor,
                               size: CGSize,
                               corners: UIRectCorner,
                               radius: CGFloat) -> UIImage?
    {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if radius > 0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            color.setFill()
            path.fill()
        } else {
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

public extension UIImage {
    class CountedColor {
        let color: UIColor
        let count: Int

        init(color: UIColor, count: Int) {
            self.color = color
            self.count = count
        }
    }

    func pd_colors(scaleDownSize: CGSize? = nil) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
        let cgImage: CGImage

        if let scaleDownSize {
            cgImage = pd_resize(to: scaleDownSize).cgImage!
        } else {
            let ratio = size.width / size.height
            let r_width: CGFloat = 250
            cgImage = pd_resize(to: CGSize(width: r_width, height: r_width / ratio)).cgImage!
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

            let color = imageColor.pd_color(minSaturation: 0.15)

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
               color.pd_isContrasting(with: imageBackgroundColor)
            {
                primaryColor = color
            } else if secondaryColor == nil,
                      primaryColor != nil,
                      primaryColor!.pd_isDistinct(from: color),
                      color.pd_isContrasting(with: imageBackgroundColor)
            {
                secondaryColor = color
            } else if secondaryColor != nil,
                      secondaryColor!.pd_isDistinct(from: color),
                      primaryColor!.pd_isDistinct(from: color),
                      color.pd_isContrasting(with: imageBackgroundColor)
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

    func pd_themeColor(_ completion: @escaping (_ color: UIColor?) -> Void) {
        DispatchQueue.global().async {
            if self.cgImage == nil { DispatchQueue.main.async { completion(nil) }}
            let bitmapInfo = CGBitmapInfo(rawValue: 0).rawValue | CGImageAlphaInfo.premultipliedLast.rawValue

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

            if context.data == nil { return completion(nil) }
            let countedSet = NSCountedSet(capacity: Int(thumbSize.width * thumbSize.height))
            for x in 0 ..< Int(thumbSize.width) {
                for y in 0 ..< Int(thumbSize.height) {
                    let offset = 4 * x * y
                    let red = context.data!.load(fromByteOffset: offset, as: UInt8.self)
                    let green = context.data!.load(fromByteOffset: offset + 1, as: UInt8.self)
                    let blue = context.data!.load(fromByteOffset: offset + 2, as: UInt8.self)
                    let alpha = context.data!.load(fromByteOffset: offset + 3, as: UInt8.self)
                    if alpha > 0, red < 250, green < 250, blue < 250, red > 5, green > 5, blue > 5 {
                        let array = [red, green, blue, alpha]
                        countedSet.add(array)
                    }
                }
            }

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

    func pd_averageColor() -> UIColor? {
        guard let ciImage = ciImage ?? CIImage(image: self) else { return nil }

        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let workingColorSpace: Any = cgImage?.colorSpace ?? NSNull()
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255.0,
                       green: CGFloat(bitmap[1]) / 255.0,
                       blue: CGFloat(bitmap[2]) / 255.0,
                       alpha: CGFloat(bitmap[3]) / 255.0)
    }

    func pd_pixelColor(_ point: CGPoint) -> UIColor? {
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

    func pd_pixelColor(at point: CGPoint, completion: @escaping (UIColor?) -> Void) {
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

    func pd_imageAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -area.height)
        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        context?.draw(cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }

    func pd_filled(with color: UIColor) -> UIImage {
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

    func pd_setBackgroundColor(_ backgroundColor: UIColor) -> UIImage {
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

    func pd_tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> UIImage {
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

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func pd_tintColor(with color: UIColor, renderingMode: RenderingMode = .alwaysOriginal) -> UIImage {
        withTintColor(color, renderingMode: renderingMode)
    }
}

public extension UIImage {

    func pd_imageByRemoveWhite() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return pd_transparentColor(colorMasking: colorMasking)
    }

    func pd_imageByRemoveBlack() -> UIImage? {
        let colorMasking: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return pd_transparentColor(colorMasking: colorMasking)
    }

    func pd_transparentColor(colorMasking: [CGFloat]) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        guard let rawImageRef = cgImage else { return nil }
        guard let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) else { return nil }
        UIGraphicsBeginImageContext(size)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: 0.0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

public extension UIImage {

    func pd_blurImage(fuzzyValue: CGFloat = 20) -> UIImage? {
        pd_blurredPicture(fuzzyValue: fuzzyValue, filterName: "CIGaussianBlur")
    }

    func pd_pixelImage(fuzzyValue: CGFloat = 20) -> UIImage? {
        pd_blurredPicture(fuzzyValue: fuzzyValue, filterName: "CIPixellate")
    }

    private func pd_blurredPicture(fuzzyValue: CGFloat, filterName: String) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        guard let blurFilter = CIFilter(name: filterName) else { return nil }
        blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter.setValue(fuzzyValue, forKey: filterName == "CIPixellate" ? kCIInputScaleKey : kCIInputRadiusKey)
        guard let outputImage = blurFilter.outputImage else { return nil }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

public extension UIImage {
    enum FilterName: String {
        case CISepiaTone
        case CIPhotoEffectNoir
    }

    func pd_useFilter(_ filterName: FilterName, alpha: CGFloat?) -> UIImage? {
        guard let imageData = pngData() else { return nil }
        let inputImage = CoreImage.CIImage(data: imageData)
        let context = CIContext(options: nil)

        guard let filter = CIFilter(name: filterName.rawValue) else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if alpha != nil { filter.setValue(alpha, forKey: "inputIntensity") }

        guard let outputImage = filter.outputImage else { return nil }
        guard let outImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }

        return UIImage(cgImage: outImage)
    }

    func pd_pixAll(value: Int? = nil) -> UIImage? {
        guard let filter = CIFilter(name: "CIPixellate") else { return nil }
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if value != nil { filter.setValue(value, forKey: kCIInputScaleKey) }
        let fullPixellatedImage = filter.outputImage
        let cgImage = context.createCGImage(fullPixellatedImage!, from: fullPixellatedImage!.extent)
        return UIImage(cgImage: cgImage!)
    }

    func pd_detectFace() -> [CGRect]? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let context = CIContext(options: nil)

        let detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: context,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        var faceFeatures: [CIFaceFeature]!
        if let orientation = inputImage.properties[kCGImagePropertyOrientation as String] {
            faceFeatures = (detector!.features(in: inputImage, options: [CIDetectorImageOrientation: orientation]) as! [CIFaceFeature])
        } else {
            faceFeatures = (detector!.features(in: inputImage) as! [CIFaceFeature])
        }

        let inputImageSize = inputImage.extent.size
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -inputImageSize.height)

        var rects: [CGRect] = []
        for faceFeature in faceFeatures {
            let faceViewBounds = faceFeature.bounds.applying(transform)
            rects.append(faceViewBounds)
        }
        return rects
    }

    func pd_detectAndPixFace() -> UIImage? {
        guard let inputImage = CIImage(image: self) else {
            return nil
        }
        let context = CIContext(options: nil)

        let filter = CIFilter(name: "CIPixellate")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let inputScale = max(inputImage.extent.size.width, inputImage.extent.size.height) / 80
        filter.setValue(inputScale, forKey: kCIInputScaleKey)
        let fullPixellatedImage = filter.outputImage
        guard let detector = CIDetector(ofType: CIDetectorTypeFace,
                                        context: context,
                                        options: nil)
        else {
            return nil
        }
        let faceFeatures = detector.features(in: inputImage)
        var maskImage: CIImage!
        for faceFeature in faceFeatures {

            let centerX = faceFeature.bounds.origin.x + faceFeature.bounds.size.width / 2
            let centerY = faceFeature.bounds.origin.y + faceFeature.bounds.size.height / 2
            let radius = min(faceFeature.bounds.size.width, faceFeature.bounds.size.height)
            guard let radialGradient = CIFilter(name: "CIRadialGradient",
                                                parameters: [
                                                    "inputRadius0": radius,
                                                    "inputRadius1": radius + 1,
                                                    "inputColor0": CIColor(red: 0, green: 1, blue: 0, alpha: 1),
                                                    "inputColor1": CIColor(red: 0, green: 0, blue: 0, alpha: 0),
                                                    kCIInputCenterKey: CIVector(x: centerX, y: centerY),
                                                ])
            else {
                return nil
            }

            let radialGradientOutputImage = radialGradient.outputImage!.cropped(to: inputImage.extent)
            if maskImage == nil {
                maskImage = radialGradientOutputImage
            } else {
                maskImage = CIFilter(name: "CISourceOverCompositing",
                                     parameters: [
                                         kCIInputImageKey: radialGradientOutputImage,
                                         kCIInputBackgroundImageKey: maskImage as Any,
                                     ])!.outputImage
            }
        }
      
        let blendFilter = CIFilter(name: "CIBlendWithMask")!
        blendFilter.setValue(fullPixellatedImage, forKey: kCIInputImageKey)
        blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)

        guard let blendOutputImage = blendFilter.outputImage, let blendCGImage = context.createCGImage(blendOutputImage, from: blendOutputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: blendCGImage)
    }
}


public extension UIImage {
    enum GradientDirection {
        case horizontal
        case vertical
        case leftOblique
        case rightOblique
        case other(CGPoint, CGPoint)

        public func point(size: CGSize) -> (CGPoint, CGPoint) {
            switch self {
            case .horizontal:
                return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: 0))
            case .vertical:
                return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height))
            case .leftOblique:
                return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: size.height))
            case .rightOblique:
                return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
            case let .other(stat, end):
                return (stat, end)
            }
        }
    }

    static func pd_createGradient(_ hexsString: [String],
                                  size: CGSize = CGSize(width: 1, height: 1),
                                  locations: [CGFloat]? = [0, 1],
                                  direction: GradientDirection = .horizontal) -> UIImage?
    {
        pd_createGradient(hexsString.map { UIColor(hex: $0) }, size: size, locations: locations, direction: direction)
    }


    static func pd_createGradient(_ colors: [UIColor],
                                  size: CGSize = CGSize(width: 10, height: 10),
                                  locations: [CGFloat]? = [0, 1],
                                  direction: GradientDirection = .horizontal) -> UIImage?
    {
        pd_createGradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }


    static func pd_createGradient(_ colors: [UIColor],
                                  size: CGSize = CGSize(width: 10, height: 10),
                                  radius: CGFloat,
                                  locations: [CGFloat]? = [0, 1],
                                  direction: GradientDirection = .horizontal) -> UIImage?
    {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return pd_createImage(color: colors[0])
        }
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map(\.cgColor) as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let directionPoint = direction.point(size: size)
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


public extension UIImage {

    static func pd_loadImage(with image: String) -> UIImage? {
        if image.hasPrefix("http://") || image.hasPrefix("https://") {
            let imageUrl = URL(string: image)
            var imageData: Data?
            do {
                imageData = try Data(contentsOf: imageUrl!)
                return UIImage(data: imageData!)!
            } catch {
                return nil
            }
        } else if image.contains("/") {
            return UIImage(contentsOfFile: image)
        }
        return UIImage(named: image)!
    }

    static func pd_loadImageWithGif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        return pd_animatedImageWithSource(source)
    }

    static func pd_loadImageWithGif(url: String) -> UIImage? {
        guard let bundleURL = URL(string: url) else { return nil }
        guard let imageData = try? Data(contentsOf: bundleURL) else { return nil }
        return pd_loadImageWithGif(data: imageData)
    }

    static func pd_loadImageWithGif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif")
        else {
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else { return nil }

        return pd_loadImageWithGif(data: imageData)
    }

    @available(iOS 9.0, *)
    static func pd_loadImageWithGif(asset: String) -> UIImage? {
        guard let dataAsset = NSDataAsset(name: asset) else { return nil }
        return pd_loadImageWithGif(data: dataAsset.data)
    }

    static func pd_frameInfoWithGif(asset: String) -> (images: [UIImage]?, duration: TimeInterval?) {
        guard let dataAsset = NSDataAsset(name: asset) else { return (nil, nil) }
        guard let source = CGImageSourceCreateWithData(dataAsset.data as CFData, nil) else {
            return (nil, nil)
        }
        return pd_animatedImageSources(source)
    }

    static func pd_frameInfoWithGif(name: String) -> (images: [UIImage]?, duration: TimeInterval?) {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif")
        else {
            return (nil, nil)
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return (nil, nil)
        }
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return (nil, nil)
        }
        return pd_animatedImageSources(source)
    }

    static func pd_frameInfoWithGif(url: String) -> (images: [UIImage]?, duration: TimeInterval?) {
        guard let bundleURL = URL(string: url) else { return (nil, nil) }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return (nil, nil)
        }
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return (nil, nil)
        }
        return pd_animatedImageSources(source)
    }

    private static func pd_animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let info = pd_animatedImageSources(source)
        guard let frames = info.images, let duration = info.duration else { return nil }
        let animation = UIImage.animatedImage(with: frames, duration: duration)
        return animation
    }

    private static func pd_animatedImageSources(_ source: CGImageSource) -> (images: [UIImage]?, duration: TimeInterval?) {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        for index in 0 ..< count {
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            let delaySeconds = pd_delayForImageAtIndex(Int(index), source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }

        let duration: Int = {
            var sum = 0
            for val in delays {
                sum += val
            }
            return sum
        }()

        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for index in 0 ..< count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            for _ in 0 ..< frameCount {
                frames.append(frame)
            }
        }
        return (frames, Double(duration) / 1000.0)
    }

    private static func pd_delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self
        )
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1
        }
        return delay
    }

    private static func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        for val in array {
            gcd = gcdForPair(val, gcd)
        }
        return gcd
    }

    private static func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }

        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        var rest: Int
        while true {
            rest = lhs! % rhs!
            if rest == 0 {
                return rhs!
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
}

public extension UIImage {

    func pd_drawWatermark(with text: String, attributes: [NSAttributedString.Key: Any]?, frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        text.pd_nsString().draw(in: frame, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }

    func pd_addImageWatermark(rect: CGRect, image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    static func pd_textImage(_ text: String, fontSize: CGFloat = 16, size: (CGFloat, CGFloat), backgroundColor: UIColor = UIColor.orange, textColor: UIColor = UIColor.white, isCircle: Bool = true, isFirstChar: Bool = false) -> UIImage? {
        if text.isEmpty { return nil }
        let letter = isFirstChar ? (text as NSString).substring(to: 1) : text
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)

        let textsize = text.pd_stringSize(sizer.screen.width, font: .systemFont(ofSize: fontSize))

        UIGraphicsBeginImageContext(sise)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        let minSide = min(size.0, size.1)
        if isCircle {
            UIBezierPath(roundedRect: rect, cornerRadius: minSide * 0.5).addClip()
        }
        ctx.setFillColor(backgroundColor.cgColor)
        ctx.fill(rect)
        let attr = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]

        let pointX: CGFloat = textsize.width > minSide ? 0 : (minSide - textsize.width) / 2.0
        let pointY: CGFloat = (minSide - fontSize - 4) / 2.0
        (letter as NSString).draw(at: CGPoint(x: pointX, y: pointY), withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIImage {

    func pd_saveImageToPhotoAlbum(_ completion: ((Bool) -> Void)?) {
        saveBlock = completion
        UIImageWriteToSavedPhotosAlbum(self,
                                       self,
                                       #selector(saveImage(image:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }

    func pd_savePhotosImageToAlbum(completion: @escaping ((Bool, Error?) -> Void)) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: self)
        } completionHandler: { (isSuccess: Bool, error: Error?) in
            completion(isSuccess, error)
        }
    }

    private var saveBlock: ((Bool) -> Void)? {
        get { AssociatedObject.get(self, AssociateKeys.SaveBlockKey!) as? ((Bool) -> Void) }
        set {
            AssociatedObject.set(self, AssociateKeys.SaveBlockKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            saveBlock?(false)
        } else {
            saveBlock?(true)
        }
    }
}

public extension UIImage {

    func pd_imageTile(size: CGSize) -> UIImage? {
        let tempView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        tempView.backgroundColor = UIColor(patternImage: self)
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        tempView.layer.render(in: context)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return bgImage
    }

    static func pd_imageSize(_ url: URL?, max: CGFloat? = nil) -> CGSize {
        guard let url else { return .zero }
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else { return .zero }
        guard let result = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else { return .zero }
        guard let width = result["PixelWidth"] as? CGFloat else { return .zero }
        guard let height = result["PixelHeight"] as? CGFloat else { return .zero }

        var size = CGSize(width: width, height: height)

        guard let relative = max else { return size }

        if size.height > size.width {
            size.width = size.width / size.height * relative
            size.height = relative
        } else {
            size.height = size.height / size.width * relative
            size.width = relative
        }
        return size
    }
}
