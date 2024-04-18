//
//  ServiceAPI.swift
//  Pets
//
//  Created by 王斌 on 2022/1/5.
//

 import Foundation
 import Moya

 enum ServiceAPI {
    case register(_ params: [String: Any]) // 注册
    case login(_ params: [String: Any]) // 登录
    case loveLibTCNDownload(_ params: [String: Any]) // 爱库文件下载
 }

 extension ServiceAPI: TargetType {
    var baseURL: URL {
//        return URL(string: AppContext.serverAddr)!
        return URL(string: "")!
    }

    var headers: [String: String]? {
        let headers = [
//            "authorization": AccountManager.current.authorization ?? "",
            "Content-Type": "application/json",
        ]
        return headers
    }

    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }

    var path: String {
        switch self {
        case .register: // 注册
            return "/account/register"
        case .login: // 登录
            return "/account/login"
        case let .loveLibTCNDownload(params): // 爱库文件下载
            let fileID = params["fileID"] ?? ""
            return "/libraries/\(fileID)/tcn"
        }
    }

    var method: Moya.Method {
        switch self {
        case .register: // 注册
            return .post
        case .login: // 登录
            return .post
        case .loveLibTCNDownload: // 爱库文件下载
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .register(params): // 注册
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .login(params): // 登录
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .loveLibTCNDownload: // 爱库文件下载
            return .downloadDestination(downloadDestination)
        }
    }
 }

// MARK: - 下载目录

 extension ServiceAPI {
    // 定义一个DownloadDestination
    private var downloadDestination: DownloadDestination {
        return { _, _ in (self.localLocation, .removePreviousFile) }
    }

    // 获取对应的资源文件本地存放路径
    var localLocation: URL {
        switch self {
        case let .loveLibTCNDownload(params):
            let fileID = params["fileID"] ?? ""
            return downloadDirURL.appendingPathComponent("\(fileID).zip")
        default:
            return "".toURL()!
        }
    }

    /// 文件目录URL
    private var downloadDirURL: URL {
        return "/loveLib".toURL()!
    }
 }
