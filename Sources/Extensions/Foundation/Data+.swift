import UIKit

public extension Data {
    func xx_image() -> UIImage? {
        return UIImage(data: self)
    }

    func xx_bytes() -> [UInt8] {
        return [UInt8](self)
    }

    func xx_string(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }

    func xx_hexString() -> String {
        let result = withUnsafeBytes { rawPointer -> String in
            let unsafeBufferPointer = rawPointer.bindMemory(to: UInt8.self)
            let bytes = unsafeBufferPointer.baseAddress!
            let buffer = UnsafeBufferPointer(start: bytes, count: self.count)
            return buffer.map { String(format: "%02hhx", $0) }.reduce("") { $0 + $1 }.uppercased()
        }
        return result
    }

    func xx_subData(from: Int, len: Int) -> Data? {
        guard from >= 0, len >= 0 else { return nil }
        guard count >= from + len else { return nil }

        let startIndex = index(startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: from + len)
        let range = startIndex ..< endIndex
        return self[range]
    }
}

public extension Data {
    func xx_base64Encoded() -> Data? {
        return self.base64EncodedData()
    }

    func xx_base64Decoded() -> Data? {
        return Data(base64Encoded: self)
    }
}

public extension Data {
    func xx_imageFormat() -> String {
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
