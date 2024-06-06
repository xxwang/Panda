import Foundation

public class Logger {
    public static func info(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .info, message: message, file: file, line: line, function: function)
    }

    public static func debug(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .debug, message: message, file: file, line: line, function: function)
    }

    public static func warning(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .warning, message: message, file: file, line: line, function: function)
    }

    public static func error(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .error, message: message, file: file, line: line, function: function)
    }

    public static func success(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .success, message: message, file: file, line: line, function: function)
    }
}

private extension Logger {
    enum Level: String {
        case info = "[Info]"
        case debug = "[Debug]"
        case warning = "[Warning]"
        case error = "[Error]"
        case success = "[Success]"

        var icon: String {
            switch self {
            case .info: return "🌸"
            case .debug: return "👻"
            case .warning: return "⚠️"
            case .error: return "❌"
            case .success: return "✅"
            }
        }
    }

    static func log(level: Level, message: Any..., file: String, line: Int, function: String) {
        let dateStr = Date.sk_now().sk_string(with: "HH:mm:ss.SSS", isGMT: false)
        let fileName = file.sk_nsString().lastPathComponent.sk_removeSuffix(".swift")
        let content = message.map { "\($0)" }.joined(separator: "")
        print("\(level.icon)::PD::\(level.rawValue)[\(dateStr)]{\(fileName)(\(line)) => \(function)}: " + content)
    }
}
