//
//  Logger.swift
//
//
//  Created by xxwang on 2023/5/20.
//

import Foundation

public class Logger {
    public static func debug(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .debug, message: message, file: file, line: line, function: function)
    }

    public static func info(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .info, message: message, file: file, line: line, function: function)
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
        case success = "[成功]"
        case error = "[错误]"
        case warning = "[警告]"
        case debug = "[调试]"
        case info = "[信息]"

        var icon: String {
            switch self {
            case .success: return "✅"
            case .error: return "❌"
            case .warning: return "⚠️"
            case .debug: return "👻"
            case .info: return "🌸"
            }
        }
    }

    static func log(level: Level, message: Any..., file: String, line: Int, function: String) {
        let dateStr = Date.default().toString(with: "HH:mm:ss.SSS", isGMT: false)
        let fileName = file.pd_nsString().lastPathComponent.pd_removeSuffix(".swift")
        let content = message.map { "\($0)" }.joined(separator: "")
        print("\(level.icon)\(level.rawValue)[\(dateStr)][\(fileName).\(line) => \(function)]: " + content)
    }
}
