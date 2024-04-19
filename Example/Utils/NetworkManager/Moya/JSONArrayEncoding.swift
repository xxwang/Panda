import Alamofire
import Foundation

// MARK: - 请求参数为Array的编码方式
struct JSONArrayEncoding {
    static let `default` = JSONArrayEncoding()
}

extension JSONArrayEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()

        guard let json = parameters?["jsonArray"] else {
            return request
        }

        let data = try JSONSerialization.data(withJSONObject: json, options: [])

        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        request.httpBody = data

        return request
    }
}

extension Array {
    /// 组成数组请求参数
    var arrayParams: [String: [Element]] {
        return ["jsonArray": self]
    }
}
