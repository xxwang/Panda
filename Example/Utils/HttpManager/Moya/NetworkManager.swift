//
//  NetworkManager.swift
//  Base-Swift-UIKit
//
//  Created by 奥尔良小短腿 on 2024/3/25.
//

//import Foundation
//import Moya
//import ObjectMapper
//
//// MARK: - NetworkResultCallback
//
//enum NetworkResultCallback {
//    /// 请求成功的回调
////    typealias Success = (_ result: Any) -> Void
//    typealias Success = (_ result: DataModel) -> Void
//    /// 请求失败的回调
//    typealias Failure = (_ error: MoyaError) -> Void
//    /// 上传/下载进度回调
//    typealias Progress = (_ progress: Double) -> Void
//    /// 下载完成回调
//    typealias Download = (_ filePath: String) -> Void
//}
//
//// MARK: - NetworkManager
//
//struct NetworkManager {
//    // MARK: Lifecycle
//
//    private init() {}
//
//    // MARK: Internal
//
//    /// 单例 Service Provider
//    static let provider = MoyaProvider<ServiceAPI>(plugins: [NetworkHandler()])
//}
//
//// MARK: - 数据请求
//
//extension NetworkManager {
//    /// 发送网络请求
//    /// - Parameters:
//    ///   - target: api
//    ///   - successBlock: 成功回调
//    ///   - failureBlock: 失败回调
//    static func request<T>(
//        target: ServiceAPI,
//        DataType: T.self,
//        successBlock: @escaping NetworkResultCallback.Success, // 成功回调
//        failureBlock: @escaping NetworkResultCallback.Failure // 失败回调
//    ) {
//        provider.request(target) { result in
//            switch result {
//            case let .success(moyaResponse):
//                self.provider.plugins
//                do {
////                    let response = try moyaResponse.mapJSON(failsOnEmptyData: true)
////                    successBlock(response)
//                    
//                    let response = try moyaResponse.mapJSON(failsOnEmptyData: true)
//                    let dataModel = Mapper<DataModel<DataType>>().map(JSONString: response)
//                    successBlock(response)
//                    
//                } catch {
//                    failureBlock(MoyaError.jsonMapping(moyaResponse))
//                }
//            case let .failure(error):
//                failureBlock(error)
//            }
//        }
//    }
//}
//
//// MARK: - 下载请求
//
//extension NetworkManager {
//    /// 发送下载请求
//    /// - Parameters:
//    ///   - target: api
//    ///   - progressBlock: 进度回调
//    ///   - successBlock: 成功回调
//    ///   - failureBlock: 失败回调
//    static func download(
//        target: ServiceAPI,
//        progressBlock: NetworkResultCallback.Progress?, // 进度
//        successBlock: @escaping NetworkResultCallback.Download, // 下载完成回调
//        failureBlock: @escaping NetworkResultCallback.Failure // 失败回调
//    ) {
//        provider.request(target, progress: { progress in
//            progressBlock?(progress.progress)
//        }) { result in
//            switch result {
//            case let .success(moyaResponse):
//                successBlock(target.localLocation.path)
//            case let .failure(error):
//                failureBlock(error)
//            }
//        }
//    }
//}
