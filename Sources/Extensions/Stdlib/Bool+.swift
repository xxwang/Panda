import Foundation

public extension Bool {

    func xx_int() -> Int {
        return self ? 1 : 0
    }

    func xx_string() -> String {
        return self ? "true" : "false"
    }
}
