import UIKit

public class Panda {
    let text = "Panda!"
}

public extension Panda {
    func sayHello() {
        Log.info("Hello \(text)")
    }
}
