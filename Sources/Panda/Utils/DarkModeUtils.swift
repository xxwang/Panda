//
//  DarkModeUtils.swift
//
//
//  Created by 王斌 on 2023/5/29.
//

import UIKit

/*
 默认开启:跟随系统模式

 1、跟随系统
 1.1、需要设置:
 UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.overrideUserInterfaceStyle = .unspecified
 2、不跟随系统
 2.1、浅色,UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.overrideUserInterfaceStyle = .light
 2.2、深色,UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.overrideUserInterfaceStyle = .dark
 */
public class DarkModeUtils: NSObject {
    /// 智能换肤的时间区间的key
    private static let CMSmartPeelingTimeIntervalKey = "CMSmartPeelingTimeIntervalKey"
    /// 跟随系统的key
    private static let CMDarkToSystemKey = "CMDarkToSystemKey"
    /// 是否浅色模式的key
    private static let CMLightDarkKey = "CMLightDarkKey"
    /// 智能换肤的key
    private static let CMSmartPeelingKey = "CMSmartPeelingKey"
    /// 是否浅色
    public static var isLight: Bool {
        if isSmartPeeling {
            return isSmartPeelingTime() ? false : true
        }
        if let value = UserDefaults.value(for: CMLightDarkKey) as? Bool {
            return value
        }
        UserDefaults.resetStandardUserDefaults()
        return true
    }

    /// 是否跟随系统
    public static var isFollowSystem: Bool {
        if #available(iOS 13, *) {
            if let value = UserDefaults.value(for: CMDarkToSystemKey) as? Bool {
                return value
            }
            return true
        }
        return false
    }

    /// 默认不是智能换肤
    public static var isSmartPeeling: Bool {
        if let value = UserDefaults.value(for: CMSmartPeelingKey) as? Bool {
            return value
        }
        return false
    }

    /// 智能换肤的时间段:默认是:21:00~8:00
    public static var SmartPeelingTimeIntervalValue: String {
        get {
            if let value = UserDefaults.value(for: CMSmartPeelingTimeIntervalKey) as? String {
                return value
            }
            return "21:00~8:00"
        }
        set {
            UserDefaults.save(newValue, for: CMSmartPeelingTimeIntervalKey)
        }
    }
}

// MARK: - 方法的调用
extension DarkModeUtils: Skinable {
    public func apply() {}
}

public extension DarkModeUtils {
    /// 初始化的调用
    static func defaultDark() {
        if #available(iOS 13.0, *) {
            // 默认跟随系统暗黑模式开启监听
            if DarkModeManager.isFollowSystem {
                DarkModeManager.setDarkModeFollowSystem(isFollowSystem: true)
            } else {
                UIWindow.mainWindow?.overrideUserInterfaceStyle = DarkModeManager.isLight ? .light : .dark
            }
        }
    }

    /// 设置系统是否跟随
    static func setDarkModeFollowSystem(isFollowSystem: Bool) {
        if #available(iOS 13.0, *) {
            // 设置是否跟随系统
            UserDefaults.save(isFollowSystem, for: CMDarkToSystemKey)
            let result = UITraitCollection.current.userInterfaceStyle == .light ? true : false
            UserDefaults.save(result, for: CMLightDarkKey)
            UserDefaults.save(false, for: CMSmartPeelingKey)
            // 设置模式的保存
            if isFollowSystem {
                UIWindow.mainWindow?.overrideUserInterfaceStyle = .unspecified
            } else {
                UIWindow.mainWindow?.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            }
        }
    }

    /// 设置:浅色 / 深色
    static func setDarkModeCustom(isLight: Bool) {
        if #available(iOS 13.0, *) {
            // 只要设置了模式:就是黑或者白
            UIWindow.mainWindow?.overrideUserInterfaceStyle = isLight ? .light : .dark
            // 设置跟随系统和智能换肤:否
            UserDefaults.save(false, for: CMDarkToSystemKey)
            UserDefaults.save(false, for: CMSmartPeelingKey)
            // 黑白模式的设置
            UserDefaults.save(isLight, for: CMLightDarkKey)
        } else {
            UserDefaults.save(false, for: CMSmartPeelingKey)
            // 模式存储
            UserDefaults.save(isLight, for: CMLightDarkKey)
            // 通知模式更新
            SkinManager.shared.updateSkin()
        }
    }

    /// 智能换肤
    /// - Parameter isSmartPeeling:是否智能换肤
    static func setSmartPeelingDarkMode(isSmartPeeling: Bool) {
        if #available(iOS 13.0, *) {
            // 设置智能换肤
            UserDefaults.save(isSmartPeeling, for: CMSmartPeelingKey)
            // 智能换肤根据时间段来设置:黑或者白
            UIWindow.mainWindow?.overrideUserInterfaceStyle = isLight ? .light : .dark
            // 设置跟随系统:否
            UserDefaults.save(false, for: CMDarkToSystemKey)
            UserDefaults.save(isLight, for: CMLightDarkKey)
        } else {
            // 模式存储
            // 设置智能换肤
            UserDefaults.save(isSmartPeeling, for: CMSmartPeelingKey)
            // 设置跟随系统:否
            UserDefaults.save(isLight, for: CMLightDarkKey)
            // 通知模式更新
            SkinManager.shared.updateSkin()
        }
    }

    /// 智能换肤时间选择后
    static func setSmartPeelingTimeChange(startTime: String, endTime: String) {
        /// 是否是浅色
        var light = false
        if DarkModeManager.isSmartPeelingTime(startTime: startTime, endTime: endTime), DarkModeManager.isLight {
            light = false
        } else {
            if !DarkModeManager.isLight {
                light = true
            } else {
                DarkModeManager.SmartPeelingTimeIntervalValue = startTime + "~" + endTime
                return
            }
        }
        DarkModeManager.SmartPeelingTimeIntervalValue = startTime + "~" + endTime

        if #available(iOS 13.0, *) {
            // 只要设置了模式:就是黑或者白
            UIWindow.mainWindow?.overrideUserInterfaceStyle = light ? .light : .dark
            // 黑白模式的设置
            UserDefaults.save(light, for: CMLightDarkKey)
        } else {
            // 模式存储
            UserDefaults.save(light, for: CMLightDarkKey)
            // 通知模式更新
            SkinManager.shared.updateSkin()
        }
    }
}

