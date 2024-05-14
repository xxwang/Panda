
import AVFoundation
import AVKit
import Photos
import UIKit

public class VideoUtils {
    public static let shared = VideoUtils()
    private init() {}
}

public extension VideoUtils {

    func videoDuration(path: String?) -> Double {
        guard let path, let url = path.xx_url() else { return 0 }
        let asset = AVURLAsset(url: url)
        let time = asset.duration
        return Double(time.value / Int64(time.timescale))
    }
}

public extension VideoUtils {

    func playVideo(with videoUrl: URL, sourceController: UIViewController) {
        let player = AVPlayer(url: videoUrl)
        let controller = AVPlayerViewController()
        controller.player = player
        sourceController.present(controller, animated: true) { player.play() }
    }
}

public extension VideoUtils {

    func videoCover(with videoUrl: URL?) -> UIImage? {
        guard let videoUrl else { return nil }
        let asset = AVURLAsset(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)

        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    static func videoCover(with videoUrl: URL, success: ((UIImage?) -> Void)?) {
        DispatchQueue.global().async {
            let options = [AVURLAssetPreferPreciseDurationAndTimingKey: false]
            let avAsset = AVURLAsset(url: videoUrl, options: options)

            let generator = AVAssetImageGenerator(asset: avAsset)
            generator.appliesPreferredTrackTransform = true
            generator.apertureMode = .encodedPixels
            let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
            var actualTime = CMTimeMake(value: 0, timescale: 0)
            var imageRef: CGImage?
            var image: UIImage?
            do {
                imageRef = try generator.copyCGImage(at: time, actualTime: &actualTime)
                if let cgimage = imageRef { image = UIImage(cgImage: cgimage) }
            } catch {
                Logger.info("error!\(error.localizedDescription)")
            }

            DispatchQueue.main.async {
                success?(image)
            }
        }
    }
}


public extension VideoUtils {

    func saveVideo(with videoUrl: URL, completed: ((Bool) -> Void)?) {
        if AuthorizationRequester.shared.photoLibraryStatus == .authorized {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
            }) { success, error in
                if let error {
                    Logger.info(error.localizedDescription)
                }
                completed?(success)
            }
        } else if AuthorizationRequester.shared.photoLibraryStatus == .notDetermined {
            AuthorizationRequester.shared.requestPhotoLibrary { granted in
                if granted {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
                    }) { success, error in
                        if let error {
                            Logger.info(error.localizedDescription)
                        }
                        completed?(success)
                    }
                }
            }
        }
    }

    func mov2mp4(_ videoUrl: URL, completed: ((URL) -> Void)?) {
        let asset = AVURLAsset(url: videoUrl, options: nil)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            return
        }
        let output = "\(Date().xx_secondStamp()).mp4".xx_urlByCache()
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputURL = output
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
            case .failed:
                let exportError = exportSession.error
                if let exportError {
                    Logger.info("AVAssetExportSessionStatusFailed:\(exportError.localizedDescription)")
                }
            case .completed:
                completed?(output)
            default: break
            }
        })
    }

    func mp4Path(from asset: PHAsset, completed: ((String?) -> Void)?) {
        let assetResources = PHAssetResource.assetResources(for: asset)
        var _resource: PHAssetResource?
        for res in assetResources {
            if res.type == .video {
                _resource = res
                break
            }
        }
        guard let resource = _resource else {
            completed?(nil)
            return
        }
        let fileName = resource.originalFilename.components(separatedBy: ".")[0] + ".mp4"

        if asset.mediaType == .video {
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .highQualityFormat
            let savePath = NSTemporaryDirectory() + fileName
            if FileManager.default.fileExists(atPath: savePath) {
                completed?(savePath)
                return
            }
            PHAssetResourceManager.default().writeData(for: resource, toFile: URL(fileURLWithPath: savePath), options: nil, completionHandler: { error in
                if let error {
                    Logger.info("convert mp4 failed. \(error)")
                    completed?(nil)
                } else {
                    Logger.info("convert mp4 success")
                    completed?(savePath)
                }
            })
        }
    }
}
