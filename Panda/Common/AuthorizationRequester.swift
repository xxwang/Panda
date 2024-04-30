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

public typealias AuthenticationBlock = (_ granted: Bool) -> Void

// MARK: - AuthorizationStatus
public enum AuthorizationStatus {
    case notDetermined
    case denied
    case authorized
}

// MARK: - LocationAuthorizationAction
public enum LocationAuthorizationAction {
    case front
    case back
}

// MARK: - AuthorizationRequester
public class AuthorizationRequester: NSObject {
    private var locationAuthorizationStatusBlock: AuthenticationBlock?
    private var locationManager: CLLocationManager!

    public static let shared = AuthorizationRequester()
    override private init() {
        super.init()

        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
}

// MARK: - IDFA
public extension AuthorizationRequester {
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

    func requestIDFA(resultBlock: AuthenticationBlock?) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                let granted = status == .authorized
                DispatchQueue.main.async {
                    resultBlock?(granted)
                }
            }
        } else {
            let granted = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            DispatchQueue.main.async {
                resultBlock?(granted)
            }
        }
    }
}

// MARK: - 麦克风
public extension AuthorizationRequester {
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

    func requestMicrophone(resultBlock: AuthenticationBlock?) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                resultBlock?(granted)
            }
        }
    }
}

// MARK: - 相机
public extension AuthorizationRequester {
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

    func requestCamera(resultBlock: AuthenticationBlock?) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                resultBlock?(granted)
            }
        }
    }
}

// MARK: - 相册
public extension AuthorizationRequester {
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

    func requestPhotoLibrary(resultBlock: AuthenticationBlock?) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                let granted = status == .authorized || status == .limited
                DispatchQueue.main.async {
                    resultBlock?(granted)
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                let granted = status == .authorized
                DispatchQueue.main.async {
                    resultBlock?(granted)
                }
            }
        }
    }
}

// MARK: - 通讯录
public extension AuthorizationRequester {
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

    func requestContacts(resultBlock: AuthenticationBlock?) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if error != nil {
                DispatchQueue.main.async {
                    resultBlock?(false)
                }
            } else {
                DispatchQueue.main.async {
                    resultBlock?(granted)
                }
            }
        }
    }
}

// MARK: - 定位
public extension AuthorizationRequester {
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

    func requestLocation(action: LocationAuthorizationAction, completion: AuthenticationBlock?) {
        self.locationAuthorizationStatusBlock = completion

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
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        guard status != .notDetermined else { return }

        let granted = status == .authorizedAlways || status == .authorizedWhenInUse

        if let block = self.locationAuthorizationStatusBlock {
            DispatchQueue.main.async {
                block(granted)
                self.locationAuthorizationStatusBlock = nil
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }

        let granted = status == .authorizedAlways || status == .authorizedWhenInUse

        if let block = self.locationAuthorizationStatusBlock {
            DispatchQueue.main.async {
                block(granted)
                self.locationAuthorizationStatusBlock = nil
            }
        }
    }
}