// MARK: - 动态颜色的使用
public extension DarkModeUtils {
    /// 深色模式和浅色模式颜色设置,非layer颜色设置
    /// - Parameters:
    ///   - lightColor:浅色模式的颜色
    ///   - darkColor:深色模式的颜色
    /// - Returns:返回一个颜色(UIColor)
    static func darkModeColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                if DarkModeManager.isFollowSystem {
                    if traitCollection.userInterfaceStyle == .light {
                        return lightColor
                    } else {
                        return darkColor
                    }
                } else if DarkModeManager.isSmartPeeling {
                    return isSmartPeelingTime() ? darkColor : lightColor
                } else {
                    return DarkModeManager.isLight ? lightColor : darkColor
                }
            }
        } else {
            // iOS 13 以下主题色的使用
            if DarkModeManager.isLight {
                return lightColor
            }
            return darkColor
        }
    }

    /// 是否为智能换肤的时间:黑色
    /// - Returns:结果
    static func isSmartPeelingTime(startTime: String? = nil, endTime: String? = nil) -> Bool {
        // 获取暗黑模式时间的区间,转为两个时间戳,取出当前的时间戳,看是否在区间内,在的话:黑色,否则白色
        var timeIntervalValue: [String] = []
        if startTime != nil, endTime != nil {
            timeIntervalValue = [startTime!, endTime!]
        } else {
            timeIntervalValue = DarkModeManager.SmartPeelingTimeIntervalValue.split(with: "~")
        }
        // 1、时间区间分隔为:开始时间 和 结束时间
        // 2、当前的时间转时间戳
        let currentDate = Date()
        let currentTimeStamp = Int(currentDate.dateAsTimestamp())!
        let dateString = currentDate.format("yyyy-MM-dd", isGMT: false)
        let startTimeStamp = Int(Date.dateStringAsTimestamp(timesString: dateString + " " + timeIntervalValue[0], formatter: "yyyy-MM-dd HH:mm", isUnix: true))!
        var endTimeStamp = Int(Date.dateStringAsTimestamp(timesString: dateString + " " + timeIntervalValue[1], formatter: "yyyy-MM-dd HH:mm", isUnix: true))!
        if startTimeStamp > endTimeStamp {
            endTimeStamp = endTimeStamp + 884_600
        }
        return currentTimeStamp >= startTimeStamp && currentTimeStamp <= endTimeStamp
    }
}

// MARK: - 动态图片的使用
public extension DarkModeUtils {
    /// 深色图片和浅色图片切换 (深色模式适配)
    /// - Parameters:
    ///   - light:浅色模式的图片
    ///   - dark:深色模式的图片
    /// - Returns:最终图片
    static func darkModeImage(light: UIImage?, dark: UIImage?) -> UIImage? {
        if #available(iOS 13.0, *) {
            guard let weakLight = light,
                  let weakDark = dark,
                  let config = weakLight.configuration
            else {
                return light
            }
            let lightImage = weakLight.withConfiguration(config.withTraitCollection(UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.light)))
            lightImage.imageAsset?.register(weakDark, with: config.withTraitCollection(UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.dark)))
            return lightImage.imageAsset?.image(with: UITraitCollection.current) ?? light
        } else {
            // iOS 13 以下主题色的使用
            if DarkModeUtils.isLight {
                return light
            }
            return dark
        }
    }
}
