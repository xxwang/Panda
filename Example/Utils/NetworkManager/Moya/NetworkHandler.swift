//
//  NetworkHandler.swift
//  Pets
//
//  Created by 王斌 on 2022/1/6.
//

 import Alamofire
 import Panda
 import Moya
 import UIKit

// MARK: - Moya插件

 class NetworkHandler: PluginType {
    init() {}

    /// 发送请求之前
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        if target.method == .get {
//            if case Moya.Task.requestParameters(parameters: let params, encoding: _) = target.task {
//                console.log("""
//
//                =================================== 请求参数开始 ===================================
//                请求路径:\(target.path)
//                \(params)
//                =================================== 请求参数结束 ===================================
//                """)
//            }
//        } else if target.method == .post {
//            guard let httpBody = request.httpBody else {
//                return request
//            }
//
//            guard let bodyStr = String(data: httpBody, encoding: .utf8) else {
//                return request
//            }
//
//            console.log("""
//
//            =================================== 请求参数开始 ===================================
//            请求路径:\(target.path)
//            \(bodyStr)
//            =================================== 请求参数结束 ===================================
//            """)
//        }

        return request
    }

    /// 开始发起请求
    func willSend(_: RequestType, target _: TargetType) {
//        if !common.isShowHUD {
//            common.showWaiting()
//        }
    }

    /// 进度
    func process(_ result: Result<Moya.Response, MoyaError>, target _: TargetType) -> Result<Moya.Response, MoyaError> {
        return result
    }

    // 收到响应
    func didReceive(_ result: Result<Response, MoyaError>, target _: TargetType) {
        // common.dismissHUD()

//        if case let .failure(err) = result { // 失败
//            console.log("""
//
//            =================================== 错误数据开始 ===================================
//            \(err.localizedDescription)
//            =================================== 错误数据结束 ===================================
//            """)
//        }
//
//        guard case let .success(response) = result else { // 失败
//            return
//        }
//
//        guard let dataStr = String(data: response.data, encoding: .utf8) else { // 响应数据转字符串
//            return
//        }
//
//        console.log("""
//
//        =================================== 响应数据开始 ===================================
//        \(dataStr)
//        =================================== 响应数据结束 ===================================
//        """)
//
//        guard let response = try? response.mapJSON(failsOnEmptyData: true) as? [String: Any] else { // 响应数据转字典
//            return
//        }
//
//        guard let code = response["code"] as? String else { // 根据状态码处理相关逻辑
//            return
//        }

        // TODO: - 登录失效或者在其它设置登录(做退出处理)
    }
 }
