
import CoreGraphics
import UIKit


public extension UIColor {

    var sk_int: Int {
        let red = Int(sk_rgba.0 * 255) << 16
        let green = Int(sk_rgba.1 * 255) << 8
        let blue = Int(sk_rgba.2 * 255)
        return red + green + blue
    }


    var sk_uInt: UInt {
        let components: [CGFloat] = {
            let comps: [CGFloat] = cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()

        var colorAsUInt32: UInt32 = 0
        colorAsUInt32 += UInt32(components[0] * 255.0) << 16
        colorAsUInt32 += UInt32(components[1] * 255.0) << 8
        colorAsUInt32 += UInt32(components[2] * 255.0)

        return UInt(colorAsUInt32)
    }

    var sk_shortHexString: String? {
        let string = sk_hexString(true).replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return nil }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }

    var sk_shortHexOrHexString: String {
        let components: [Int] = {
            let comps = cgColor.components!.map { Int($0 * 255.0) }
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()
        let hexString = String(format: "#%02X%02X%02X", components[0], components[1], components[2])
        let string = hexString.replacingOccurrences(of: "#", with: "")
        let chrs = Array(string)
        guard chrs[0] == chrs[1], chrs[2] == chrs[3], chrs[4] == chrs[5] else { return hexString }
        return "#\(chrs[0])\(chrs[2])\(chrs[4])"
    }

    var sk_rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let numberOfComponents = self.cgColor.numberOfComponents
        guard let components = self.cgColor.components else {
            return (0, 0, 0, 1)
        }
        if numberOfComponents == 2 {
            return (components[0], components[0], components[0], components[1])
        }
        if numberOfComponents == 4 {
            return (components[0], components[1], components[2], components[3])
        }
        return (0, 0, 0, 1)
    }

    var sk_hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h * 360, s, b, a)
    }

    var sk_ciColor: CoreImage.CIColor? {
        CoreImage.CIColor(color: self)
    }

    var sk_complementaryColor: UIColor? {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: UIColor) -> UIColor?) = { _ -> UIColor? in
            if self.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = self.cgColor.components
                let components: [CGFloat] = [oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = UIColor(cgColor: colorRef!)
                return colorOut
            } else { return self }
        }

        let color = convertColorToRGBSpace(self)
        guard let componentColors = color?.cgColor.components else { return nil }

        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[0] * 255, 2.0)) / 255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[1] * 255, 2.0)) / 255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[2] * 255, 2.0)) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    var sk_alpha: CGFloat {
        get { cgColor.alpha }
        set { withAlphaComponent(newValue) }
    }

    static var sk_random: UIColor {
        let red = Int.random(in: 0 ... 255)
        let green = Int.random(in: 0 ... 255)
        let blue = Int.random(in: 0 ... 255)
        return UIColor(red: red, green: green, blue: blue)!
    }
}

public extension UIColor {
    func sk_rgbComponents() -> [CGFloat] {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)

