//
//  UIScreen+.swift
//  
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit

public extension UIScreen {
    
    /// 检查截屏或者录屏并发送通知
    /// - Parameter action:回调
    static func detectScreenShot(_ action: @escaping (String) -> Void) {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: mainQueue) { notification in
            action("screenshot")
        }
        // 监听录屏通知,iOS 11后才有录屏
        if #available(iOS 11.0, *) {
            // 如果正在捕获此屏幕(例如,录制、空中播放、镜像等),则为真
            if UIScreen.main.isCaptured {
                action("recording")
            }
            // 捕获的屏幕状态发生变化时,会发送UIScreenCapturedDidChange通知,监听该通知
            NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: nil, queue: mainQueue) { notification in
                action("recording")
            }
        }
    }
}
