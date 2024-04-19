//
//  RequestLogger.swift
//  Pets
//
//  Created by 王斌 on 2022/1/6.
//

import Alamofire
import Panda
import Moya
import UIKit

// MARK: - Moya插件
class RequestLogger: PluginType {
    init() {}
    
    /// 发送请求之前
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return self.requestHandler(request, target: target)
    }
    
    /// 开始发起请求
    func willSend(_ request: RequestType, target: TargetType) {}
    
    /// 进度
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
    
    /// 收到响应
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        self.responseHandler(result, target: target)
    }
}

extension RequestLogger {
    
    func requestHandler(_ request: URLRequest, target: TargetType) -> URLRequest {
        if target.method == .get {
            if case Moya.Task.requestParameters(parameters: let params, encoding: _) = target.task {
                Logger.info("""
                ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️ -请求参数开始- ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️
                请求路径::\(target.path)
                请求参数::\(params)
                ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️ -请求参数结束- ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️
                """)
            }
        } else if target.method == .post {
            guard let httpBody = request.httpBody else {
                return request
            }
            
            guard let bodyStr = String(data: httpBody, encoding: .utf8) else {
                return request
            }
            
            Logger.info("""
            ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️ -请求参数开始- ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️
            请求路径::\(target.path)
            请求参数::\(bodyStr)
            ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️ -请求参数结束- ☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️☘️
            """)
        }
        return request
    }
}

extension RequestLogger {
    func responseHandler(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        switch result {
            case .success(let response):
                guard let dataStr = String(data: response.data, encoding: .utf8) else { // 响应数据转字符串
                    return
                }
                
                Logger.success("""
                ✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅ -响应数据开始- ✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
                \(dataStr)
                ✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅ -响应数据结束- ✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅
                """)
                
                guard let response = try? response.mapJSON(failsOnEmptyData: true) as? [String: Any],
                      let code = response["code"] as? String else { // 响应数据转字典
                    return
                }
                
                // 根据状态码处理相关逻辑
                if code == "" {
                    
                }
                
                // TODO: - 登录失效或者在其它设置登录(做退出处理)
            case .failure(let error):
                Logger.error("""
                ❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌ -错误数据开始- ❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌
                \(error.localizedDescription)
                ❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌ -错误数据结束- ❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌
                """)
        }
    }
}