        return [r, g, b]
    }

    var sk_intComponents: (red: Int, green: Int, blue: Int) {
        let components: [CGFloat] = {
            let comps: [CGFloat] = cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (red: Int(red * 255.0), green: Int(green * 255.0), blue: Int(blue * 255.0))
    }

    var sk_cgFloatComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let components: [CGFloat] = {
            let comps: [CGFloat] = cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return (red: red * 255.0, green: green * 255.0, blue: blue * 255.0)
    }

    var sk_hsbaComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    var sk_redComponent: CGFloat {
        var red: CGFloat = 0
        getRed(&red, green: nil, blue: nil, alpha: nil)
        return red
    }

    var sk_greenComponent: CGFloat {
        var green: CGFloat = 0
        getRed(nil, green: &green, blue: nil, alpha: nil)
        return green
    }

    var sk_blueComponent: CGFloat {
        var blue: CGFloat = 0
        getRed(nil, green: nil, blue: &blue, alpha: nil)
        return blue
    }

    var sk_alphaComponent: CGFloat {
        var alpha: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return alpha
    }

    var sk_hueComponent: CGFloat {
        var hue: CGFloat = 0
        getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }

    var sk_saturationComponent: CGFloat {
        var saturation: CGFloat = 0
        getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
        return saturation
    }

    var sk_brightnessComponent: CGFloat {
        var brightness: CGFloat = 0
        getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
}

public extension UIColor {
    var isDark: Bool {
        let RGB = sk_rgbComponents()
        return (0.2126 * RGB[0] + 0.7152 * RGB[1] + 0.0722 * RGB[2]) < 0.5
    }

    var isBlackOrWhite: Bool {
        let RGB = sk_rgbComponents()
        return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }

    var isBlack: Bool {
        let RGB = sk_rgbComponents()
        return RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09
    }

    var isWhite: Bool {
        let RGB = sk_rgbComponents()
        return RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91
    }

    func sk_isDistinct(from color: UIColor) -> Bool {
        let bg = sk_rgbComponents()
        let fg = color.sk_rgbComponents()
        let threshold: CGFloat = 0.25
        var result = false

        if Swift.abs(bg[0] - fg[0]) > threshold || Swift.abs(bg[1] - fg[1]) > threshold || Swift.abs(bg[2] - fg[2]) > threshold {
            if Swift.abs(bg[0] - bg[1]) < 0.03, Swift.abs(bg[0] - bg[2]) < 0.03 {
                if Swift.abs(fg[0] - fg[1]) < 0.03, Swift.abs(fg[0] - fg[2]) < 0.03 {
                    result = false
                }
            }
            result = true
        }

        return result
    }

    func sk_isContrasting(with color: UIColor) -> Bool {
        let bg = sk_rgbComponents()
        let fg = color.sk_rgbComponents()

        let bgLum = 0.2126 * bg[0] + 0.7152 * bg[1] + 0.0722 * bg[2]
        let fgLum = 0.2126 * fg[0] + 0.7152 * fg[1] + 0.0722 * fg[2]
        let contrast = bgLum > fgLum
            ? (bgLum + 0.05) / (fgLum + 0.05)
            : (fgLum + 0.05) / (bgLum + 0.05)

        return contrast > 1.6
    }
}

public extension UIColor {

    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0, red <= 255 else { return nil }
        guard green >= 0, green <= 255 else { return nil }
        guard blue >= 0, blue <= 255 else { return nil }

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }

    convenience init(hex int: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((int & 0xFF0000) >> 16)
        let green = CGFloat((int & 0xFF00) >> 8)
        let blue = CGFloat(int & 0xFF)
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }

    convenience init(hex string: String, alpha: CGFloat = 1.0) {
        var hex = string.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex

        guard hex.count == 3 || hex.count == 6 else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }

        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }

        let scanner = Scanner(string: hex)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let mask = 0x0000_00FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init?(hexARGB string: String) {
        var string = string.replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "#", with: "")

        if string.count <= 4 {
            var str = ""
            for character in string {
                str.append(String(repeating: String(character), count: 2))
            }
            string = str
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        let hasAlpha = string.count == 8
        let alpha = hasAlpha ? (hexValue >> 24) & 0xFF : 0xFF
        let red = (hexValue >> 16) & 0xFF
        let green = (hexValue >> 8) & 0xFF
        let blue = hexValue & 0xFF

        self.init(red: red, green: green, blue: blue, transparency: CGFloat(alpha) / 255)
    }

    convenience init?(complementaryFor color: UIColor) {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: UIColor) -> UIColor?) = { color -> UIColor? in
            if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components: [CGFloat] = [oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = UIColor(cgColor: colorRef!)
                return colorOut
            } else {
                return color
            }
        }

        let color = convertColorToRGBSpace(color)
        guard let componentColors = color?.cgColor.components else { return nil }

        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[0] * 255, 2.0)) / 255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[1] * 255, 2.0)) / 255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow(componentColors[2] * 255, 2.0)) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, tvOS 13.0, *) {
            self.init(dynamicProvider: { $0.userInterfaceStyle == .dark ? dark : light })
        } else {
            self.init(cgColor: light.cgColor)
        }
    }

    convenience init?(_ size: CGSize,
                      colors: [UIColor],
                      locations: [CGFloat] = [0, 1],
                      type: CAGradientLayerType = .axial,
                      start: CGPoint,
                      end: CGPoint)
    {
        let layer = CAGradientLayer.default()
            .sk_frame(CGRect(origin: .zero, size: size))
            .sk_colors(colors)
            .sk_locations(locations)
            .sk_type(type)
            .sk_start(start)
            .sk_end(end)

        UIGraphicsBeginImageContext(size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard image != nil else { return nil }

        self.init(patternImage: image!)
    }
}

