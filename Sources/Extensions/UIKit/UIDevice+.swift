
import AdSupport
import AVKit
import CoreTelephony
import Security
import SystemConfiguration.CaptiveNetwork
import UIKit


public extension UIDevice {

    static var sk_IDFV: String? {
        UIDevice.current.identifierForVendor?.uuidString
    }

    static var sk_IDFA: String? {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return nil
    }

    static var sk_UUID: String {
        let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
        let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        let uuidString = (strRef! as String).replacingOccurrences(of: "_", with: "")
        return uuidString
    }
}


public extension UIDevice {

    static var sk_isBreak: Bool {
        if environment.isSimulator {
            return false
        }
        let paths = ["/Applications/Cydia.app", "/private/var/lib/apt/",
                     "/private/var/lib/cydia", "/private/var/stash"]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        let bash = fopen("/bin/bash", "r")
        if bash != nil {
            fclose(bash)
            return true
        }
        let path = String(format: "/private/%@", sk_UUID)
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            NSLog(error.localizedDescription)
        }
        return false
    }

    static func sk_isCanCallTel() -> Bool {
        if let url = URL(string: "tel://") {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

public extension UIDevice {
    static var sk_currentSystemVersion: String {
        UIDevice.current.systemVersion
    }

    static var sk_systemUpdateTime: Date {
        let time = ProcessInfo.processInfo.systemUptime
        return Date(timeIntervalSinceNow: 0 - time)
    }


    static var sk_deviceModel: String {
        UIDevice.current.model
    }

    static var sk_currentSystemName: String {
        UIDevice.current.systemName
    }

    static var sk_currentDeviceName: String {
        UIDevice.current.name
    }

    static var sk_deviceLanguage: String {
        return Bundle.main.preferredLocalizations[0]
    }

    static var sk_currentLocalizedModel: String {
        UIDevice.current.localizedModel
    }

    static var sk_deviceCPUCount: Int {
        var ncpu = UInt(0)
        var len: size_t = MemoryLayout.size(ofValue: ncpu)
        sysctlbyname("hw.ncpu", &ncpu, &len, nil, 0)
        return Int(ncpu)
    }
}

public extension UIDevice {
    static var sk_diskSpace: Int64 {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let space: NSNumber = attrs[FileAttributeKey.systemSize] as? NSNumber {
                if space.int64Value > 0 {
                    return space.int64Value
                }
            }
        }
        return -1
    }

    static var sk_diskSpaceFree: Int64 {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let space: NSNumber = attrs[FileAttributeKey.systemFreeSize] as? NSNumber {
                if space.int64Value > 0 {
                    return space.int64Value
                }
            }
        }
        return -1
    }

    static var sk_freeDiskSpaceInBytes: Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
            {
                return freeSpace
            } else {
                return 0
            }
        }
    }

    static var sk_diskSpaceUsed: Int64 {
        let total = sk_diskSpace
        let free = sk_diskSpaceFree
        guard total > 0, free > 0 else {
            return -1
        }
        let used = total - free
        guard used > 0 else {
            return -1
        }

        return used
    }

    static var sk_memoryTotal: UInt64 {
        ProcessInfo.processInfo.physicalMemory
    }
}

public extension UIDevice {

    static func sk_simCardInfos() -> [CTCarrier]? {
        return sk_getCarriers()
    }


