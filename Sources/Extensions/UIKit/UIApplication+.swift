
import CoreLocation
import Foundation
import StoreKit
import UIKit
import UserNotifications


public extension UIApplication {
    var sk_appDelegate: UIApplicationDelegate? {
        let delegate = delegate
        return delegate
    }

    @available(iOS 13.0, *)
    var sk_sceneDelegate: UIWindowSceneDelegate? {
        for scene in connectedScenes {
            if let windowScene = scene as? UIWindowScene,
               let windowSceneDelegate = windowScene.delegate as? UIWindowSceneDelegate
            {
                return windowSceneDelegate
            }
        }
        return nil
    }

    var sk_interfaceOrientation: UIInterfaceOrientation {
        if #available(iOS 13, *) {
            return UIWindow.sk_main?.windowScene?.interfaceOrientation ?? .unknown
        } else {
            return statusBarOrientation
        }
    }

    static var sk_reachable: Bool {
        NSData(contentsOf: URL(string: "https://www.baidu.com/")!) != nil
    }
}

public extension UIApplication {

    func sk_homeUrlInAppStore(with appID: String) -> String {
        "itms-apps://itunes.apple.com/app/id\(appID)?mt=8"
    }

    func sk_detailUrlInAppStore(with appID: String) -> String {
        "http://itunes.apple.com/cn/lookup?id=\(appID)"
    }
}

public extension UIApplication {
    var sk_isNewVersion: Bool {
        let currentVersion = Bundle.sk_appVersion()
        let sandboxVersion = UserDefaults.standard.string(forKey: "appVersion") ?? ""
        UserDefaults.standard.set(currentVersion, forKey: "appVersion")
        UserDefaults.standard.synchronize()
        return currentVersion.compare(sandboxVersion) == .orderedDescending
    }

    func sk_compareVersion(_ version: String) -> Bool {
        let newVersion = sk_splitAppVersion(version)
        guard newVersion.isOk else { return false }

        let currentVersion = sk_splitAppVersion(Bundle.sk_appVersion())
        guard currentVersion.isOk else { return false }

        if newVersion.versions.major > currentVersion.versions.major {
            return true
        }

        if newVersion.versions.major < currentVersion.versions.major {
            return false
        }

        if newVersion.versions.minor > currentVersion.versions.minor {
            return true
        }

        if newVersion.versions.minor < currentVersion.versions.minor {
            return false
        }

        if newVersion.versions.patch > currentVersion.versions.patch {
            return true
        }

        if newVersion.versions.patch < currentVersion.versions.patch {
            return false
        }

        return false
    }

    func sk_splitAppVersion(_ version: String) -> (isOk: Bool, versions: (major: Int, minor: Int, patch: Int)) {
        let versionNumbers = version.sk_split(with: ".")
        if versionNumbers.count != 3 {
            return (isOk: false, versions: (major: 0, minor: 0, patch: 0))
        }

        let majorString = versionNumbers[0]
        let majorNumber = majorString.sk_int()

        let minorString = versionNumbers[1]
        let minorNumber = minorString.sk_int()

        let patchString = versionNumbers[2]
        let patchNumber = patchString.sk_int()

        return (isOk: true, versions: (major: majorNumber, minor: minorNumber, patch: patchNumber))
    }
}

public extension UIApplication {
    func sk_clearApplicationIconBadge() {
        applicationIconBadgeNumber = 0
    }
}

public extension UIApplication {

    func sk_openURL(_ url: URL, completion: ((_ isOk: Bool) -> Void)? = nil) {
        if #available(iOS 10.0, *) {
            self.open(url, options: [:]) { success in
                completion?(success)
            }
        } else {
            completion?(openURL(url))
        }
    }

    func sk_call(with phoneNumber: String, completion: @escaping (_ isOk: Bool) -> Void) {
        let callAddress = ("tel://" + phoneNumber)
        guard let url = URL(string: callAddress) else { completion(false); return }
        guard canOpenURL(url) else { completion(false); return }
        sk_openURL(url, completion: completion)
    }

    func sk_openAppDetailViewController(from controller: some UIViewController & SKStoreProductViewControllerDelegate,
                                        appID: String)
    {
        guard appID.count > 0 else { return }

        let productViewController = SKStoreProductViewController()
        productViewController.delegate = controller
        productViewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appID]) { isOk, error in
            if !isOk {
                Logger.error(error?.localizedDescription ?? "")
                productViewController.dismiss(animated: true)
            }
        }
        controller.showDetailViewController(productViewController, sender: controller)
    }

    func openEvaluateInAppStore(_ appID: String) {
        let urlString = "https://itunes.apple.com/cn/app/id\(appID)?mt=12"
        guard let url = URL(string: urlString) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        sk_openURL(url) { isOk in  }
    }

    func sk_openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        sk_openURL(url) { isOk in }
    }

    func sk_openSettings(_ title: String?,
                         message: String?,
                         cancel: String = "Cancel",
                         confirm: String = "Settings",
                         parent: UIViewController? = nil)
    {
        UIAlertController.default()
            .sk_title(title)
            .sk_message(message)
            .sk_addAction_(title: cancel, style: .cancel) { _ in
               
            }
            .sk_addAction_(title: confirm, style: .default) { _ in
                self.sk_openSettings()
            }.sk_show()
    }
}


public extension UIApplication {

    func sk_registerAPNsWithDelegate(_ delegate: Any) {
        if #available(iOS 10.0, *) {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            let center = UNUserNotificationCenter.current()
            center.delegate = (delegate as! UNUserNotificationCenterDelegate)
            center.requestAuthorization(options: options) { (granted: Bool, error: Error?) in
                Logger.info("register push \(granted ? "success" : "failed")!")
            }
            self.registerForRemoteNotifications()
        } else {
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            registerUserNotificationSettings(settings)
            registerForRemoteNotifications()
        }
    }

    @available(iOS 10.0, *)
    func sk_addLocalUserNotification(trigger: AnyObject,
                                     content: UNMutableNotificationContent,
                                     identifier: String,
                                     categories: AnyObject,
                                     repeats: Bool = true,
                                     handler: ((UNUserNotificationCenter, UNNotificationRequest, Error?) -> Void)?)
    {

        var notiTrigger: UNNotificationTrigger?
        if let date = trigger as? Date {
            var interval = date.timeIntervalSince1970 - Date().timeIntervalSince1970
            interval = interval < 0 ? 1 : interval
            notiTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        } else if let components = trigger as? DateComponents {
            notiTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        } else if let region = trigger as? CLCircularRegion {
            notiTrigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        }

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notiTrigger)
        let center = UNUserNotificationCenter.current()

        center.add(request) { error in
            handler?(center, request, error)
            if error == nil {
                return
            }
            print("notification add success!")
        }
    }
}
