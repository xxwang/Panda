#if canImport(SwiftUI)
    import SwiftUI

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public extension Color {

        init(r: Double, g: Double, b: Double, o: Double = 1.0) {
            let red = r / 255.0
            let green = g / 255.0
            let blue = b / 255.0
            self.init(red: red, green: green, blue: blue, opacity: o)
        }

        init(hex: String, opacity: Double = 1.0) {
            var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex

            guard hex.count == 3 || hex.count == 6 else {
                self.init(white: 1)
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
            self.init(r: Double(r), g: Double(g), b: Double(b), o: opacity)
        }
    }
#endif
