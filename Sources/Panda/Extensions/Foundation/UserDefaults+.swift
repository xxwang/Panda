//
//  UserDefaults+.swift
//
//
//  Created by 王斌 on 2023/5/23.
//

import Foundation

// MARK: - 模型持久化
public extension UserDefaults {
    /// 保存遵守`Codable`协议的对象到`UserDefaults`
    /// - Parameters:
    ///   - object: 要存储的对象
    ///   - key: 存取数据使用的`关键字`
    ///   - encoder: 编码器
    /// - Returns: 操作是否成功
    func set(_ object: (some Codable)?, for key: String?, using encoder: JSONEncoder = JSONEncoder()) {
        guard let object, let key, let data = try? encoder.encode(object) else { return }
        set(data, forKey: key)
        synchronize()
    }

    /// 从`UserDefaults`检索遵守`Codable`的对象
    /// - Parameters:
    ///   - type: 对象类型
    ///   - key: 存取数据使用的`关键字`
    ///   - decoder: 解码器
    /// - Returns: 遵守`Codable`的对象
    func get<T: Codable>(_ type: T.Type, for key: String?, using decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let key, let data = value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
}

// MARK: - 方法
public extension UserDefaults {
    /// 从`UserDefaults`中移除当前应用存储的所有数据
    /// - Returns: 是否成功
    func clearAll() -> Bool {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
    }
}