public extension UIColor {

    func sk_image(by size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }

    func sk_hexString(_ hashPrefix: Bool = true) -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let prefix = hashPrefix ? "#" : ""
        return String(format: "\(prefix)%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }

    static func sk_proceesHex(hex: String, alpha: CGFloat) -> UIColor {
        if hex.isEmpty {
            return UIColor.clear
        }

        let whitespace = NSCharacterSet.whitespacesAndNewlines
        var hHex = (hex.trimmingCharacters(in: whitespace)).uppercased()

        if hHex.count < 6 {
            return UIColor.clear
        }

        if hHex.hasPrefix("0X") || hHex.hasPrefix("##") {
            hHex = String(hHex.dropFirst(2))
        }

        if hHex.hasPrefix("#") {
            hHex = (hHex as NSString).substring(from: 1)
        }

        if hHex.count != 6 {
            return UIColor.clear
        }

        var range = NSRange(location: 0, length: 2)

        let rHex = (hHex as NSString).substring(with: range)

        range.location = 2
        let gHex = (hHex as NSString).substring(with: range)

        range.location = 4
        let bHex = (hHex as NSString).substring(with: range)

        var r: CUnsignedLongLong = 0,
            g: CUnsignedLongLong = 0,
            b: CUnsignedLongLong = 0

        Scanner(string: rHex).scanHexInt64(&r)
        Scanner(string: gHex).scanHexInt64(&g)
        Scanner(string: bHex).scanHexInt64(&b)

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    static func sk_blend(_ color1: UIColor,
                         intensity1: CGFloat = 0.5,
                         with color2: UIColor,
                         intensity2: CGFloat = 0.5) -> UIColor
    {
        let total = intensity1 + intensity2
        let level1 = intensity1 / total
        let level2 = intensity2 / total

        guard level1 > 0 else { return color2 }
        guard level2 > 0 else { return color1 }

        let components1: [CGFloat] = {
            let comps: [CGFloat] = color1.cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()

        let components2: [CGFloat] = {
            let comps: [CGFloat] = color2.cgColor.components!
            guard comps.count != 4 else { return comps }
            return [comps[0], comps[0], comps[0], comps[1]]
        }()

        let red1 = components1[0]
        let red2 = components2[0]

        let green1 = components1[1]
        let green2 = components2[1]

        let blue1 = components1[2]
        let blue2 = components2[2]

        let alpha1 = color1.cgColor.alpha
        let alpha2 = color2.cgColor.alpha

        let red = level1 * red1 + level2 * red2
        let green = level1 * green1 + level2 * green2
        let blue = level1 * blue1 + level2 * blue2
        let alpha = level1 * alpha1 + level2 * alpha2

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    func sk_add(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> UIColor {
        var (oldHue, oldSat, oldBright, oldAlpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        getHue(&oldHue, saturation: &oldSat, brightness: &oldBright, alpha: &oldAlpha)

        var newHue = oldHue + hue
        while newHue < 0.0 {
            newHue += 1.0
        }
        while newHue > 1.0 {
            newHue -= 1.0
        }

        let newBright: CGFloat = max(min(oldBright + brightness, 1.0), 0)
        let newSat: CGFloat = max(min(oldSat + saturation, 1.0), 0)
        let newAlpha: CGFloat = max(min(oldAlpha + alpha, 1.0), 0)

        return UIColor(hue: newHue, saturation: newSat, brightness: newBright, alpha: newAlpha)
    }

    func sk_add(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        var (oldRed, oldGreen, oldBlue, oldAlpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        getRed(&oldRed, green: &oldGreen, blue: &oldBlue, alpha: &oldAlpha)

        let newRed: CGFloat = max(min(oldRed + red, 1.0), 0)
        let newGreen: CGFloat = max(min(oldGreen + green, 1.0), 0)
        let newBlue: CGFloat = max(min(oldBlue + blue, 1.0), 0)
        let newAlpha: CGFloat = max(min(oldAlpha + alpha, 1.0), 0)
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }

    func sk_add(hsb color: UIColor) -> UIColor {
        var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return sk_add(hue: h, saturation: s, brightness: b, alpha: 0)
    }

    func sk_add(rgb color: UIColor) -> UIColor {
        sk_add(red: color.sk_redComponent, green: color.sk_greenComponent, blue: color.sk_blueComponent, alpha: 0)
    }

    func add(hsba color: UIColor) -> UIColor {
        var (h, s, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return sk_add(hue: h, saturation: s, brightness: b, alpha: a)
    }

    func sk_add(rgba color: UIColor) -> UIColor {
        sk_add(red: color.sk_redComponent, green: color.sk_greenComponent, blue: color.sk_blueComponent, alpha: color.sk_alphaComponent)
    }

    func sk_color(minSaturation: CGFloat) -> UIColor {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return saturation < minSaturation
            ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
            : self
    }

    func sk_lighten(by percentage: CGFloat = 0.2) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: min(red + percentage, 1.0),
                       green: min(green + percentage, 1.0),
                       blue: min(blue + percentage, 1.0),
                       alpha: alpha)
    }

    func sk_darken(by percentage: CGFloat = 0.2) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: max(red - percentage, 0),
                       green: max(green - percentage, 0),
                       blue: max(blue - percentage, 0),
                       alpha: alpha)
    }
}

public extension UIColor {

    static func sk_darkModeColor(hex: String) -> UIColor {
        sk_darkModeColor(lightColor: hex, darkColor: hex)
    }

    static func sk_darkModeColor(lightColor: String, darkColor: String) -> UIColor {
        sk_darkModeColor(lightColor: UIColor(hex: lightColor), darkColor: UIColor(hex: darkColor))
    }

    static func sk_darkModeColor(color: UIColor) -> UIColor {
        sk_darkModeColor(lightColor: color, darkColor: color)
    }

    static func sk_darkModeColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkColor
                } else {
                    return lightColor
                }
            }
        } else {
            return lightColor
        }
    }
}

