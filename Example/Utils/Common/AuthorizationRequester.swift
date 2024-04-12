//
//  AuthorizationRequester.swift
//  PHI33-DC
//
//  Created by 奥尔良小短腿 on 2024/4/6.
//

import AdSupport
import AppTrackingTransparency
import AVFoundation
import ContactsUI
import CoreLocation
import Photos
import UIKit

typealias AuthenticationCallback = (_ granted: Bool) -> Void

class AuthorizationRequester: NSObject {
    // MARK: - AuthorizationStatus
    enum AuthorizationStatus {
        case notDetermined
        case denied
        case authorized
    }

    private var locationAuthorizationStatusCallback: AuthenticationCallback?
    private var locationManager: CLLocationManager!

    static let shared = AuthorizationRequester()
    override private init() {
        super.init()

        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
}

// MARK: - IDFA
extension AuthorizationRequester {
    var idfaStatus: AuthorizationStatus {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            switch status {
            case .notDetermined:
                return .notDetermined
            case .denied, .restricted:
                return .denied
            case .authorized:
                return .authorized
            default:
                return .denied
            }
        } else {
            let isEnabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            if isEnabled {
                return .authorized
            } else {
                return .denied
            }
        }
    }

    func requestIDFA(resultCallback: AuthenticationCallback?) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                let granted = status == .authorized
                DispatchQueue.main.async {
                    resultCallback?(granted)
                }
            }
        } else {
            let granted = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            DispatchQueue.main.async {
                resultCallback?(granted)
            }
        }
    }
}

// MARK: - 麦克风
extension AuthorizationRequester {
    var microphoneStatus: AuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        case .authorized:
            return .authorized
        default:
            return .denied
        }
    }

    func requestMicrophone(resultCallback: AuthenticationCallback?) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                resultCallback?(granted)
            }
        }
    }
}

// MARK: - 相机
extension AuthorizationRequester {
    var cameraStatus: AuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        case .authorized:
            return .authorized
        default:
            return .denied
        }
    }

    func requestCamera(resultCallback: AuthenticationCallback?) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                resultCallback?(granted)
            }
        }
    }
}

// MARK: - 相册
extension AuthorizationRequester {
    var photoLibraryStatus: AuthorizationStatus {
        var status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }

        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        case .authorized, .limited:
            return .authorized
        default:
            return .notDetermined
        }
    }

    func requestPhotoLibrary(resultCallback: AuthenticationCallback?) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                let granted = status == .authorized || status == .limited
                DispatchQueue.main.async {
                    resultCallback?(granted)
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                let granted = status == .authorized
                DispatchQueue.main.async {
                    resultCallback?(granted)
                }
            }
        }
    }
}

// MARK: - 通讯录
extension AuthorizationRequester {
    var contactsStatus: AuthorizationStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        case .authorized:
            return .authorized
        default:
            return .denied
        }
    }

    func requestContacts(resultCallback: AuthenticationCallback?) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if error != nil {
                DispatchQueue.main.async {
                    resultCallback?(false)
                }
            } else {
                DispatchQueue.main.async {
                    resultCallback?(granted)
                }
            }
        }
    }
}

// MARK: - 定位
extension AuthorizationRequester {
    enum LocationAuthorizationAction {
        case front
        case back
    }

    var locationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }

    var locationStatus: AuthorizationStatus {
        var status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = self.locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            return .authorized
        default:
            return .denied
        }
    }

    func requestLocation(action: LocationAuthorizationAction, resultCallback: AuthenticationCallback?) {
        self.locationAuthorizationStatusCallback = resultCallback

        if action == .back {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension AuthorizationRequester: CLLocationManagerDelegate {
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        let granted = status == .authorizedAlways || status == .authorizedWhenInUse
        if let callback = self.locationAuthorizationStatusCallback {
            DispatchQueue.main.async {
                callback(granted)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let granted = status == .authorizedAlways || status == .authorizedWhenInUse
        if let callback = self.locationAuthorizationStatusCallback {
            DispatchQueue.main.async {
                callback(granted)
            }
        }
    }
}
