//
//  ServiceAPI.swift
//  Pets
//
//  Created by 王斌 on 2022/1/5.
//

import Foundation
import Moya

enum ServiceAPI {
    case requestDemo1
    case requestDemo2(_ params: [String: Any])
    case uploadDemo(_ params: [String: Any])
    case downloadDemo(_ params: [String: Any])
}

//MARK: - 配置
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
            case .requestDemo2(let params):
                return .requestParameters(parameters: params, encoding: JSONArrayEncoding.default)
            case .uploadDemo(let params):
                var multipartFormDatas: [MultipartFormData] = []
                for (key, value) in params {
                    if let valueData = (value as? String)?.data(using: .utf8) {
                        let data = MultipartFormData(provider: .data(valueData), name: key)
                        multipartFormDatas.append(data)
                    }
                }
                return .uploadCompositeMultipart(multipartFormDatas, urlParameters: params)
                //                return .uploadMultipart(multipartFormDatas)
            case .downloadDemo(let params):
                return .downloadParameters(parameters: params, encoding: JSONEncoding.default, destination: self.downloadDestination)
                //                return .downloadDestination(self.downloadDestination)
        }
    }
}

// MARK: - 下载目录
extension ServiceAPI {
    /// 文件下载地址
    fileprivate var downloadDestination: DownloadDestination {
        return {(temporaryURL, response) in
            var filePath: String = ""
            switch self {
                case .downloadDemo(let params):
                    filePath = params["filePath"] as! String
                default:
                    filePath = ""
            }
            let destinationUrl = URL(filePath: filePath)
            return (destinationURL: destinationUrl, options: .removePreviousFile)
        }
    }
}
