import Foundation

public extension Bool {

    func sk_int() -> Int {
        return self ? 1 : 0
    }

    func sk_string() -> String {
        return self ? "true" : "false"
    }
}
