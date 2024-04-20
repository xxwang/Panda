#if canImport(SwiftUI)
    import SwiftUI

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public extension Color {
        /// 构造一个颜色对象
        ///
        /// - Note: 0-255颜色值
        /// - Parameters:
        ///   - r: 红色
        ///   - g: 绿色
        ///   - b: 蓝色
        ///   - o: 透明度
        init(r: Double, g: Double, b: Double, o: Double = 1.0) {
            let red = r / 255.0
            let green = g / 255.0
            let blue = b / 255.0
            self.init(red: red, green: green, blue: blue, opacity: o)
        }

        /// 使用十六进制字符串构造颜色对象
        /// - Parameters:
        ///   - hex: 十六进制字符串
        ///   - opacity: 不透明度
        init(hex: String, opacity: Double = 1.0) {
            // 去除前后空格及换行符
            var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            // 去除"#"
            hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex

            // 如果字符串字符个数不是3位或者6位(不规范)返回一个透明的白色s
            guard hex.count == 3 || hex.count == 6 else {
                self.init(white: 1)
                return
            }

            // 如果字符串字符个数为3位,补齐成6位
            if hex.count == 3 {
                for (index, char) in hex.enumerated() {
                    hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
                }
            }

            // 扫描器
            let scanner = Scanner(string: hex)

            // 获取UInt64颜色
            var color: UInt64 = 0
            scanner.scanHexInt64(&color)

            // 获取单个通道颜色值
            let mask = 0x0000_00FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            self.init(r: Double(r), g: Double(g), b: Double(b), o: opacity)
        }
    }
#endif
