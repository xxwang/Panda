
import Photos
import UIKit

public enum AlbumResult {
    case success
    case error
    case denied
}


public class PhotoUtils: NSObject {
    var isEditor: Bool = false
    var completed: ((_ image: UIImage) -> Void)?
    var saveCompleted: ((Bool) -> Void)?

    public static let shared = PhotoUtils()
    override private init() {}
}

public extension PhotoUtils {

    func openCamera(editor: Bool, complete: @escaping (_ image: UIImage) -> Void) -> UIImagePickerController? {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("\(#file) - [\(#line)]:camera is invalid, please check")
            return nil
        }
        completed = complete
        isEditor = editor

        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .camera
        photo.allowsEditing = editor
        return photo
    }

    func openPhotoLibrary(editor: Bool = false, complete: @escaping (_ image: UIImage) -> Void) -> UIImagePickerController {
        completed = complete
        isEditor = editor

        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .photoLibrary
        photo.allowsEditing = editor
        return photo
    }

    func saveImage(_ image: UIImage, completed: ((Bool) -> Void)? = nil) {
        saveCompleted = completed
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
}

extension PhotoUtils {
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        saveCompleted?(error == nil)
    }
}

extension PhotoUtils: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[isEditor ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true) {
            guard let completed = self.completed else {
                return
            }
            completed(image)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

public extension PhotoUtils {
    var PHPhotoLibraryIsAuthorized: Bool {
        PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .notDetermined
    }

    func saveImage2Album(_ image: UIImage, albumName: String = "", completion: ((_ result: AlbumResult) -> Void)?) {
        if !PHPhotoLibraryIsAuthorized {
            completion?(.denied)
            return
        }

        var assetAlbum: PHAssetCollection?

        if albumName.isEmpty {
            let list = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            assetAlbum = list.firstObject
        } else {
            let list = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            list.enumerateObjects { album, _, stop in
                let assetCollection = album
                if albumName == assetCollection.localizedTitle {
                    assetAlbum = assetCollection
                    stop.initialize(to: true)
                }
            }

            if assetAlbum == nil {
                PHPhotoLibrary.shared().performChanges {
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                } completionHandler: { isSuccess, error in
                    if isSuccess {
                        self.saveImage2Album(image, albumName: albumName, completion: completion)
                    } else {
                        Logger.info(error?.localizedDescription ?? "")
                    }
                }
                return
            }

            PHPhotoLibrary.shared().performChanges {

                let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
                if !albumName.isEmpty { 
                    if let assetPlaceholder = result.placeholderForCreatedAsset {
                        let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetAlbum!)
                        albumChangeRequest?.addAssets([assetPlaceholder] as NSArray)
                    }
                }
            } completionHandler: { isSuccess, error in
                if isSuccess {
                    completion?(.success)
                } else {
                    Logger.info(error?.localizedDescription ?? "")
                    completion?(.error)
                }
            }
        }
    }
}
