public struct Panda {
    public private(set) var text = "Hello, World!"

    public init() {}
}

public extension Panda {
    func sayHello() {
        Log.info(text)
    }
}
