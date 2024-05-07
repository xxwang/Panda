import Foundation


public extension Encodable {

    func pd_encode(encoder: JSONEncoder = .init()) -> Data? {
        let result = try? encoder.encode(self)
        return result
    }

    func pd_data() -> Data? {
        return self.pd_encode()
    }

    func pd_jsonString() -> String? {
        guard let jsonData = self.pd_data() else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

    func pd_jsonObject<T>() -> T? {
        guard let data = self.pd_data(),
              let object = try? JSONSerialization.jsonObject(with: data) as? T
        else {
            return nil
        }
        return object
    }
}


public extension Array where Element: Encodable {

    func pd_data() -> Data? {
        return self.pd_jsonString()?.pd_data()
    }

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


public extension Decodable {

    static func pd_decode(from data: Data, decoder: JSONDecoder = .init()) -> Self? {
        guard let result = try? decoder.decode(Self.self, from: data) else { return nil }
        return result
    }

    static func pd_model(_ string: String?) -> Self? where Self: Decodable {
        guard let data = string?.pd_data() else {
            return nil
        }
        return self.pd_model(data)
    }

    static func pd_model(_ data: Data?) -> Self? where Self: Decodable {
        guard let data else { return nil }
        return self.pd_decode(from: data)
    }

    static func pd_model(_ dict: [String: Any]?) -> Self? where Self: Decodable {
        guard let data = dict?.pd_jsonData() else {
            return nil
        }
        return self.pd_decode(from: data)
    }

    static func pd_models(_ array: [Any]?) -> [Self]? where Self: Decodable {
        guard let data = array?.pd_jsonData() else {
            return nil
        }
        return [Self].pd_decode(from: data)
    }
}

public extension String {

    func pd_jsonObject() -> [String: Any]? {
        guard let data = self.pd_data() else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }

    func pd_jsonObjects() -> [[String: Any]]? {
        guard let data = self.pd_data() else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    }

    func pd_jsonFormat() -> String {
        guard let data = self.pd_data() else {
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

    func pd_jsonObject<T>(for name: T.Type = Any.self, options: JSONSerialization.ReadingOptions = []) -> T? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: options) else {
            return nil
        }
        guard let jsonObject = jsonObject as? T else { return nil }
        return jsonObject
    }
}

public extension Collection {

    func pd_jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options: JSONSerialization.WritingOptions = (prettify == true) ? .prettyPrinted : .init()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }

    func pd_jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        guard let jsonData = self.pd_jsonData(prettify: prettify) else { return nil }
        return String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/", options: .caseInsensitive, range: nil)
    }
}
