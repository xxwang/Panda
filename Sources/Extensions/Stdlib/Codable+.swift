import Foundation


public extension Encodable {

    func xx_encode(encoder: JSONEncoder = .init()) -> Data? {
        let result = try? encoder.encode(self)
        return result
    }

    func xx_data() -> Data? {
        return self.xx_encode()
    }

    func xx_jsonString() -> String? {
        guard let jsonData = self.xx_data() else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

    func xx_jsonObject<T>() -> T? {
        guard let data = self.xx_data(),
              let object = try? JSONSerialization.jsonObject(with: data) as? T
        else {
            return nil
        }
        return object
    }
}


public extension Array where Element: Encodable {

    func xx_data() -> Data? {
        return self.xx_jsonString()?.xx_data()
    }

    func xx_jsonString() -> String? {
        var objects: [[String: Any]] = []
        for mappable in self {
            if let object: [String: Any] = mappable.xx_jsonObject() {
                objects.append(object)
            }
        }
        return objects.xx_jsonString()
    }
}


public extension Decodable {

    static func xx_decode(from data: Data, decoder: JSONDecoder = .init()) -> Self? {
        guard let result = try? decoder.decode(Self.self, from: data) else { return nil }
        return result
    }

    static func xx_model(_ string: String?) -> Self? where Self: Decodable {
        guard let data = string?.xx_data() else {
            return nil
        }
        return self.xx_model(data)
    }

    static func xx_model(_ data: Data?) -> Self? where Self: Decodable {
        guard let data else { return nil }
        return self.xx_decode(from: data)
    }

    static func xx_model(_ dict: [String: Any]?) -> Self? where Self: Decodable {
        guard let data = dict?.xx_jsonData() else {
            return nil
        }
        return self.xx_decode(from: data)
    }

    static func xx_models(_ array: [Any]?) -> [Self]? where Self: Decodable {
        guard let data = array?.xx_jsonData() else {
            return nil
        }
        return [Self].xx_decode(from: data)
    }
}

public extension String {

    func xx_jsonObject() -> [String: Any]? {
        guard let data = self.xx_data() else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }

    func xx_jsonObjects() -> [[String: Any]]? {
        guard let data = self.xx_data() else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    }

    func xx_jsonFormat() -> String {
        guard let data = self.xx_data() else {
            return self
        }
        guard let anyObject = try? JSONSerialization.jsonObject(with: data) else {
            return self
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: anyObject, options: .prettyPrinted) else {
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

    func xx_jsonObject<T>(for name: T.Type = Any.self, options: JSONSerialization.ReadingOptions = []) -> T? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: options) else {
            return nil
        }
        guard let jsonObject = jsonObject as? T else { return nil }
        return jsonObject
    }
}

public extension Collection {

    func xx_jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options: JSONSerialization.WritingOptions = (prettify == true) ? .prettyPrinted : .init()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }

    func xx_jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        guard let jsonData = self.xx_jsonData(prettify: prettify) else { return nil }
        return String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/", options: .caseInsensitive, range: nil)
    }
}
