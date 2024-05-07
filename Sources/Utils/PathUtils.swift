
import UIKit

public class PathUtils {
    public static let shared = PathUtils()
    private init() {}
}


public extension PathUtils {

    static func supportPath() -> String {
        NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
    }

    static func supportURL() -> URL {
        URL(fileURLWithPath: supportPath(), isDirectory: true)
    }

    static func homePath() -> String {
        NSHomeDirectory()
    }

    static func homeURL() -> URL {
        URL(fileURLWithPath: homePath(), isDirectory: true)
    }

    static func documnetsPath() -> String {
        NSHomeDirectory() + "/Documents"
    }

    static func documnetsURL() -> URL {
        URL(fileURLWithPath: documnetsPath(), isDirectory: true)
    }

    static func libraryPath() -> String {
        NSHomeDirectory() + "/Library"
    }

    static func libraryURL() -> URL {
        URL(fileURLWithPath: libraryPath(), isDirectory: true)
    }

    static func cachesPath() -> String {
        NSHomeDirectory() + "/Library/Caches"
    }

    static func cachesURL() -> URL {
        URL(fileURLWithPath: cachesPath(), isDirectory: true)
    }

    static func preferencesPath() -> String {
        NSHomeDirectory() + "/Library/Preferences"
    }

    static func preferencesURL() -> URL {
        URL(fileURLWithPath: preferencesPath(), isDirectory: true)
    }

    static func tmpPath() -> String {
        NSHomeDirectory() + "/tmp"
    }

    static func tmpURL() -> URL {
        URL(fileURLWithPath: tmpPath(), isDirectory: true)
    }
}


public extension PathUtils {

    static func supportAppend(_ path: String) -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(path)"
    }

    static func supportAppend(_ path: String) -> URL {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        createDirs(url.absoluteString)
        return url.pd_appendingPathComponent(path)
    }

    static func documentAppend(_ path: String) -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(path)"
    }

    static func documentAppend(_ path: String) -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        createDirs(url.absoluteString)
        return url.pd_appendingPathComponent(path)
    }

    static func cacheAppend(_ path: String) -> String {
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        createDirs(directory)
        return directory + "/\(path)"
    }

    static func cacheAppend(_ path: String) -> URL {
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        createDirs(url.absoluteString)
        return url.pd_appendingPathComponent(path)
    }

    static func tempAppend(_ path: String) -> String {
        let directory = NSTemporaryDirectory()
        createDirs(directory)
        return directory + "/\(path)"
    }
}

public extension PathUtils {

    static func createDirs(_ path: String) {
        let path = path.contains(NSHomeDirectory()) ? path : "\(NSHomeDirectory())/\(self)"
        let dirs = path.components(separatedBy: "/")
        let dir = dirs[0 ..< dirs.count - 1].joined(separator: "/")
        if !FileManager.default.fileExists(atPath: dir) {
            do {
                try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
}
