
import UIKit

public class DocumentUtils: NSObject {

    var completion: ((_ isOk: Bool, _ data: Data?, _ fileName: String?) -> Void)?
    var iCloudEnable: Bool {
        let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)
        return url != nil
    }

    public static let shared = DocumentUtils()
    override private init() {}
}

public extension DocumentUtils {

    func openDocument(_ types: [String], mode: UIDocumentPickerMode, complete: @escaping (_ isOk: Bool, _ data: Data?, _ fileName: String?) -> Void) {
        completion = complete
        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: types, in: mode)
        documentPickerViewController.delegate = self
        documentPickerViewController.modalPresentationStyle = .fullScreen
        UIWindow.sk_main?.rootViewController?.sk_present(viewController: documentPickerViewController)
    }
}


extension DocumentUtils: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        let fileName = url.lastPathComponent

        if iCloudEnable {
            download(url) { fileData in self.completion?(true, fileData, fileName) }
        } else {
            UIApplication.shared.sk_openSettings("Please allow the use of iCloud cloud storage",
                                                 message: nil,
                                                 cancel: "Cancel",
                                                 confirm: "Confirm",
                                                 parent: UIWindow.sk_main?.rootViewController)
        }
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completion?(false, nil, nil)
    }
}

public extension DocumentUtils {
    func download(_ documentUrl: URL, completion: ((Data) -> Void)? = nil) {
        let document = PDDocument(fileURL: documentUrl)
        document.open { success in
            if success {
                document.close(completionHandler: nil)
            }
            if let callback = completion {
                callback(document.data)
            }
        }
    }
}

public class PDDocument: UIDocument {
    public var data = Data()
    override public func load(fromContents contents: Any, ofType typeName: String?) throws {
        data = contents as! Data
    }
}
