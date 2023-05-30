import UIKit

public class Panda {
    public private(set) var text = "Panda!"
}

public extension Panda {
    func sayHello() {
        Log.info("Hello \(text)")
    }
}
