//
//  Decodable+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import Foundation

// MARK: - 方法
public extension Decodable {
    /// 解码(遵守`Decodable`类型的`Data`)
    /// - Parameters:
    ///   - data:`Data`
    ///   - decoder:`JSONDecoder`
    /// - Returns:Base类型的对象
    static func decode(from data: Data, decoder: JSONDecoder = .init()) -> Self? {
        guard let result = try? decoder.decode(Self.self, from: data) else { return nil }
        return result
    }
}

// MARK: - Decodable
public extension Decodable {
    /// `JSON String?`转模型
    /// - Parameter string:`JSON`字符串
    /// - Returns:Self
    static func toModel(_ string: String?) -> Self? where Self: Decodable {
        guard let data = string?.toData() else {
            return nil
        }
        return toModel(data)
    }

    /// `JSON Data?`转模型
    /// - Parameter data:`JSON Data`
    /// - Returns:Self
    static func toModel(_ data: Data?) -> Self? where Self: Decodable {
        guard let data else {
            return nil
        }
        return decode(from: data)
    }

    /// `[String:Any]?` 转模型
    /// - Parameter jsonDictionary:`JSON字典`
    /// - Returns:Self
    static func toModel(_ dict: [String: Any]?) -> Self? where Self: Decodable {
        guard let data = dict?.toData() else {
            return nil
        }
        return decode(from: data)
    }

    /// `[Any]?` 转模型
    /// - Parameter jsonArray:`JSON数组`
    /// - Returns:`Self`数组
    static func toModels(_ array: [Any]?) -> [Self]? where Self: Decodable {
        guard let data = array?.toData() else {
            return nil
        }
        return [Self].decode(from: data)
    }
}
