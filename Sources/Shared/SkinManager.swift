import UIKit

public protocol Skinable: AnyObject {
    func apply()
}

public extension Skinable where Self: UITraitEnvironment {
    var skinManager: SkinProvider {
        return SkinManager.shared
    }
}

public protocol SkinProvider: AnyObject {
    func register<Observer: Skinable>(observer: Observer)
    func remove<Observer: Skinable>(observer: Observer)
    func updateSkin()
}

public class SkinManager {
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    public static let shared = SkinManager()
    private init() {}
}

extension SkinManager: SkinProvider {
    public func register(observer: some Skinable) {
        observers.add(observer)
    }

    public func remove(observer: some Skinable) {
        if !observers.contains(observer) { return }
        observers.remove(observer)
    }

    public func updateSkin() {
        DispatchQueue.main.async {
            self.observers
                .allObjects
                .compactMap { $0 as? Skinable }
                .forEach { $0.apply() }
        }
    }
}
