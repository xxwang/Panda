//
//  Log.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

import Foundation

// MARK: - 输出调试
public class Log {
    /// 日志等级
    enum Level: String {
        case debug = "[调试]"
        case info = "[信息]"
        case warning = "[警告]"
        case error = "[错误]"
        case success = "[成功]"

        /// 图标
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

public extension Log {
    /// 调试
    static func debug(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .debug, message: message, file: file, line: line, function: function)
    }

    /// 信息
    static func info(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .info, message: message, file: file, line: line, function: function)
    }

    /// 警告
    static func warning(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .warning, message: message, file: file, line: line, function: function)
    }

    /// 错误
    static func error(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .error, message: message, file: file, line: line, function: function)
    }
    
    /// 成功
    static func success(_ message: Any..., file: String = #file, line: Int = #line, function: String = #function) {
        log(level: .success, message: message, file: file, line: line, function: function)
    }
}

extension Log {
    /// 输出方法
    /// - Parameters:
    ///   - level:等级
    ///   - message:内容
    ///   - file:文件
    ///   - line:行
    ///   - function:方法
    private static func log(level: Level, message: Any..., file: String, line: Int, function: String) {
        let dateStr = Date.default().toString(with: "HH:mm:ss.SSS", isGMT: false)
        let fileName = file.toNSString().lastPathComponent.removingSuffix(".swift")
        let content = message.map { "\($0)" }.joined(separator: "")
        print("\(level.icon)\(level.rawValue)[\(dateStr)][\(fileName).\(line) => \(function)]: " + content)
    }
}
