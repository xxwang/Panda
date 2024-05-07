
import Foundation

public class PlistUtils {
    public static let shared = PlistUtils()
    private init() {}
}

public extension PlistUtils {

    func parse(plistName: String?) -> Any? {
        guard let plistName else { return nil }
        guard let plistPath = Bundle.pd_path(for: plistName) else { return nil }
        return parse(plistPath: plistPath)
    }

    func parse(plistPath: String?) -> Any? {
        guard let plistPath else { return nil }
        guard let plistData = FileManager.default.contents(atPath: plistPath) else { return nil }

        var format = PropertyListSerialization.PropertyListFormat.xml
        return try? PropertyListSerialization.propertyList(
            from: plistData,
            options: .mutableContainersAndLeaves,
            format: &format
        )
    }
}
