//
//  HttpDownloadManager.swift
//  Base-Swift-UIKit
//
//  Created by 奥尔良小短腿 on 2024/3/25.
//

// import Alamofire
// import UIKit
//
//// MARK: - 批量下载
//
// public class HttpDownloadManager: NSObject {
//    fileprivate var completed: ((_ filePath: String) -> ())?
//    fileprivate var failure: ((_ error: Error) -> ())?
//    fileprivate var progress: ((_ progress: Progress) -> ())?
//    /// 用于停止时，保存已下载部分
//    fileprivate var resumeData: Data?
//    /// 当前下载请求
//    public var downloadRequest: DownloadRequest?
//    /// 当前下载请求地址 (未经过urlEncoded编码)
//    public var urlString: String?
//    /// 下载状态
//    public enum Status: Int {
//        case loading, running, suspended, failure, completed
//    }
//
//    /// 当前任务下载状态
//    public var status: Status = .loading
//    /// 下载文件路径(以document为根目录)
//    public var folderPath: String = ""
//
//    /// 当前下载模型
//    fileprivate var currentModel: Any?
//    public func setCurrentModel<T>(_ model: T) {
//        currentModel = model
//    }
//
//    public func getCurrentModel<T>(_ type: T.Type) -> T? {
//        if let model = currentModel as? T {
//            return model
//        }
//        return nil
//    }
//
//    /// 开始下载/继续下载
//    /// - Parameter urlString: 下载地址
//    /// - Parameter folderPath: 下载文件路径
//    /// - Parameter directory: 下载目录 默认`document`
//    @discardableResult
//    public func downloadStart(_ urlString: String, folderPath: String = "", directory: FileManager.SearchPathDirectory = .documentDirectory) -> Self {
//        if NetworkManager.default.currentStatus == .notReachable {
//            self.status = .failure
//            self.failure?(NSError(domain: "do not have network", code: 300, userInfo: nil))
//            return self
//        }
//        // 指定下载路径（文件名不变）
//        let destination: DownloadRequest.DownloadFileDestination = { _, response in
//            var fileURL = FileManager.default.urls(for: directory, in: .userDomainMask)[0]
//            if !folderPath.isEmpty {
//                fileURL = fileURL.appendingPathComponent(folderPath)
//            }
//            fileURL = fileURL.appendingPathComponent(response.suggestedFilename!)
//            // 两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//
//        self.folderPath = folderPath
//        if let resumeData = self.resumeData { // 恢复下载
//            downloadRequest = NetworkManager.backgroundManager.download(resumingWith: resumeData, to: destination)
//        } else { // 开始下载
//            downloadRequest = NetworkManager.backgroundManager.download(urlString.cz.urlEncoded, to: destination)
//            self.urlString = urlString
//        }
//        downloadRequest?.downloadProgress { [weak self] progress in
//            guard let this = self else {
//                return CZLog("下载任务未结束就销毁了manager对象")
//            }
//            this.downloadRequest?.parseSpeed()
//            this.status = .running
//            this.progress?(progress)
//        }
//        .responseData(completionHandler: { [weak self] response in
//            guard let this = self else {
//                return CZLog("下载任务未结束就销毁了manager对象")
//            }
//            switch response.result {
//                case .success:
//                    this.status = .completed
//                    NotificationCenter.default.post(name: .NetworkManagerDownloadCompleted, object: nil)
//                    if let filePath = response.destinationURL?.path {
//                        this.completed?(filePath)
//                    }
//                case .failure(let error): // 意外终止的话，把已下载的数据储存起来
//                    this.resumeData = response.resumeData
//                    if this.status != .suspended {
//                        print(error)
//                        this.status = .failure
//                        this.failure?(error)
//                    }
//            }
//        })
//        return self
//    }
//
//    /// 停止下载
//    public func suspend() {
//        self.status = .suspended
//        downloadRequest?.cancel()
//    }
//
//    @discardableResult
//    public func completed(_ handler: @escaping (_ filePath: String) -> ()) -> Self {
//        self.completed = handler
//        return self
//    }
//
//    @discardableResult
//    public func failure(_ handler: @escaping (_ error: Error) -> ()) -> Self {
//        self.failure = handler
//        return self
//    }
//
//    @discardableResult
//    public func progress(_ handler: @escaping (_ progress: Progress) -> ()) -> Self {
//        self.progress = handler
//        return self
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
// }
//
// public extension Notification.Name {
//    /// 下载完成通知
//    static let NetworkManagerDownloadCompleted = NSNotification.Name("NetworkManagerDownloadCompleted")
// }
//
// private enum HttpDownloadManagerKey {
//    static var timeRemaining: ()?
//    static var speed: ()?
// }
//
// public extension DownloadRequest {
//    /// 剩余下载时间 毫秒
//    fileprivate(set) var timeRemaining: Int64 {
//        set {
//            objc_setAssociatedObject(self, &HttpDownloadManagerKey.timeRemaining, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        get {
//            return objc_getAssociatedObject(self, &HttpDownloadManagerKey.timeRemaining) as? Int64 ?? 0
//        }
//    }
//
//    /// 下载速度 字节单位
//    fileprivate(set) var speed: Int64 {
//        set {
//            objc_setAssociatedObject(self, &HttpDownloadManagerKey.speed, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        get {
//            return objc_getAssociatedObject(self, &HttpDownloadManagerKey.speed) as? Int64 ?? 0
//        }
//    }
//
//    /// 当前下载请求的 url 绝对路径
//    var absoluteString: String? {
//        return request?.url?.absoluteString.cz.urlDecoded
//    }
//
//    fileprivate func parseSpeed() {
//        // 当前已经完成的大小
//        let dataCount = progress.completedUnitCount
//        var lastData: Int64 = 0
//        if let temp = progress.userInfo[.fileCompletedCountKey] as? Int64 {
//            lastData = temp
//        }
//
//        let time = Date().timeIntervalSince1970
//        var lastTime: Double = 0
//        if let temp = progress.userInfo[.estimatedTimeRemainingKey] as? Double {
//            lastTime = temp
//        }
//
//        let cost = time - lastTime
//
//        // cost作为速度刷新的频率，也作为计算实时速度的时间段
//        if cost <= 0.8 {
//            if speed == 0 {
//                if dataCount > lastData {
//                    speed = Int64(Double(dataCount - lastData) / cost)
//                    parseTimeRemaining()
//                }
//                parseSpeed(cost)
//            }
//            return
//        }
//
//        if dataCount > lastData {
//            speed = Int64(Double(dataCount - lastData) / cost)
//            parseTimeRemaining()
//        }
//        parseSpeed(cost)
//
//        // 把当前已经完成的大小保存在fileCompletedCountKey，作为下一次的lastData
//        progress.setUserInfoObject(dataCount, forKey: .fileCompletedCountKey)
//
//        // 把当前的时间保存在estimatedTimeRemainingKey，作为下一次的lastTime
//        progress.setUserInfoObject(time, forKey: .estimatedTimeRemainingKey)
//    }
//
//    private func parseSpeed(_ cost: TimeInterval) {
//        let dataCount = progress.completedUnitCount
//        var lastData: Int64 = 0
//        if progress.userInfo[.fileCompletedCountKey] != nil {
//            lastData = progress.userInfo[.fileCompletedCountKey] as! Int64
//        }
//        if dataCount > lastData {
//            speed = Int64(Double(dataCount - lastData) / cost)
//            parseTimeRemaining()
//        }
//        CZLog(speed)
//        progress.setUserInfoObject(dataCount, forKey: .fileCompletedCountKey)
//    }
//
//    private func parseTimeRemaining() {
//        if speed == 0 {
//            self.timeRemaining = 0
//        } else {
//            let timeRemaining = (Double(progress.totalUnitCount) - Double(progress.completedUnitCount)) / Double(speed)
//            self.timeRemaining = Int64(timeRemaining)
//            if timeRemaining < 1, timeRemaining > 0.8 {
//                self.timeRemaining += 1
//            }
//        }
//    }
// }
