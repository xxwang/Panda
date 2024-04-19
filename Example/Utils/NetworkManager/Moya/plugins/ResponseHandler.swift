import Alamofire
import Moya
import Panda
import UIKit

class ResponseHandler: PluginType {
    init() {}

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        self.responseHandler(result, target: target)
    }
}

extension ResponseHandler {
    func responseHandler(_ result: Result<Response, MoyaError>, target: TargetType) {
        if case let .success(response) = result {
            guard let response = try? response.mapJSON(failsOnEmptyData: true) as? [String: Any],
                  let code = response["code"] as? String
            else {
                return
            }

            // 根据状态码处理相关逻辑
            if code == "" {}
        }
    }
}
