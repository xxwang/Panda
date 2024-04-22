import AVFoundation
import UIKit

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
    func pd_canOpen() -> Bool {
        return UIApplication.shared.canOpenURL(self)
    }

    /// 以字典形式返回`URL`的参数
    /// - Returns: 参数字典
    func pd_parameters() -> [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }

    /// 给`URL`添加参数列表,并返回`URL`
    ///
    ///     let url = URL(string:"https://google.com")!
    ///     let param = ["q":"Swifter Swift"]
    ///     url.pd_appendParameters(params) -> "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: 参数列表
    /// - Returns: 带参数列表的`URL`
    func pd_appendParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        return urlComponents.url!
    }

    /// 给`URL`添加参数列表
    ///
    ///     var url = URL(string:"https://google.com")!
    ///     let param = ["q":"Swifter Swift"]
    ///     url.pd_appendParameters(params)
    ///     print(url) // prints "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: 参数列表
    mutating func pd_appendParameters(_ parameters: [String: String]) {
        self = pd_appendParameters(parameters)
    }

    /// 获取查询参数中键对应的值
    ///
    ///     var url = URL(string:"https://google.com?code=12345")!
    ///     url.pd_queryValue(for:"code") -> "12345"
    ///
    /// - Parameter key: 键
    /// - Returns: 参数字符串
    func pd_queryValue(for key: String) -> String? {
        URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    /// 删除所有路径组件返回新`URL`
    ///
    ///     let url = URL(string:"https://domain.com/path/other")!
    ///     print(url.pd_deleteAllPathComponents()) // prints "https://domain.com/"
    ///
    /// - Returns: 结果`URL`
    func pd_deleteAllPathComponents() -> URL {
        var url: URL = self
        for _ in 0 ..< pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }

    /// 从`URL`中删除所有路径组件
    ///
    ///     var url = URL(string:"https://domain.com/path/other")!
    ///     url.pd_deleteAllPathComponents()
    ///     print(url) // prints "https://domain.com/"
    ///
    mutating func pd_deleteAllPathComponents() {
        for _ in 0 ..< pathComponents.count - 1 {
            self.deleteLastPathComponent()
        }
    }

    /// 删除`URL`中的协议部分
    ///
    ///     let url = URL(string:"https://domain.com")!
    ///     print(url.pd_droppedScheme()) // prints "domain.com"
    ///
    /// - Returns: 新的`URL`
    func pd_droppedScheme() -> URL? {
        if let scheme {
            let droppedScheme = String(absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }
        guard host != nil else { return self }
        let droppedScheme = String(absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }

    /// 根据视频`URL`在指定时间`秒`截取图像
    ///
    ///     var url = URL(string:"https://video.golem.de/files/1/1/20637/wrkw0718-sd.mp4")!
    ///     var thumbnail = url.pd_thumbnail()
    ///     thumbnail = url.pd_thumbnail(fromTime:5)
    ///
    ///     DisptachQueue.main.async {
    ///      someImageView.image = url.thumbnail()
    ///     }
    ///
    /// - Parameter time: 需要生成图片的视频的时间`秒`
    /// - Returns: 截取的图片
    func pd_thumbnail(from time: Float64 = 0) -> UIImage? {
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
    /// 向`URL`中追加路径
    /// - Parameter path: 要追加的路径
    /// - Returns: `Self`
    func pd_appendingPathComponent(_ path: String) -> Self {
        if #available(iOS 16.0, *) {
            return self.appending(component: path)
        } else {
            return self.appendingPathComponent(path)
        }
    }
}
