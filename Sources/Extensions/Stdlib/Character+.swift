import Foundation

public extension Character {

    func xx_string() -> String {
        return String(self)
    }
}

public extension Character {

    static func xx_random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}