    static func sk_currentRadioAccessTechnologys() -> [String]? {
        guard !environment.isSimulator else {
            return nil
        }

        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let currentRadioTechs = info.serviceCurrentRadioAccessTechnology else {
                return nil
            }
            return currentRadioTechs.sk_allValues()
        } else {
            guard let currentRadioTech = info.currentRadioAccessTechnology else {
                return nil
            }
            return [currentRadioTech]
        }
    }

    static func sk_networkTypes() -> [String]? {
        guard let currentRadioTechs = sk_currentRadioAccessTechnologys() else {
            return nil
        }
        return currentRadioTechs.compactMap { sk_getNetworkType(currentRadioTech: $0) }
    }

    static func sk_carrierNames() -> [String]? {
        guard let carriers = sk_getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.carrierName! }
    }

    static func sk_mobileCountryCodes() -> [String]? {
        guard let carriers = sk_getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.mobileCountryCode! }
    }

    static func sk_mobileNetworkCodes() -> [String]? {
        guard let carriers = sk_getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.mobileNetworkCode! }
    }

    static func sk_isoCountryCodes() -> [String]? {
        guard let carriers = sk_getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.isoCountryCode! }
    }

    static func sk_isAllowsVOIPs() -> [Bool]? {
        guard let carriers = sk_getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map(\.allowsVOIP)
    }

    private static func sk_getCarriers() -> [CTCarrier]? {
        guard !environment.isSimulator else {
            return nil
        }
        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let providers = info.serviceSubscriberCellularProviders else {
                return []
            }
            return providers.filter { $0.value.carrierName != nil }.sk_allValues()
        } else {
            guard let carrier = info.subscriberCellularProvider, carrier.carrierName != nil else {
                return []
            }
            return [carrier]
        }
    }

    private static func sk_getNetworkType(currentRadioTech: String) -> String {

        if #available(iOS 14.1, *), currentRadioTech == CTRadioAccessTechnologyNRNSA || currentRadioTech == CTRadioAccessTechnologyNR {
            return "5G"
        }

        var networkType = ""
        switch currentRadioTech {
        case CTRadioAccessTechnologyCDMA1x,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyGPRS:
            networkType = "2G"
        case CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyWCDMA:
            networkType = "3G"
        case CTRadioAccessTechnologyLTE:
            networkType = "4G"
        default:
            break
        }
        return networkType
    }

    static var sk_deviceSupplier: String {
        let info = CTTelephonyNetworkInfo()
        var supplier = ""
        if #available(iOS 12.0, *) {
            if let carriers = info.serviceSubscriberCellularProviders {
                if carriers.keys.isEmpty {
                    return "no sim"
                } else {
                    for (index, carrier) in carriers.values.enumerated() {
                        guard carrier.carrierName != nil else {
                            return "no sim"
                        }
                        if index == 0 {
                            supplier = carrier.carrierName!
                        } else {
                            supplier = supplier + "," + carrier.carrierName!
                        }
                    }
                    return supplier
                }
            } else {
                return "no sim"
            }
        } else {
            if let carrier = info.subscriberCellularProvider {
                guard carrier.carrierName != nil else {
                    return "no sim"
                }
                return carrier.carrierName!
            } else {
                return "no sim"
            }
        }
    }
}


public extension UIDevice {

    static var sk_flashIsOn: Bool {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("camera invalid, please check")
            return false
        }
        return device.torchMode == .on ? true : false
    }

    static func sk_flash(on: Bool) {

        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("camera invalid, please check")
            return
        }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if on, device.torchMode == .off {
                    device.torchMode = .on
                }
                if !on, device.torchMode == .on {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

public extension UIDevice {

    static var sk_WifiNameWithMac: (wifiName: String?, macIP: String?) {
        guard let interfaces: NSArray = CNCopySupportedInterfaces() else {
            return (nil, nil)
        }
        var ssid: String?
        var mac: String?
        for sub in interfaces {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                ssid = dict["SSID"] as? String
                mac = dict["BSSID"] as? String
            }
        }
        return (ssid, mac)
    }

    static var sk_ipAddress: String? {
        var addresses = [String]()
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP | IFF_RUNNING | IFF_LOOPBACK)) == (IFF_UP | IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                            if let address = String(validatingUTF8: hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        if let ipStr = addresses.first {
            return ipStr
        } else {
            return nil
        }
    }

    static var sk_wifiIP: String? {
        var address: String?

        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0,
              let firstAddr = ifaddr
        else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
      
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
        
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
}
