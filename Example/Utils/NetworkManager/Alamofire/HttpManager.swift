//
//  HttpManager.swift
//  Base-Swift-UIKit
//
//  Created by 奥尔良小短腿 on 2024/3/25.
//

// import Alamofire
// import CoreTelephony
// import UIKit
//
// public class HttpManager: NSObject {
//
//    /// 单例
//    public static let `default`: HttpManager = {
//        let manager = HttpManager()
//        return manager
//    }()
//
//    override private init() {
//        super.init()
//        networkChanged(nil)
//    }
//
//    /// 请求时间
//    public fileprivate(set) var elapsedTime: TimeInterval?
//    /// 是否是json请求
//    static var isJSON: Bool = true
//
//    /// 通用请求的Manager
//    static let defaultManager: Session = {
//        var defHeaders = Alamofire.Session.default.session.configuration.httpAdditionalHeaders ?? [:]
//        let defConf = URLSessionConfiguration.default
//        defConf.timeoutIntervalForRequest = 30
//        defConf.httpAdditionalHeaders = defHeaders
//        return Alamofire.Session(configuration: defConf)
//    }()
//
//    /// 后台请求的Manager
//    static let backgroundManager: Session = {
//        let defHeaders = Alamofire.Session.default.session.configuration.httpAdditionalHeaders ?? [:]
//        let backgroundConf = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
//        backgroundConf.httpAdditionalHeaders = defHeaders
//        return Alamofire.Session(configuration: backgroundConf)
//    }()
//
//    /// 私有会话的Manager
//    static let ephemeralManager: Session = {
//        let defHeaders = Alamofire.Session.default.session.configuration.httpAdditionalHeaders ?? [:]
//        let ephemeralConf = URLSessionConfiguration.ephemeral
//        ephemeralConf.timeoutIntervalForRequest = 30
//        ephemeralConf.httpAdditionalHeaders = defHeaders
//        return Alamofire.Session(configuration: ephemeralConf)
//    }()
//
//    /// 后台任务完成处理
//    static var backgroundCompletionHandler: (() -> Void)? {
//        get {
//            return backgroundManager.backgroundCompletionHandler
//            backgroundManager.delegate = self
//        }
//        set {
//            backgroundManager.backgroundCompletionHandler = newValue
//        }
//    }
//
//    /// 网络状态(可能存在崩溃问题)
//    static var checkNetwork: (status: NetworkStatuses, strength: Int) {
//        guard UIApplication.shared.windows.first != nil else {
//            return (NetworkStatuses.NetworkStatusNone, 0)
//        }
//
//        guard let state = UIDevice.current.cz.isPhoneX ? networkStatesPhoneX : networkStates else {
////            window.noticeOnlyText("status 获取错误")
//            common.showError("status 获取错误")
//            return (NetworkStatuses.NetworkStatusNone, 0)
//        }
//        if state.status == .NetworkStatusNone {
////            window.noticeOnlyText("当前无网络，请检查您的网络")
//            common.showInfo("当前无网络，请检查您的网络")
//        }
//        return state
//    }
//
//    /// 官方推荐
//    public enum ConnectionType {
//        case unknown
//        case notReachable
//        case ethernetOrWiFi
//        case cellular
//    }
//
//    fileprivate(set) var currentStatus: ConnectionType = .unknown
//    func networkChanged(_ changed: ((ConnectionType) -> Void)?) {
//        let manager = NetworkReachabilityManager.default
//        currentStatus = (manager?.isReachable ?? false) ? .cellular : .unknown
//        manager?.startListening(onUpdatePerforming: { status in
//            switch status {
//                case .unknown:
//                    CZLog("未知网络")
//                    self.currentStatus = .unknown
//                case .notReachable:
//                    CZLog("无网络")
////                    self.cz.currentWindow?.noticeOnlyText("当前无网络，请检查您的网络")
//                    common.showInfo("当前无网络，请检查您的网络")
//                    self.currentStatus = .notReachable
//                case .reachable(.ethernetOrWiFi):
//                    CZLog("wifi")
//                    self.currentStatus = .ethernetOrWiFi
//                case .reachable(.cellular):
//                    CZLog("蜂窝网络")
//                    self.currentStatus = .cellular
//            }
//            NotificationCenter.default.post(name: HttpManager.networkChangedNotification, object: self.currentStatus)
//            changed?(self.currentStatus)
//        })
//    }
//
//    /// 检测是否开启联网
//    static func networkPermission(action: @escaping ((Bool) -> Void)) {
//        let cellularData = CTCellularData()
//        cellularData.cellularDataRestrictionDidUpdateNotifier = { state in
//            if state == CTCellularDataRestrictedState.restrictedStateUnknown || state == CTCellularDataRestrictedState.notRestricted {
//                action(false)
//            } else {
//                action(true)
//            }
//        }
//        let state = cellularData.restrictedState
//        if state == CTCellularDataRestrictedState.restrictedStateUnknown || state == CTCellularDataRestrictedState.notRestricted {
//            action(false)
//        } else {
//            action(true)
//        }
//    }
//
//    static let networkChangedNotification = Notification.Name("HttpManager_networkChangedNotification")
// }
//
//// MARK: - 通用 请求 下载 上传 方法
//
// public extension HttpManager {
//    private static func getToken(headers: HTTPHeaders? = nil) -> HTTPHeaders {
//        var headers: HTTPHeaders = headers ?? [:]
//
//        let token = AccountManager.current.authorization ?? ""
//        if !token.isEmpty {
//            if headers.dictionary.keys.first(where: {$0 == "Authorization"}) == nil {
//                headers["Authorization"] = token
//            }
//        }
//        return headers
//    }
//
//    /// 通用请求方法
//    ///
//    /// - Parameters:
//    ///   - type: 请求方式
//    ///   - urlString: 请求网址
//    ///   - parameters: 请求参数
//    ///   - headers: header 信息
//    ///   - succeed: 请求成功回调
//    ///   - failure: 请求失败回调
//    /// - error: 错误信息
//    static func request(_ type: HTTPMethod, urlString: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil, succeed: @escaping ((_ result: Any?, _ error: Error?) -> Swift.Void), failure: @escaping (([String: Any]) -> Swift.Void)) {
//        if HttpManager.default.currentStatus == .notReachable {
//            return
//        }
//
//        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
//        let headers = getToken(headers: headers != nil ? HTTPHeaders(headers!) : nil)
////        let encoding: ParameterEncoding = isJSON ? JSONEncoding.default : URLEncoding.default
//        let encoding: ParameterEncoding = type == .get ? URLEncoding.queryString : URLEncoding.default
//
//        HttpManager.defaultManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
//            CZLog("methhod: \(method), urlString: \(urlString), parameter: \(parameters?.description ?? "[]"), \(response.timeline)")
//            if response.result.isFailure {
//                if let res = response.response, let data = response.data {
//                    var text = String(data: data, encoding: .utf8) ?? ""
//                    if res.statusCode == 401 {
//                        text = "登录状态校验失败"
//                    }
//                    CZLog(res.statusCode, text)
//                    failure(["code": res.statusCode, "message": text])
//                } else {
//                    failure(["code": 500, "message": response.result.error?.localizedDescription ?? response.result.error.debugDescription])
//                }
//                return
//            }
//            if response.result.isSuccess {
//                guard let result = response.result.value else {
//                    succeed(nil, response.result.error)
//                    return
//                }
//                succeed(result, nil)
//            }
//        }
//    }
//
//    /// 通用下载方法
//    ///
//    /// - Parameters:
//    ///   - method: 请求方式
//    ///   - urlString: 请求地址
//    ///   - parameters: 请求参数
//    ///   - folderPath: 下载的文件路径
//    ///   - completed: 下载后的文件路径闭包
//    static func download(_ method: HTTPMethod = .get, urlString: String, parameters: [String: Any]? = nil, folderPath: String = "", completed: ((_ filePath: String) -> Swift.Void)?, uploadProgress: ((_ progress: Double) -> Swift.Void)? = nil) {
//        // 指定下载路径（文件名不变）
//        let destination: DownloadRequest.DownloadFileDestination = { _, response in
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            var fileURL: URL!
//            if !folderPath.isEmpty {
//                fileURL = documentsURL.appendingPathComponent(folderPath, isDirectory: true)
//            }
//            fileURL = fileURL.appendingPathComponent(response.suggestedFilename!)
//            // 两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//
//        // 开始下载
//        HttpManager.backgroundManager.download(urlString, method: method, parameters: parameters, to: destination)
//            .downloadProgress { progress in
//                uploadProgress?(progress.fractionCompleted)
//                print("当前进度: \(progress.fractionCompleted)")
//            }
//            .response { response in
//                // let image = UIImage(contentsOfFile: filePath)
//                if let filePath = response.destinationURL?.path {
//                    completed?(filePath)
//                }
//            }
//    }
//
//    /// 上传本地文件方法
//    ///
//    /// - Parameters:
//    ///   - url: 上传地址
//    ///   - fileURL: 上传文件
//    ///   - type: 文件类型，默认`video`
//    ///   - fileName: 文件名
//    ///   - params: 额外参数
//    static func upload(_ url: String, fileURL: URL, type: UploadType = .video, fileName: String? = nil, params: [String: String]? = nil, success: @escaping (_ response: [String: AnyObject]) -> Void, failture: @escaping (_ error: Error) -> Void, uploadProgress: ((_ progress: Double) -> Void)? = nil) {
//        upload(url, files: [(value: fileURL, type: type, name: nil, fileName: fileName)], params: params, success: success, failture: failture, uploadProgress: uploadProgress)
//    }
//
//    /// 上传本地data方法
//    ///
//    /// - Parameters:
//    ///   - url: 上传地址
//    ///   - data: 上传文件
//    ///   - type: 文件类型，默认`video`
//    ///   - fileName: 文件名
//    ///   - params: 额外参数
//    static func upload(_ url: String, data: Data, type: UploadType = .video, fileName: String? = nil, params: [String: String]? = nil, success: @escaping (_ response: [String: AnyObject]) -> Void, failture: @escaping (_ error: Error) -> Void, uploadProgress: ((_ progress: Double) -> Void)? = nil) {
//        upload(url, files: [(value: data, type: type, name: nil, fileName: fileName)], params: params, success: success, failture: failture, uploadProgress: uploadProgress)
//    }
//
//    /// 上传图片
//    ///
//    /// - Parameters:
//    ///   - url: 上传地址
//    ///   - images: 需要上传的图片的元组数组[(image, name)]
//    ///   - params: 上传参数
//    static func upload(_ url: String, images: [(UIImage, String)], params: [String: String]? = nil, success: @escaping (_ response: [String: AnyObject]) -> Void, failture: @escaping (_ error: Error) -> Void, uploadProgress: ((_ progress: Double) -> Void)? = nil) {
//        var arr: [(value: Any, type: UploadType?, name: String?, fileName: String?)] = []
//        for (image, name) in images {
//            arr.append((value: image, type: .image, name: nil, fileName: name))
//        }
//        upload(url, files: arr, params: params, success: success, failture: failture, uploadProgress: uploadProgress)
//    }
//
//    /// 通用上传方法
//    ///
//    /// - Parameters:
//    ///   - urlStr: 上传地址
//    ///   - files: 元组数组[(`上传文件`, `文件类型，默认video`,  `上传参数名`, `文件名`)]
//    ///   - params: 额外参数
//    ///   - success: 成功回调
//    ///   - failture: 失败回调
//    ///   - uploadProgress: 上传进度
//    static func upload(_ urlStr: String, files: [(value: Any, type: UploadType?, name: String?, fileName: String?)], params: [String: String]? = nil, success: @escaping (_ response: [String: AnyObject]) -> Swift.Void, failture: @escaping (_ error: Error) -> Swift.Void, uploadProgress: ((_ progress: Double) -> Swift.Void)? = nil) {
//        let headers = getToken(headers: nil)
//        HttpManager.backgroundManager.upload(multipartFormData: { data in
//            for (value, type, name, fileName) in files {
//                let type = type != nil ? type! : .video
//                let name = name != nil ? name! : "file"
//                if let url = value as? URL {
//                    let fileName = fileName != nil ? fileName! : url.lastPathComponent
//                    data.append(url, withName: name, fileName: fileName, mimeType: type.rawValue)
//                }
//                if let _data = value as? Data {
//                    let fileName = fileName != nil ? fileName! : "data"
//                    data.append(_data, withName: name, fileName: fileName, mimeType: type.rawValue)
//                }
//                if let image = value as? UIImage {
//                    let fileName = fileName != nil ? "\(fileName!).jpeg" : "\(name).jpeg"
//                    let imageData = image.jpegData(compressionQuality: 1)!
//                    data.append(imageData, withName: name, fileName: fileName, mimeType: type.rawValue)
//                }
//            }
//            for (key, value) in params ?? [:] {
//                data.append(value.data(using: .utf8)!, withName: key)
//            }
//        }, to: urlStr, method: .post, headers: headers) { encodingResult in
//            switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        if let value = response.result.value as? [String: AnyObject] {
//                            success(value)
//                        }
//                        guard let data = response.data else {
//                            return
//                        }
//                        let utf8Text = String(data: data, encoding: .utf8)
//                        print("return data" + utf8Text!)
//                    }
//                    .uploadProgress { progress in
//                        uploadProgress?(progress.fractionCompleted)
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                    }
//                case .failure(let encodingError):
//                    failture(encodingError)
//            }
//        }
//    }
// }
//
// public enum UploadType: String {
//    case video = "video/mp4"
//    case pdf = "application/pdf"
//    case image = "image/*"
// }
//
//// MARK: - 原生请求方法
//
// public extension HttpManager {
//    /// 原生请求方法
//    ///
//    /// - Parameters:
//    ///   - method: 请求方式
//    ///   - urlString: 请求地址
//    ///   - parameters: 请求参数
//    ///   - complete: 完成回调
//    static func doHttpRequest(_ method: HTTPMethod, urlString: String, parameters: [String: String], complete: @escaping (_ result: String?, _ error: NSError?) -> Void) {
//        guard let url = URL(string: urlString) else {
//            return
//        }
//        let request = NSMutableURLRequest(url: url)
//        let headers = [
//            "application/x-www-form-urlencoded": "charset=utf-8",
//            "Content-Type": "application/json"
//        ]
//        request.httpMethod = method == .get ? "GET" : "POST"
//        request.timeoutInterval = 8
//        request.allHTTPHeaderFields = headers
//
//        if method == .post {
//            let postStr = parseParams(parameters)
//            request.httpBody = postStr.data(using: .utf8)
//        }
//        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
//            DispatchQueue.main.async {
//                if let err = error {
//                    complete(nil, err as NSError?)
//                } else if let httpResponse = response as? HTTPURLResponse {
//                    if httpResponse.statusCode == 200 {
//                        let decodedString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                        complete(decodedString as String?, nil)
//                    } else {
//                        complete(nil, nil)
//                    }
//                }
//            }
//        }.resume()
//    }
//
//    static func parseParams(_ params: [String: String]) -> String {
//        var result = ""
//        for (key, value) in params {
//            result += "\(key)=\(value)&"
//        }
//        return result
//    }
//
//    /// 请求data数据
//    static func requestData(_ url: String, completed: @escaping ((Data?) -> Void)) {
//        guard let url = URL(string: url) else {
//            completed(nil)
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                if let _ = error {
//                    completed(nil)
//                    return
//                }
//                if let httpResponse = response as? HTTPURLResponse {
//                    if httpResponse.statusCode == 200 {
//                        completed(data)
//                    } else {
//                        completed(nil)
//                    }
//                }
//            }
//        }.resume()
//    }
// }
//
//// MARK: - 文件操作
//
// public extension HttpManager {
//    /// 删除指定的文件
//    ///
//    /// - Parameter fileName: documentDirectory 下的文件路径
//    static func deleteFile(_ fileName: String) {
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        try? FileManager.default.removeItem(atPath: documentsURL.path + "/\(fileName)")
//    }
//
//    /// 清空指定文件夹
//    ///
//    /// - Parameter folderPath: 文件夹名称
//    /// - Parameter root: 以document为根目录
//    static func clearFolder(_ folderPath: String = "", root: FileManager.SearchPathDirectory = .documentDirectory) {
//        var fileURL = FileManager.default.urls(for: root, in: .userDomainMask)[0]
//        if !folderPath.isEmpty {
//            fileURL = fileURL.appendingPathComponent(folderPath)
//        }
//        let fileArray = FileManager.default.subpaths(atPath: fileURL.path)
//        for fn in fileArray! {
//            try? FileManager.default.removeItem(atPath: folderPath + "/\(fn)")
//        }
//    }
//
//    /// 文件夹大小
//    /// - Parameters:
//    ///   - folderPath: 文件夹名称
//    ///   - root: 以Cache为根目录
//    /// - Returns: 总大小
//    static func sizeFolder(_ folderPath: String = "", root: FileManager.SearchPathDirectory = .cachesDirectory) -> (Int64, String) {
//        let cacheURL = FileManager.default.urls(for: root, in: .userDomainMask)[0]
//        let folder = folderPath.isEmpty ? "" : "/\(folderPath)"
//        let files = FileManager.default.subpaths(atPath: cacheURL.path + folder)
//
//        var folderSize: Int64 = 0
//        for file in files ?? [] {
//            folderSize += fileSize(at: "\(cacheURL.path)\(folder)/\(file)").0
//        }
//
//        return (folderSize, folderSize.cz.convertBytes)
//    }
//
//    /// 文件大小
//    /// - Parameter path: 文件路径
//    /// - Returns: (字节, 描述)
//    static func fileSize(at path: String) -> (Int64, String) {
//        if FileManager.default.fileExists(atPath: path) {
//            let attr = try! FileManager.default.attributesOfItem(atPath: path)
//            let byte = attr[FileAttributeKey.size] as! Double
//            let desc = ByteCountFormatter.string(fromByteCount: Int64(byte), countStyle: ByteCountFormatter.CountStyle.file)
//            return (Int64(byte), desc)
//        }
//        return (0, "")
//    }
//
//    /// 文件大小
//    /// - Parameter url: 文件地址
//    /// - Returns: 字节
//    static func dataSize(_ url: URL) -> Int64 {
//        if let data = try? Data(contentsOf: url) {
//            return Int64(data.count)
//        }
//        return 0
//    }
//
//    /// 文件内容URL
//    ///
//    /// - Parameter folderPath: 下载文件路径(以document为根目录)
//    /// - Returns: 文件内容URL
//    static func folderContent(folderPath: String = "") -> [URL]? {
//        var fileURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        if !folderPath.isEmpty {
//            fileURL = fileURL.appendingPathComponent(folderPath)
//        }
//        do {
//            return try FileManager.default.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//        } catch {
//            return nil
//        }
//    }
// }
//
//// MARK: - 版本检测
//
// public extension HttpManager {
//    /// 检查AppStore版本
//    ///
//    /// - Parameters:
//    ///   - appId: appId: 应用id (id1259654773)
//    ///   - complete: 完成回调
//    static func checkVersion(appId: String, complete: @escaping ((_ newVersion: Bool, _ result: [String: String]?) -> Swift.Void)) {
//        let url = "http://itunes.apple.com/lookup?id=\(appId)"
//        guard let appMsg = try? String(contentsOf: URL(string: url)!, encoding: .utf8) else {
//            return complete(false, nil)
//        }
//        guard let result = appMsg.cz.jsonToDict, let results = result["results"] as? [[String: Any]], let info = results.first else {
//            return complete(false, nil)
//        }
//        let version = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String).split(separator: ".").map { Int($0)! }
//        var currentVersion = 0
//        for (idx, version) in version.enumerated() {
//            if idx == 0 { currentVersion = version * 100000 }
//            else if idx == 1 { currentVersion += version * 1000 }
//            else { currentVersion += version }
//        }
//
//        let app_version = (info["version"] as! String).split(separator: ".").map { Int($0)! }
//        var appVersion = 0
//        for (idx, version) in app_version.enumerated() {
//            if idx == 0 { appVersion = version * 100000 }
//            else if idx == 1 { appVersion += version * 1000 }
//            else { appVersion += version }
//        }
//
//        let newInfo = ["trackViewUrl": info["trackViewUrl"] as? String ?? "", "version": info["version"] as? String ?? "", "releaseNotes": info["releaseNotes"] as? String ?? ""]
//        // appStore版本高于本地版本
//        complete(appVersion > currentVersion, newInfo)
//    }
// }
//
//// MARK: -  网络类型和强度
//
// public enum NetworkStatuses {
//    case NetworkStatusNone // 没有网络
//    case NetworkStatus2G // 2G
//    case NetworkStatus3G // 3G
//    case NetworkStatus4G // 4G
//    case NetworkStatusWiFi // WiFi
//    case NetworkStatuHotspot // Hotspot
// }
//
// public extension HttpManager {
//    /// 获取网络状态
//    static var networkStates: (status: NetworkStatuses, strength: Int)? {
//        if UIDevice.current.cz.isPhoneX { return nil }
//        guard let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? NSObject else { return nil }
//        guard let foregroundView = statusBarView.value(forKey: "foregroundView") as? UIView else { return nil }
//        let subviews = foregroundView.subviews
//
//        var status = NetworkStatuses.NetworkStatusNone
//        var signalStrength = 0
//        for child in subviews {
//            if child.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
//                // 获取到状态栏码
//                guard let networkType = child.value(forKey: "dataNetworkType") as? Int else { return nil }
//                switch networkType {
//                    case 0:
//                        status = .NetworkStatusNone
//                    case 1:
//                        status = .NetworkStatus2G
//                    case 2:
//                        status = .NetworkStatus3G
//                    case 3:
//                        status = .NetworkStatus4G
//                    case 5:
//                        status = .NetworkStatusWiFi
//                        guard let wifi = child.value(forKey: "wifiStrengthBars") as? Int else { return nil } // [0-3]
//                        signalStrength = wifi
//                    case 6:
//                        status = .NetworkStatuHotspot
//                    default:
//                        break
//                }
//            }
//            if child.isKind(of: NSClassFromString("UIStatusBarSignalStrengthItemView")!) {
//                guard let signal = child.value(forKey: "signalStrengthBars") as? Int else { return nil } // [0-4]
//                signalStrength = signal
//            }
//        }
//
//        return (status, signalStrength)
//    }
//
//    static var networkStatesPhoneX: (status: NetworkStatuses, strength: Int)? {
//        if !UIDevice.current.cz.isPhoneX { return nil }
//        guard let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? NSObject,
//              let statusBar = statusBarView.value(forKey: "statusBar") as? UIView,
//              let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView
//        else {
//            return nil
//        }
//        let subViews = foregroundView.subviews[2].subviews
//
//        var status = NetworkStatuses.NetworkStatusNone
//        var signalStrength = 0
//        for child in subViews {
//            if child.isKind(of: NSClassFromString("_UIStatusBarWifiSignalView")!) {
//                guard let wifi = child.value(forKey: "_numberOfActiveBars") as? Int else { return nil } // [0-3]
//                signalStrength = wifi
//                status = .NetworkStatusWiFi
//            }
//            if child.isKind(of: NSClassFromString("_UIStatusBarStringView")!) {
//                guard let type = child.value(forKey: "originalText") as? String else { return nil }
//                switch type {
//                    case "4G":
//                        status = .NetworkStatus4G
//                    case "3G":
//                        status = .NetworkStatus3G
//                    case "2G":
//                        status = .NetworkStatus2G
//                    default:
//                        status = .NetworkStatusNone
//                }
//            }
//        }
//
//        return (status, signalStrength)
//    }
// }
