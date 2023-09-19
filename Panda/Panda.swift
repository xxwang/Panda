import UIKit

public class Panda {
    private(set) static var text = "Panda!"
}

public extension Panda {
    static func sayHello() {
        Log.info("Hello \(text)")
    }
}
