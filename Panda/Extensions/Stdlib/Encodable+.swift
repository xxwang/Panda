import Foundation

// MARK: - Encodable
public extension Encodable {
    /// 编码(遵守`Encodable`的对象)
    /// - Parameter encoder:编码器
    /// - Returns:`Data`
    func encode(encoder: JSONEncoder = .init()) -> Data? {
        let result = try? encoder.encode(self)
        return result
    }

    /// 转`Data?`
    /// - Returns:`Data?`
    func toData() -> Data? {
        encode()
    }

    /// 转`JSON`字符串
    /// - Returns:`JSON`字符串
    func toJSONString() -> String? {
        guard let jsonData = toData() else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

    /// 转`[String:Any]`
    /// - Returns:`[String:Any]`
    func toJSONObject<T>() -> T? {
        guard let data = toData(),
              let object = try? JSONSerialization.jsonObject(with: data) as? T
        else {
            return nil
        }
        return object
    }
}

// MARK: - Array<Encodable>
public extension Array where Element: Encodable {
    /// 数组转`Data?`
    /// - Returns:`Data?`
    func toData() -> Data? {
        toJSONString()?.toData()
    }

    /// 数组转`JSON`字符串
    /// - Returns:`JSON`字符串
    func toJSONString() -> String? {
        var objects: [[String: Any]] = []
        for mappable in self {
            if let object: [String: Any] = mappable.toJSONObject() {
                objects.append(object)
            }
        }
        return objects.pd_JSONString()
    }
}
