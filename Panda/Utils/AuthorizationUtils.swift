//
//  AuthorizationUtils.swift
//
//
//  Created by xxwang on 2023/5/29.
//

import AssetsLibrary
import AVFoundation
import CoreLocation
import Photos
import UIKit

public enum AuthorizationUtils {
    /// 相机权限
    static func authorizeCameraWith(completion: @escaping (Bool) -> Void) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch granted {
        case .authorized:
            completion(true)
        case .denied:
            UIApplication.shared.openSettings()
        case .restricted:
            UIApplication.shared.openSettings()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        @unknown default:
            UIApplication.shared.openSettings()
        }
    }

    /// 相册权限
    static func authorizePhotoWith(comletion: ((Bool) -> Void)? = nil) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion?(true)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            UIApplication.shared.openSettings()
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    comletion?(status == PHAuthorizationStatus.authorized)
                }
            }
        case .limited:
            comletion?(true)
        @unknown default:
            UIApplication.shared.openSettings()
        }
    }

    /// 麦克风
    static func authorizeMicrophoneWith(completion: @escaping (Bool) -> Void) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch granted {
        case .authorized:
            completion(true)
        case .denied:
            UIApplication.shared.openSettings()
        case .restricted:
            UIApplication.shared.openSettings()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        @unknown default:
            UIApplication.shared.openSettings()
        }
    }

    /// 定位
    static func authorizeLocationWith(completion: @escaping (Bool) -> Void) {
        if CLLocationManager.locationServicesEnabled() == false {
            Log.info("请打开定位功能!")
            completion(false)
            return
        }
        var granted: CLAuthorizationStatus = .denied
        if #available(iOS 14.0, *) {
            granted = CLLocationManager().authorizationStatus
        } else {
            granted = CLLocationManager.authorizationStatus()
        }
        switch granted {
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            completion(true)
        case .denied:
            UIApplication.shared.openSettings()
        case .restricted:
            UIApplication.shared.openSettings()
        case .notDetermined:
            CLLocationManager().requestAlwaysAuthorization()
            CLLocationManager().requestWhenInUseAuthorization()
        @unknown default:
            UIApplication.shared.openSettings()
        }
    }

    /// 推送
    func checkPushNotification(checkNotificationStatus isEnable: ((Bool) -> Void)? = nil) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { setttings in
                switch setttings.authorizationStatus {
                case .authorized:
                    isEnable?(true)
                case .denied:
                    isEnable?(false)
                case .notDetermined:
                    isEnable?(false)
                default:
                    isEnable?(false)
                }
            }
        } else {
            let isNotificationEnabled = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert)
            if isNotificationEnabled == true {
                isEnable?(true)
            } else {
                isEnable?(false)
            }
        }
    }
}
