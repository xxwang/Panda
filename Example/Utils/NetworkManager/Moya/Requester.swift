import Foundation
import Moya
import ObjectMapper
import Panda

struct Requester {
    fileprivate static let provider = MoyaProvider<ServiceAPI>(plugins: [
        RequestLogger(),
        ResponseHandler(),
    ])

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
        model: T.Type,
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

            if case .success = result {
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
    ///   - model: 数据模型, 需要遵守`Mappable`协议
    ///   - progressClosure: 下载进度
    ///   - responseClosure: 结果回调
    static func download<T: Mappable>(
        target: ServiceAPI,
        model: T.Type = DownloadResult.self,
        progressClosure: ((_ progress: Double) -> Void)? = nil,
        completionClosure: @escaping (_ response: CustomResponse<T>) -> Void
    ) {
        self.provider.request(target) { progress in
            progressClosure?(progress.progress)
        } completion: { result in
            let customResponse: CustomResponse<T> = CustomResponse()
            switch result {
            case let .success(response):
                let resData = response.data
                Logger.debug(resData)

                let data = DownloadResult()
                data.filePath = target.filePath
                customResponse.data = data as? T
            case let .failure(error):
                customResponse.message = error.localizedDescription
            }

            if case .success = result {
                customResponse.isOk = true
            } else {
                customResponse.isOk = false
            }
            completionClosure(customResponse)
        }
    }
}

// MARK: - 上传请求
extension Requester {
    /// 发送上传请求
    /// - Parameters:
    ///   - target: API枚举
    ///   - model: 数据模型, 需要遵守`Mappable`协议
    ///   - progressClosure: 上传进度
    ///   - responseClosure: 结果回调
    static func upload<T: Mappable>(
        target: ServiceAPI,
        model: T.Type,
        progressClosure: ((_ progress: Double) -> Void)? = nil,
        completionClosure: @escaping (_ response: CustomResponse<T>) -> Void
    ) {
        self.provider.request(target) { progress in
            progressClosure?(progress.progress)
        } completion: { result in
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

            if case .success = result {
                customResponse.isOk = true
            } else {
                customResponse.isOk = false
            }
            completionClosure(customResponse)
        }
    }
}
