import Foundation
import Moya

enum ServiceAPI {
    case requestDemo1
    case requestDemo2(_ params: [String: Any])
    case uploadDemo(_ params: [String: Any])
    case downloadDemo(_ params: [String: Any])
}

// MARK: - 配置
extension ServiceAPI {
    var baseURL: URL {
        return URL(string: "")!
    }

    var headers: [String: String]? {
        let headers = [
            "authorization": "",
            "Content-Type": "application/json",
        ]
        return headers
    }

    var validationType: ValidationType {
        return .none
    }

    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
}

extension ServiceAPI: TargetType {
    var path: String {
        switch self {
        case .requestDemo1:
            return ""
        case .requestDemo2:
            return ""
        case .uploadDemo:
            return ""
        case .downloadDemo:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .requestDemo1:
            return .post
        case .requestDemo2:
            return .post
        case .uploadDemo:
            return .post
        case .downloadDemo:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .requestDemo1:
            return .requestPlain
        case let .requestDemo2(params):
            return .requestParameters(parameters: params, encoding: JSONArrayEncoding.default)
        case let .uploadDemo(params):
            var multipartFormDatas: [MultipartFormData] = []
            for (key, value) in params {
                if let valueData = (value as? String)?.data(using: .utf8) {
                    let data = MultipartFormData(provider: .data(valueData), name: key)
                    multipartFormDatas.append(data)
                }
            }
            return .uploadCompositeMultipart(multipartFormDatas, urlParameters: params)
        //                return .uploadMultipart(multipartFormDatas)
        case let .downloadDemo(params):
            return .downloadParameters(parameters: params, encoding: JSONEncoding.default, destination: self.downloadDestination)
            //                return .downloadDestination(self.downloadDestination)
        }
    }
}

// MARK: - 下载
extension ServiceAPI {
    var downloadDestination: DownloadDestination {
        return { temporaryURL, response in
            let destinationUrl = URL(filePath: self.filePath)
            return (destinationURL: destinationUrl, options: .removePreviousFile)
        }
    }

    var filePath: String {
        switch self {
        case .downloadDemo:
            return ""
        default:
            return ""
        }
    }
}
