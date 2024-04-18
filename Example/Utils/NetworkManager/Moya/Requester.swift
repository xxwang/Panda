//
//  Requester.swift
//  Example
//
//  Created by apple on 2024/4/18.
//

import Foundation
import Moya
import ObjectMapper

struct Requester {
    /// 单例 Service Provider
    static let provider = MoyaProvider<ServiceAPI>(plugins: [NetworkHandler()])
    private init() {}
}

// MARK: - 数据请求
extension Requester {
    
    /// 发送网络请求
    /// - Parameters:
    ///   - target: API枚举
    ///   - model: 数据模型, 需要遵守`Mappable`协议
    ///   - responseClosure: 结果回调
    static func request<T: Mappable>(
        target: ServiceAPI,
        model: T.Type = PDModel.self,
        responseClosure: @escaping (_ response: CustomResponse<T>) -> Void
    ) {
        self.provider.request(target) { result in
            
            var customResponse: CustomResponse<T>
            switch result {
                case let .success(response):
                    do {
                        let response = try response.mapJSON(failsOnEmptyData: true)
                        let responseDict = response as? [String: Any] ?? [:]
                        customResponse = Mapper<CustomResponse<T>>().map(JSON: responseDict)!
                    } catch {
                        let moyaError = MoyaError.jsonMapping(response)
                        customResponse = CustomResponse()
                        customResponse.code = moyaError.response?.statusCode ?? 0
                        customResponse.message = moyaError.localizedDescription
                    }
                case let .failure(error):
                    customResponse = CustomResponse()
                    customResponse.message = error.localizedDescription
            }
            
            if case .success(_) = result {
                customResponse.isOk = true
            } else {
                customResponse.isOk = false
            }
            responseClosure(customResponse)
        }
    }

}

// MARK: - 下载请求
extension Requester {

    /// 发送下载请求
    /// - Parameters:
    ///   - target: API枚举
    ///   - progress: 下载进度
    ///   - responseClosure: 结果回调
    static func download(
        target: ServiceAPI,
        progress: @escaping ((_ progress: Double) -> Void)? = nil,
        responseClosure: @escaping (_ response: CustomResponse<T>) -> Void
    ) {
        self.provider.request(target, progress: { progress in
            progress?(progress.progress)
        }) { result in
            
            var customResponse: CustomResponse<String> = CustomResponse()
            switch result {
                case let .success(moyaResponse):
                    customResponse.data = target.localLocation.path
                case let .failure(error):
                    customResponse.message = error.localizedDescription
            }
            
            if case .success(_) = result {
                customResponse.isOk = true
            } else {
                customResponse.isOk = false
            }
            responseClosure(customResponse)
        }
    }
}

// MARK: - 上传请求
extension Requester {

    /// 发送上传请求
    /// - Parameters:
    ///   - target: API枚举
    ///   - model: 数据模型, 需要遵守`Mappable`协议
    ///   - progress: 上传进度
    ///   - responseClosure: 结果回调
    static func upload<T: Mappable>(
        target: ServiceAPI,
        model: T.Type = PDModel.self,
        progress: @escaping ((_ progress: Double) -> Void)? = nil,
        responseClosure: @escaping (_ response: CustomResponse<T>) -> Void
    ) {
        var customResponse: CustomResponse<T>
        switch result {
            case let .success(response):
                do {
                    let response = try response.mapJSON(failsOnEmptyData: true)
                    let responseDict = response as? [String: Any] ?? [:]
                    customResponse = Mapper<CustomResponse<T>>().map(JSON: responseDict)!
                } catch {
                    let moyaError = MoyaError.jsonMapping(response)
                    customResponse = CustomResponse()
                    customResponse.code = moyaError.response?.statusCode ?? 0
                    customResponse.message = moyaError.localizedDescription
                }
            case let .failure(error):
                customResponse = CustomResponse()
                customResponse.message = error.localizedDescription
        }
        
        if case .success(_) = result {
            customResponse.isOk = true
        } else {
            customResponse.isOk = false
        }
        responseClosure(customResponse)
    }
}
