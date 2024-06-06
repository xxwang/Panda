import AVFoundation
import UIKit

public extension URL {
    init?(path string: String?, base url: URL? = nil) {
        guard let string else { return nil }
        self.init(string: string, relativeTo: url)
    }
}

public extension URL {
    func sk_canOpen() -> Bool {
        return UIApplication.shared.canOpenURL(self)
    }

    func sk_parameters() -> [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }

    func sk_appendParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        return urlComponents.url!
    }

    mutating func sk_appendParameters(_ parameters: [String: String]) {
        self = sk_appendParameters(parameters)
    }

    func sk_queryValue(for key: String) -> String? {
        URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    func sk_deleteAllPathComponents() -> URL {
        var url: URL = self
        for _ in 0 ..< pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }

    mutating func sk_deleteAllPathComponents() {
        for _ in 0 ..< pathComponents.count - 1 {
            self.deleteLastPathComponent()
        }
    }

    func sk_droppedScheme() -> URL? {
        if let scheme {
            let droppedScheme = String(absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }
        guard host != nil else { return self }
        let droppedScheme = String(absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }

    func sk_thumbnail(from time: Float64 = 0) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: self))
        let time = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)

        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

public extension URL {
    func sk_appendingPathComponent(_ path: String) -> Self {
        if #available(iOS 16.0, *) {
            return self.appending(component: path)
        } else {
            return self.appendingPathComponent(path)
        }
    }
}
