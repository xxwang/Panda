import Foundation

// MARK: - 构造方法
public extension URLRequest {
    /// 使用`URL`字符串构建`URLRequest`
    /// - Parameter urlString: URL`字符串
    init?(string urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.init(url: url)
    }
}

// MARK: - 方法
public extension URLRequest {
    /// `URLRequest`的`cURL`命令表示形式
    /// - Returns: 结果字符串
    func pd_cURLString() -> String {
        guard let url else { return "" }

        var baseCommand = "curl \(url.absoluteString)"
        if httpMethod == "HEAD" { baseCommand += " --head" }

        var command = [baseCommand]
        if let method = httpMethod, method != "GET", method != "HEAD" { command.append("-X \(method)") }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key):\(value)'")
            }
        }
        if let data = httpBody, let body = String(data: data, encoding: .utf8) { command.append("-d '\(body)'") }

        return command.joined(separator: " \\\n\t")
    }
}
