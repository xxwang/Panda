
import CoreGraphics
import CoreText
import UIKit

public extension UIFont {

    var bold: UIFont {
        UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
    }

    var italic: UIFont {
        UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitItalic)!, size: 0)
    }

    var monospaced: UIFont {
        let settings = [[
            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
            UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector,
        ]]

        let attributes = [UIFontDescriptor.AttributeName.featureSettings: settings]
        let newDescriptor = fontDescriptor.addingAttributes(attributes)
        return UIFont(descriptor: newDescriptor, size: 0)
    }
}

public extension UIFont {

    convenience init(YaHei type: MicrosoftYaHeiFont, size: CGFloat = 12) {
        self.init(name: type.rawValue, size: size)!
    }

    convenience init(PingFang type: PingFangSCFont, size: CGFloat = 12) {
        self.init(name: type.rawValue, size: size)!
    }
}

public extension UIFont {
    static func printAllFonts() {
        print("────────────────────────────────────────────────────────────")
        for fontFamilyName in UIFont.familyNames {
            print("font family name :\(fontFamilyName)")
            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName) {
                print("├────── \(fontName)")
            }
            print("────────────────────────────────────────────────────────────")
        }
    }

    static func preset(for textStyle: TextStyle,
                       compatibleWith: UITraitCollection? = nil) -> UIFont
    {
        UIFont.preferredFont(forTextStyle: textStyle, compatibleWith: compatibleWith)
    }

    static func microsoftYaHei(_ type: MicrosoftYaHeiFont, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    static func pingFang(_ type: PingFangSCFont, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    static func system(_ type: SystemFont? = nil, size: CGFloat) -> UIFont {
        guard let type else { return .systemFont(ofSize: size) }
        return UIFont.systemFont(ofSize: size, weight: type.weight)
    }
}

public extension UIFont {

    @discardableResult
    func fontSize(_ fontSize: CGFloat) -> UIFont {
        withSize(fontSize)
    }
}

public enum MicrosoftYaHeiFont: String {
    case bold = "MicrosoftYaHei-Bold"
    case light = "MicrosoftYaHeiLight"
    case regular = "MicrosoftYaHei"
    case UIBold = "MicrosoftYaHeiUI-Bold"
    case UILight = "MicrosoftYaHeiUILight"
    case UIRegular = "MicrosoftYaHeiUI"
}

public enum PingFangSCFont: String {
    case semibold = "PingFangSC-Semibold"
    case medium = "PingFangSC-Medium"
    case regular = "PingFangSC-Regular"
    case light = "PingFangSC-Light"
    case thin = "PingFangSC-Thin"
    case ultralight = "PingFangSC-Ultralight"
}

public enum SystemFont {
    case regular
    case medium
    case bold
    case semibold
    case ultraLight
    case thin
    case light
    case heavy
    case black

    var weight: UIFont.Weight {
        switch self {
        case .regular:
            return UIFont.Weight.regular
        case .medium:
            return UIFont.Weight.medium
        case .bold:
            return UIFont.Weight.bold
        case .semibold:
            return UIFont.Weight.semibold
        case .ultraLight:
            return UIFont.Weight.ultraLight
        case .thin:
            return UIFont.Weight.thin
        case .light:
            return UIFont.Weight.light
        case .heavy:
            return UIFont.Weight.heavy
        case .black:
            return UIFont.Weight.black
        }
    }
}
