import Foundation

public extension UserDefaults {
    func sk_set(_ object: (some Codable)?, for key: String?, using encoder: JSONEncoder = JSONEncoder()) {
        guard let key else { return }
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
        self.synchronize()
    }

    func sk_object<T: Codable>(_ type: T.Type, for key: String?, using decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let key, let data = value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func sk_clearAll() {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
    }
}
