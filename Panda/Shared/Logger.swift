//
//  Logger.swift
//
//
//  Created by xxwang on 2023/5/20.
//

import Foundation

public class Logger {
    fileprivate enum Level: String {
        case debug = "[debug]"
        case info = "[info]"
        case warning = "[warning]"
        case error = "[error]"
        case success = "[success]"

        var icon: String {
            switch self {
            case .debug: return "👻"
            case .info: return "🌸"
            case .warning: return "⚠️"
            case .error: return "❌"
            case .success: return "✅"
            }
        }
    }
}

public extension Logger {
    static func debug(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .debug, message: message, file: file, line: line, function: function)
    }

    static func info(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .info, message: message, file: file, line: line, function: function)
    }

    static func warning(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .warning, message: message, file: file, line: line, function: function)
    }

    static func error(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .error, message: message, file: file, line: line, function: function)
    }

    static func success(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .success, message: message, file: file, line: line, function: function)
    }
}

extension Logger {
    fileprivate static func log(level: Level, message: Any..., file: String, line: Int, function: String) {
        let dateStr = Date.default().toString(with: "HH:mm:ss.SSS", isGMT: false)
        let fileName = file.toNSString().lastPathComponent.removingSuffix(".swift")
        let content = message.map { "\($0)" }.joined(separator: "")
        print("\(level.icon)\(level.rawValue)[\(dateStr)][\(fileName).\(line) => \(function)]: " + content)
    }
}
