import UIKit

// MARK: - 方法
public extension Data {
    /// `Data`转`UIImage`
    /// - Returns: `UIImage?`
    func pd_image() -> UIImage? {
        return UIImage(data: self)
    }

    /// 以字节数组的形式返回数据
    /// - Returns: `[UInt8]`
    func pd_bytes() -> [UInt8] {
        return [UInt8](self)
    }

    /// 将`Data`转为`指定编码的字符串`
    /// - Parameter encoding: 编码格式
    /// - Returns: 对应字符串
    func pd_string(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }

    /// `Data`转`十六进制字符串`
    /// - Returns: `String`
    func pd_hexString() -> String {
        let result = withUnsafeBytes { rawPointer -> String in
            let unsafeBufferPointer = rawPointer.bindMemory(to: UInt8.self)
            let bytes = unsafeBufferPointer.baseAddress!
            let buffer = UnsafeBufferPointer(start: bytes, count: self.count)
            return buffer.map { String(format: "%02hhx", $0) }.reduce("") { $0 + $1 }.uppercased()
        }
        return result
    }

    /// 截取指定长度`Data`
    /// - Parameters:
    ///   - from: 开始位置
    ///   - len: 截取长度
    /// - Returns: 截取的`Data`
    func pd_subData(from: Int, len: Int) -> Data? {
        guard from >= 0, len >= 0 else { return nil }
        guard count >= from + len else { return nil }

        let startIndex = index(startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: from + len)
        let range = startIndex ..< endIndex
        return self[range]
    }
}

// MARK: - base64
public extension Data {
    /// `Data base64`编码
    /// - Returns: `Data?`
    func pd_base64Encoded() -> Data? {
        return self.base64EncodedData()
    }

    /// `Data base64`解码
    /// - Returns: `Data?`
    func pd_base64Decoded() -> Data? {
        return Data(base64Encoded: self)
    }
}

// MARK: - 图片格式
public extension Data {
    /// 获取资源格式
    /// - Parameter data: 资源
    /// - Returns: 格式
    func pd_imageFormat() -> String {
        let c = self[0]
        switch c {
        case 0xFF:
            return ".jpeg"
        case 0x89:
            return ".png"
        case 0x47:
            return ".gif"
        case 0x49, 0x4D:
            return ".tiff"
        default:
            return ".default"
        }
    }
}
