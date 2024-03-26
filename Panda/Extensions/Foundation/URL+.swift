//
//  URL+.swift
//
//
//  Created by 王斌 on 2023/5/27.
//

import AVFoundation
import UIKit

// MARK: - 属性
public extension URL {
    /// 以字典形式返回`URL`的`参数`
    var parameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }
}

// MARK: - 构造方法
public extension URL {
    /// 使用基础`URL`和`路径字符串`初始化`URL`对象
    /// - Parameters:
    ///   - string: `URL`路径
    ///   - url: 基础`URL`
    init?(path string: String?, base url: URL? = nil) {
        guard let string else { return nil }
        self.init(string: string, relativeTo: url)
    }
}

// MARK: - 方法
public extension URL {
    /// 检测应用是否能打开这个`URL`
    /// - Returns: `Bool`
    func canOpen() -> Bool {
        UIApplication.shared.canOpenURL(self)
    }

    /// 给`URL`添加查询参数并返回携带查询参数的 `URL`
    ///
    ///     let url = URL(string:"https://google.com")!
    ///     let param = ["q":"Swifter Swift"]
    ///     url.appendParameters(params) -> "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: 参数字典
    /// - Returns: 附加查询参数的`URL`
    func appendParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        return urlComponents.url!
    }

    /// 将查询参数添加到`URL`
    ///
    ///     var url = URL(string:"https://google.com")!
    ///     let param = ["q":"Swifter Swift"]
    ///     url.appendQueryParameters(params)
    ///     print(url) // prints "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters:参数字典
    mutating func appendParameters(_ parameters: [String: String]) {
        self = appendParameters(parameters)
    }

    /// 获取查询参数中键对应的值
    ///
    ///     var url = URL(string:"https://google.com?code=12345")!
    ///     queryValue(for:"code") -> "12345"
    ///
    /// - Parameter key:键
    func queryValue(for key: String) -> String? {
        URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    /// 通过删除所有路径组件返回新`URL`
    ///
    ///     let url = URL(string:"https://domain.com/path/other")!
    ///     print(url.deletingAllPathComponents()) // prints "https://domain.com/"
    ///
    /// - Returns:`URL`
    func deletingAllPathComponents() -> URL {
        var url: URL = self
        for _ in 0 ..< pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }

    /// 从`URL`中删除所有路径组件
    ///
    ///     var url = URL(string:"https://domain.com/path/other")!
    ///     url.deleteAllPathComponents()
    ///     print(url) // prints "https://domain.com/"
    ///
    mutating func deleteAllPathComponents() {
        for _ in 0 ..< pathComponents.count - 1 {
            deleteLastPathComponent()
        }
    }

    /// 生成没有协议的新URL
    ///
    ///     let url = URL(string:"https://domain.com")!
    ///     print(url.droppedScheme()) // prints "domain.com"
    ///
    func droppedScheme() -> URL? {
        if let scheme {
            let droppedScheme = String(absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }
        guard host != nil else { return self }
        let droppedScheme = String(absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }

    /// 根据`视频URL`在指定时间`秒`截取图像
    ///
    ///     var url = URL(string:"https://video.golem.de/files/1/1/20637/wrkw0718-sd.mp4")!
    ///     var thumbnail = url.thumbnail()
    ///     thumbnail = url.thumbnail(fromTime:5)
    ///
    ///     DisptachQueue.main.async {
    ///      someImageView.image = url.thumbnail()
    ///     }
    ///
    /// - Parameter time:需要生成图片的视频的时间`秒`
    /// - Returns:`UIImage`
    func thumbnail(from time: Float64 = 0) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: self))
        let time = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)

        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - 链式语法
public extension URL {
    /// 追加路径
    /// - Parameter path: 路径
    /// - Returns: `Self`
    func pd_appendingPathComponent(_ path: String) -> Self {
        if #available(iOS 16.0, *) {
            return self.appending(component: path)
        } else {
            return appendingPathComponent(path)
        }
    }
}
