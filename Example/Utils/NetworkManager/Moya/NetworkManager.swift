import Foundation
import Panda

struct NetworkManager {
    private init() {}
}

extension NetworkManager {
    static func requestDemo() {
        Requester.request(target: .requestDemo1, model: PDModel.self) { response in
            if response.isOk {
                let resModel = response.data
            } else {
                // response.code != 200
                Logger.error(response.message ?? "")
            }
        }
    }
}

extension NetworkManager {}
