import Foundation

// MARK: - Encodable
public extension Encodable {
    /// 编码(遵守`Encodable`的对象)
    /// - Parameter encoder:编码器
    /// - Returns:`Data`
    func pd_encode(encoder: JSONEncoder = .init()) -> Data? {
        let result = try? encoder.encode(self)
        return result
    }
    
    /// 模型转`Data?`
    /// - Returns:`Data?`
    func pd_data() -> Data? {
        return self.pd_encode()
    }
    
    /// 模型转`JSON`字符串
    /// - Returns:`JSON`字符串
    func pd_jsonString() -> String? {
        guard let jsonData = self.pd_data() else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
    
    /// 模型转`[String: Any]`
    /// - Returns:`[String: Any]`
    func pd_jsonObject<T>() -> T? {
        guard let data = self.pd_data(),
              let object = try? JSONSerialization.jsonObject(with: data) as? T
        else {
            return nil
        }
        return object
    }
}

// MARK: - Array<Encodable>
public extension Array where Element: Encodable {
    /// 模型数组转`Data?`
    /// - Returns:`Data?`
    func pd_data() -> Data? {
        return self.pd_jsonString()?.pd_data()
    }
    
    /// 数组转`JSON`字符串
    /// - Returns:`JSON`字符串
    func pd_jsonString() -> String? {
        var objects: [[String: Any]] = []
        for mappable in self {
            if let object: [String: Any] = mappable.pd_jsonObject() {
                objects.append(object)
            }
        }
        return objects.pd_jsonString()
    }
}

// MARK: - Decodable
public extension Decodable {
    /// 解码(遵守`Decodable`类型的`Data`)
    /// - Parameters:
    ///   - data:`Data`
    ///   - decoder:`JSONDecoder`
    /// - Returns:Base类型的对象
    static func pd_decode(from data: Data, decoder: JSONDecoder = .init()) -> Self? {
        guard let result = try? decoder.decode(Self.self, from: data) else { return nil }
        return result
    }
    
    /// `JSON String?`转模型
    /// - Parameter string: `JSON`字符串
    /// - Returns: `Self`
    static func pd_model(_ string: String?) -> Self? where Self: Decodable {
        guard let data = string?.pd_data() else {
            return nil
        }
        return self.pd_model(data)
    }
    
    /// `JSON Data?`转模型
    /// - Parameter data: `JSON``Data`
    /// - Returns: `Self`
    static func pd_model(_ data: Data?) -> Self? where Self: Decodable {
        guard let data else { return nil }
        return self.pd_decode(from: data)
    }
    
    /// `[String: Any]?` 转模型
    /// - Parameter dict: `JSON`字典
    /// - Returns: 模型
    static func pd_model(_ dict: [String: Any]?) -> Self? where Self: Decodable {
        guard let data = dict?.pd_jsonData() else {
            return nil
        }
        return self.pd_decode(from: data)
    }
    
    /// `[Any]?`转模型
    /// - Parameter array: `JSON`数组
    /// - Returns: 模型数组
    static func pd_models(_ array: [Any]?) -> [Self]? where Self: Decodable {
        guard let data = array?.pd_jsonData() else {
            return nil
        }
        return [Self].pd_decode(from: data)
    }
}

// MARK: - 转字典/字典数组
public extension String {
    /// `JSON`字符串转字典
    /// - Returns: 结果字典
    func pd_jsonObject() -> [String: Any]? {
        guard let data = self.pd_data() else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
    
    /// `JSON`字符串转字典数组
    /// - Returns: 结果数组
    func pd_jsonObjects() -> [[String: Any]]? {
        guard let data = self.pd_data() else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    }
    
    /// 格式化JSON字符串
    /// - Returns: 格式化结果
    func pd_jsonFormat() -> String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return self
        }
        return String(data: jsonData, encoding: .utf8)?.replacingOccurrences(
            of: "\\/",
            with: "/",
            options: .caseInsensitive, range: nil
        ) ?? self
    }
}

public extension Data {
    /// `Data`转成`Foundation`对象(数组/字典/...)
    /// - Parameters:
    ///   - name: 要转换的目标类型`[String:Any].self`
    ///   - options: 读取`JSON`数据和创建`Foundation`对象的选项
    /// - Returns: 失败返回`nil`
    func pd_jsonObject<T>(for name: T.Type = Any.self, options: JSONSerialization.ReadingOptions = []) -> T? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: options) else {
            return nil
        }
        guard let jsonObject = jsonObject as? T else { return nil }
        return jsonObject
    }
}

// MARK: - Collection
public extension Collection {
    /// 集合类型转换成`Data`
    ///
    /// - Note: 如果转换失败, 返回`nil`
    /// - Parameter prettify: 是否格式化`JSON`样式
    /// - Returns: `JSON`格式的`Data?`
    func pd_jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options: JSONSerialization.WritingOptions = (prettify == true) ? .prettyPrinted : .init()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    
    /// 集合类型转换成`JSON`字符串
    ///
    /// - Note: 如果转换失败, 返回`nil`
    /// - Parameter prettify: 是否格式化`JSON`样式
    /// - Returns: `JSON`字符串
    func pd_jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        guard let jsonData = self.pd_jsonData(prettify: prettify) else { return nil }
        return String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/", options: .caseInsensitive, range: nil)
    }
}

