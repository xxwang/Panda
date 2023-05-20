//
//  UIDevice+.swift
//  
//
//  Created by 王斌 on 2023/5/21.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreTelephony
import Security
import AdSupport
import AVKit

// MARK: - 标识
public extension UIDevice {
    /// IDFV
    static var IDFV: String? {
        UIDevice.current.identifierForVendor?.uuidString
    }

    /// IDFA用户关闭,则返回nil
    static var IDFA: String? {
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return nil
    }

    /// UUID
    static var UUID: String {
        let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
        let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        let uuidString = (strRef! as String).replacingOccurrences(of: "_", with: "")
        return uuidString
    }
}

// MARK: - 设备区分
public extension UIDevice {
    /// 当前设备是否越狱
    static var isBreak: Bool {
        if Panda.dev.isSimulator {
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
        let path = String(format: "/private/%@", UUID)
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            NSLog(error.localizedDescription)
        }
        return false
    }

    /// 当前设备能否打电话
    /// - Returns:结果
    static func isCanCallTel() -> Bool {
        if let url = URL(string: "tel://") {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

// MARK: - 设备的基本信息
public extension UIDevice {
    /// 当前设备的系统版本
    static var currentSystemVersion: String {
        UIDevice.current.systemVersion
    }

    /// 当前系统更新时间
    static var systemUpdateTime: Date {
        let time = ProcessInfo.processInfo.systemUptime
        return Date(timeIntervalSinceNow: 0 - time)
    }

    /// 当前设备的类型
    static var deviceModel: String {
        UIDevice.current.model
    }

    /// 当前系统的名称
    static var currentSystemName: String {
        UIDevice.current.systemName
    }

    /// 当前设备的名称
    static var currentDeviceName: String {
        UIDevice.current.name
    }

    /// 当前设备语言
    static var deviceLanguage: String {
        Bundle.main.preferredLocalizations[0]
    }

    /// 设备区域化型号
    static var currentLocalizedModel: String {
        UIDevice.current.localizedModel
    }

    /// 获取CPU核心数量
    static var deviceCPUCount: Int {
        var ncpu = UInt(0)
        var len: size_t = MemoryLayout.size(ofValue: ncpu)
        sysctlbyname("hw.ncpu", &ncpu, &len, nil, 0)
        return Int(ncpu)
    }
}

// MARK: - 存储信息
public extension UIDevice {
    /// 当前硬盘的空间
    static var diskSpace: Int64 {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let space: NSNumber = attrs[FileAttributeKey.systemSize] as? NSNumber {
                if space.int64Value > 0 {
                    return space.int64Value
                }
            }
        }
        return -1
    }

    /// 当前硬盘可用空间
    static var diskSpaceFree: Int64 {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
            if let space: NSNumber = attrs[FileAttributeKey.systemFreeSize] as? NSNumber {
                if space.int64Value > 0 {
                    return space.int64Value
                }
            }
        }
        return -1
    }

    /// 可用磁盘空间(字节)
    static var freeDiskSpaceInBytes: Int64 {
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

    /// 当前硬盘已经使用的空间
    static var diskSpaceUsed: Int64 {
        let total = diskSpace
        let free = diskSpaceFree
        guard total > 0, free > 0 else {
            return -1
        }
        let used = total - free
        guard used > 0 else {
            return -1
        }

        return used
    }

    /// 获取总内存大小
    static var memoryTotal: UInt64 {
        ProcessInfo.processInfo.physicalMemory
    }
}

// MARK: - 有关设备运营商的信息
public extension UIDevice {
    /// sim卡信息
    static func simCardInfos() -> [CTCarrier]? {
        getCarriers()
    }

    /// 数据业务对应的通信技术
    /// - Returns:通信技术
    static func currentRadioAccessTechnologys() -> [String]? {
        guard !DeviceTools.isSimulator else {
            return nil
        }
        // 获取并输出运营商信息
        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let currentRadioTechs = info.serviceCurrentRadioAccessTechnology else {
                return nil
            }
            return currentRadioTechs.allValues()
        } else {
            guard let currentRadioTech = info.currentRadioAccessTechnology else {
                return nil
            }
            return [currentRadioTech]
        }
    }

    /// 设备网络制式
    /// - Returns:网络
    static func networkTypes() -> [String]? {
        // 获取并输出运营商信息
        guard let currentRadioTechs = currentRadioAccessTechnologys() else {
            return nil
        }
        return currentRadioTechs.compactMap { getNetworkType(currentRadioTech: $0) }
    }

    /// 运营商名字
    /// - Returns:运营商名字
    static func carrierNames() -> [String]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.carrierName! }
    }

    /// 移动国家码(MCC)
    /// - Returns:移动国家码(MCC)
    static func mobileCountryCodes() -> [String]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.mobileCountryCode! }
    }

    /// 移动网络码(MNC)
    /// - Returns:移动网络码(MNC)
    static func mobileNetworkCodes() -> [String]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.mobileNetworkCode! }
    }

    /// ISO国家代码
    /// - Returns:ISO国家代码
    static func isoCountryCodes() -> [String]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map { $0.isoCountryCode! }
    }

    /// 是否允许VoIP
    /// - Returns:是否允许VoIP
    static func isAllowsVOIPs() -> [Bool]? {
        // 获取并输出运营商信息
        guard let carriers = getCarriers(), !carriers.isEmpty else {
            return nil
        }
        return carriers.map(\.allowsVOIP)
    }

    /// 获取并输出运营商信息
    /// - Returns:运营商信息
    private static func getCarriers() -> [CTCarrier]? {
        guard !Panda.dev.isSimulator else {
            return nil
        }
        // 获取并输出运营商信息
        let info = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            guard let providers = info.serviceSubscriberCellularProviders else {
                return []
            }
            return providers.filter { $0.value.carrierName != nil }.allValues()
        } else {
            guard let carrier = info.subscriberCellularProvider, carrier.carrierName != nil else {
                return []
            }
            return [carrier]
        }
    }

    /// 根据数据业务信息获取对应的网络类型
    /// - Parameter currentRadioTech:当前的无线电接入技术信息
    /// - Returns:网络类型
    private static func getNetworkType(currentRadioTech: String) -> String {
        /// 手机的数据业务对应的通信技术
        /// CTRadioAccessTechnologyGPRS:2G(有时又叫2.5G,介于2G和3G之间的过度技术)
        /// CTRadioAccessTechnologyEdge:2G (有时又叫2.75G,是GPRS到第三代移动通信的过渡)
        /// CTRadioAccessTechnologyWCDMA:3G
        /// CTRadioAccessTechnologyHSDPA:3G (有时又叫 3.5G)
        /// CTRadioAccessTechnologyHSUPA:3G (有时又叫 3.75G)
        /// CTRadioAccessTechnologyCDMA1x :2G
        /// CTRadioAccessTechnologyCDMAEVDORev0:3G
        /// CTRadioAccessTechnologyCDMAEVDORevA:3G
        /// CTRadioAccessTechnologyCDMAEVDORevB:3G
        /// CTRadioAccessTechnologyeHRPD:3G (有时又叫 3.75G,是电信使用的一种3G到4G的演进技术)
        /// CTRadioAccessTechnologyLTE:4G (或者说接近4G)
        /// // 5G:NR是New Radio的缩写,新无线(5G)的意思,NRNSA表示5G NR的非独立组网(NSA)模式.
        /// CTRadioAccessTechnologyNRNSA:5G NSA
        /// CTRadioAccessTechnologyNR:5G
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

    /// 获取运营商
    static var deviceSupplier: String {
        let info = CTTelephonyNetworkInfo()
        var supplier = ""
        if #available(iOS 12.0, *) {
            if let carriers = info.serviceSubscriberCellularProviders {
                if carriers.keys.isEmpty {
                    return "无手机卡"
                } else { // 获取运营商信息
                    for (index, carrier) in carriers.values.enumerated() {
                        guard carrier.carrierName != nil else {
                            return "无手机卡"
                        }
                        // 查看运营商信息 通过CTCarrier类
                        if index == 0 {
                            supplier = carrier.carrierName!
                        } else {
                            supplier = supplier + "," + carrier.carrierName!
                        }
                    }
                    return supplier
                }
            } else {
                return "无手机卡"
            }
        } else {
            if let carrier = info.subscriberCellularProvider {
                guard carrier.carrierName != nil else {
                    return "无手机卡"
                }
                return carrier.carrierName!
            } else {
                return "无手机卡"
            }
        }
    }
}

// MARK: - 设备控制
public extension UIDevice {
    /// 闪光灯是否打开
    static var flashIsOn: Bool {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("camera invalid, please check")
            return false
        }
        return device.torchMode == .on ? true : false
    }

    /// 是否打开闪光灯
    /// - Parameter on:是否打开
    static func flash(on: Bool) {
        // 获取摄像设备
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
