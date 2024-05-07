import UIKit

private class AssociateKeys {
    static let SmartPeelingTimeIntervalKey = "SmartPeelingTimeIntervalKey"
    static let DarkToSystemKey = "DarkToSystemKey"
    static let LightDarkKey = "LightDarkKey"
    static let SmartPeelingKey = "SmartPeelingKey"
}

public class DarkModeUtils: NSObject {
    public static var isLight: Bool {
        if isSmartPeeling {
            return isSmartPeelingTime() ? false : true
        }
        if let value = UserDefaults.standard.value(forKey: AssociateKeys.LightDarkKey) as? Bool {
            return value
        }
        UserDefaults.resetStandardUserDefaults()
        return true
    }

    public static var isFollowSystem: Bool {
        if #available(iOS 13, *) {
            if let value = UserDefaults.standard.value(forKey: AssociateKeys.DarkToSystemKey) as? Bool {
                return value
            }
            return true
        }
        return false
    }

    public static var isSmartPeeling: Bool {
        if let value = UserDefaults.standard.value(forKey: AssociateKeys.SmartPeelingKey) as? Bool {
            return value
        }
        return false
    }

    public static var SmartPeelingTimeIntervalValue: String {
        get {
            if let value = UserDefaults.standard.value(forKey: AssociateKeys.SmartPeelingTimeIntervalKey) as? String {
                return value
            }
            return "21:00~8:00"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AssociateKeys.SmartPeelingTimeIntervalKey)
            UserDefaults.standard.synchronize()
        }
    }
}

extension DarkModeUtils: Skinable {
    public func apply() {}
}

public extension DarkModeUtils {
    static func defaultDark() {
        if #available(iOS 13.0, *) {
            if DarkModeUtils.isFollowSystem {
                DarkModeUtils.setDarkModeFollowSystem(isFollowSystem: true)
            } else {
                UIWindow.pd_main?.overrideUserInterfaceStyle = DarkModeUtils.isLight ? .light : .dark
            }
        }
    }

    static func setDarkModeFollowSystem(isFollowSystem: Bool) {
        if #available(iOS 13.0, *) {
            UserDefaults.standard.set(isFollowSystem, forKey: AssociateKeys.DarkToSystemKey)

            let result = UITraitCollection.current.userInterfaceStyle == .light ? true : false
            UserDefaults.standard.set(result, forKey: AssociateKeys.LightDarkKey)
            UserDefaults.standard.set(false, forKey: AssociateKeys.SmartPeelingKey)

            UserDefaults.standard.synchronize()

            if isFollowSystem {
                UIWindow.pd_main?.overrideUserInterfaceStyle = .unspecified
            } else {
                UIWindow.pd_main?.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            }
        }
    }

    static func setDarkModeCustom(isLight: Bool) {
        if #available(iOS 13.0, *) {
            UIWindow.pd_main?.overrideUserInterfaceStyle = isLight ? .light : .dark
            UserDefaults.standard.set(false, forKey: AssociateKeys.DarkToSystemKey)
            UserDefaults.standard.set(false, forKey: AssociateKeys.SmartPeelingKey)
            UserDefaults.standard.set(isLight, forKey: AssociateKeys.LightDarkKey)
        } else {
            UserDefaults.standard.set(false, forKey: AssociateKeys.SmartPeelingKey)
            UserDefaults.standard.set(isLight, forKey: AssociateKeys.LightDarkKey)
            SkinManager.shared.updateSkin()
        }
        UserDefaults.standard.synchronize()
    }

    static func setSmartPeelingDarkMode(isSmartPeeling: Bool) {
        if #available(iOS 13.0, *) {
            UserDefaults.standard.set(isSmartPeeling, forKey: AssociateKeys.SmartPeelingKey)
            UIWindow.pd_main?.overrideUserInterfaceStyle = isLight ? .light : .dark
            UserDefaults.standard.set(false, forKey: AssociateKeys.DarkToSystemKey)
            UserDefaults.standard.set(isLight, forKey: AssociateKeys.LightDarkKey)
        } else {
            UserDefaults.standard.set(isSmartPeeling, forKey: AssociateKeys.SmartPeelingKey)
            UserDefaults.standard.set(isLight, forKey: AssociateKeys.LightDarkKey)
            SkinManager.shared.updateSkin()
        }
    }

    static func setSmartPeelingTimeChange(startTime: String, endTime: String) {
        var light = false
        if DarkModeUtils.isSmartPeelingTime(startTime: startTime, endTime: endTime), DarkModeUtils.isLight {
            light = false
        } else {
            if !DarkModeUtils.isLight {
                light = true
            } else {
                DarkModeUtils.SmartPeelingTimeIntervalValue = startTime + "~" + endTime
                return
            }
        }
        DarkModeUtils.SmartPeelingTimeIntervalValue = startTime + "~" + endTime

        if #available(iOS 13.0, *) {
            UIWindow.pd_main?.overrideUserInterfaceStyle = light ? .light : .dark
            UserDefaults.standard.set(light, forKey: AssociateKeys.LightDarkKey)
        } else {
            UserDefaults.standard.set(light, forKey: AssociateKeys.LightDarkKey)
            SkinManager.shared.updateSkin()
        }
    }
}

public extension DarkModeUtils {

    static func darkModeColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                if DarkModeUtils.isFollowSystem {
                    if traitCollection.userInterfaceStyle == .light {
                        return lightColor
                    } else {
                        return darkColor
                    }
                } else if DarkModeUtils.isSmartPeeling {
                    return isSmartPeelingTime() ? darkColor : lightColor
                } else {
                    return DarkModeUtils.isLight ? lightColor : darkColor
                }
            }
        } else {
            if DarkModeUtils.isLight {
                return lightColor
            }
            return darkColor
        }
    }

    static func isSmartPeelingTime(startTime: String? = nil, endTime: String? = nil) -> Bool {
        var timeIntervalValue: [String] = []
        if startTime != nil, endTime != nil {
            timeIntervalValue = [startTime!, endTime!]
        } else {
            timeIntervalValue = DarkModeUtils.SmartPeelingTimeIntervalValue.pd_split(with: "~")
        }

        let currentDate = Date.pd_now()
        let currentTimeStamp = Int(currentDate.pd_dateAsTimestamp())!
        let dateString = currentDate.pd_string(with: "yyyy-MM-dd", isGMT: false)
        let startTimeStamp = (dateString + " " + timeIntervalValue[0])
            .pd_date(with: "yyyy-MM-dd HH:mm")?
            .pd_secondStamp()
            .pd_int() ?? 0
        var endTimeStamp = (dateString + " " + timeIntervalValue[1])
            .pd_date(with: "yyyy-MM-dd HH:mm")?
            .pd_secondStamp()
            .pd_int() ?? 0

        if startTimeStamp > endTimeStamp {
            endTimeStamp = endTimeStamp + 884_600
        }
        return currentTimeStamp >= startTimeStamp && currentTimeStamp <= endTimeStamp
    }
}

public extension DarkModeUtils {

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
            if DarkModeUtils.isLight {
                return light
            }
            return dark
        }
    }
}
