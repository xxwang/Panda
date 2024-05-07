import Foundation

public extension Bool {

    func pd_int() -> Int {
        return self ? 1 : 0
    }

    func pd_string() -> String {
        return self ? "true" : "false"
    }
}
