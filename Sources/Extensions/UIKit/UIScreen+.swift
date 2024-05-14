
import UIKit

public extension UIScreen {

    static func xx_detectScreenShot(_ action: @escaping (String) -> Void) {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: mainQueue) { notification in
            action("screenshot")
        }

        if #available(iOS 11.0, *) {

            if UIScreen.main.isCaptured {
                action("recording")
            }
          
            NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: mainQueue) { notification in
                action("recording")
            }
        }
    }
}
