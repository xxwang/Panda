
import UIKit

public class QRCodeUtils {
    public static let shared = QRCodeUtils()
    private init() {}
}


public extension QRCodeUtils {

    func create(with content: String, size: CGSize, logoImage: UIImage? = nil, logoSize: CGSize? = nil, logoCornerRadius: CGFloat? = nil) -> UIImage? {

        let filter = CIFilter(name: "CIQRCodeGenerator")

        filter?.setDefaults()

        let data = content.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")

        filter?.setValue("H", forKey: "inputCorrectionLevel")

        guard let outPutImage = filter?.outputImage else { return nil }

        let extent = outPutImage.extent.integral
        let scale = min(size.width / extent.width, size.height / extent.height)

        let width = extent.width * scale
        let height = extent.height * scale

        let context = CIContext(options: nil)
        guard let bitmapImage = context.createCGImage(outPutImage, from: extent) else {
            return nil
        }

        let cs = CGColorSpaceCreateDeviceGray()

        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        bitmapRef?.interpolationQuality = CGInterpolationQuality.none
        bitmapRef?.scaleBy(x: scale, y: scale)
        bitmapRef?.draw(bitmapImage, in: extent)

        guard let scaledImage = bitmapRef?.makeImage() else { return nil }

        let outputImage = UIImage(cgImage: scaledImage)

        guard let logoImage, let logoSize else {
            return outputImage
        }

        var newLogo: UIImage = logoImage
        if let newLogoRoundCorner = logoCornerRadius,
           let roundCornersLogo = logoImage.pd_roundCorners(size: logoSize, radius: newLogoRoundCorner)
        {
            newLogo = roundCornersLogo
        }

        UIGraphicsBeginImageContextWithOptions(outputImage.size, false, UIScreen.main.scale)
        outputImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let waterImgW = logoSize.width
        let waterImgH = logoSize.height
        let waterImgX = (size.width - waterImgW) * 0.5
        let waterImgY = (size.height - waterImgH) * 0.5
        newLogo.draw(in: CGRect(x: waterImgX, y: waterImgY, width: waterImgW, height: waterImgH))
        let newPicture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newPicture
    }
}

public extension QRCodeUtils {

    func recognizeQRCode(_ image: UIImage) -> String? {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: CoreImage.CIImage(cgImage: image.cgImage!))
        guard (features?.count)! > 0 else { return nil }
        let feature = features?.first as? CIQRCodeFeature
        return feature?.messageString
    }

    func recognizeQRCodes(_ image: UIImage) -> [String] {
        readQRCodesFrom(image).map { $0.messageString ?? "" }
    }
    
    func readQRCodesFrom(_ image: UIImage) -> [CIQRCodeFeature] {
        let context = CIContext(options: nil)
        guard let ciImage = CIImage(image: image),
              let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature]
        else {
            return []
        }
        return features
    }
}
