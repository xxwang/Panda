
public class PandaEx<Base> {
    var base: Base

    init(_ base: Base) {
        self.base = base
    }
}

public protocol Pandaable {}
public extension Pandaable {

    var pd: PandaEx<Self> {
        PandaEx(self)
    }

    static var pd: PandaEx<Self>.Type {
        PandaEx<Self>.self
    }
}
