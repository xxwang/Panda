import UIKit

public class Panda {
    public static var size = SizeUtils.self
    public static var dev = EnvUtils.self
    public static var log = Log.self
}

public extension Panda {
    func sayHello() {
        Log.info("Hello Panda!")
    }
}
