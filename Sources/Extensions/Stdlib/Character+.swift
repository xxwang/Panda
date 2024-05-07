import Foundation

public extension Character {

    func pd_string() -> String {
        return String(self)
    }
}

public extension Character {

    static func pd_random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}