public extension UIColor {

    static func sk_createLinearGradientColor(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             start: CGPoint,
                                             end: CGPoint) -> UIColor?
    {
        UIColor(size, colors: colors, locations: locations, type: .axial, start: start, end: end)
    }

    static func sk_createLinearGradientLayer(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             start: CGPoint,
                                             end: CGPoint) -> CAGradientLayer
    {
        CAGradientLayer(CGRect(origin: .zero, size: size),
                        colors: colors,
                        locations: locations,
                        start: start,
                        end: end,
                        type: .axial)
    }

    static func sk_createLinearGradientImage(_ size: CGSize,
                                             colors: [UIColor],
                                             locations: [CGFloat] = [0, 1],
                                             start: CGPoint,
                                             end: CGPoint) -> UIImage?
    {
        let layer = sk_createLinearGradientLayer(size, colors: colors, locations: locations, start: start, end: end)
        UIGraphicsBeginImageContext(size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

public extension [UIColor] {

    func sk_createLinearGradientColor(_ size: CGSize,
                                      locations: [CGFloat] = [0, 1],
                                      start: CGPoint,
                                      end: CGPoint) -> UIColor?
    {
        UIColor.sk_createLinearGradientColor(size, colors: self, locations: locations, start: start, end: end)
    }

    func sk_createLinearGradientLayer(_ size: CGSize,
                                      locations: [CGFloat] = [0, 1],
                                      start: CGPoint,
                                      end: CGPoint) -> CAGradientLayer
    {
        UIColor.sk_createLinearGradientLayer(size, colors: self, locations: locations, start: start, end: end)
    }

    func sk_createLinearGradientImage(_ size: CGSize,
                                      locations: [CGFloat] = [0, 1],
                                      start: CGPoint,
                                      end: CGPoint) -> UIImage?
    {
        UIColor.sk_createLinearGradientImage(size, colors: self, locations: locations, start: start, end: end)
    }
}

public extension UIColor {

    func sk_alpha(_ value: CGFloat) -> UIColor {
        return self.withAlphaComponent(value)
    }
}
