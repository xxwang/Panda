import Foundation

public extension Character {

    func sk_string() -> String {
        return String(self)
    }
}

public extension Character {

    static func sk_random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}
