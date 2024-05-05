import UIKit

public struct sizer {
    // MARK: - 屏幕
    public struct screen {
        public static var bounds: CGRect { return UIScreen.main.bounds }
        public static var size: CGSize { return self.bounds.size }
        public static var width: CGFloat { return self.bounds.width }
        public static var height: CGFloat { return self.bounds.height }
        private init() {}
    }

    // MARK: - 安全区
    public struct safeArea {
        public static var insets: UIEdgeInsets {
            if #available(iOS 11.0, *) {
                return UIWindow.main?.safeAreaInsets ?? .zero
            }
            return .zero
        }

        public static var top: CGFloat { return self.insets.top }
        public static var bottom: CGFloat { return self.insets.bottom }
        public static var left: CGFloat { return self.insets.left }
        public static var right: CGFloat { return self.insets.right }
        private init() {}
    }

    // MARK: - 导航栏
    public struct nav {
        public static var statusHeight: CGFloat {
            if #available(iOS 13.0, *) {
                if let statusbar = UIWindow.main?.windowScene?.statusBarManager {
                    return statusbar.statusBarFrame.size.height
                }

                return 0
            } else {
                return UIApplication.shared.statusBarFrame.size.height
            }
        }

        public static var titleHeight: CGFloat { 44 }
        public static var fullHeight: CGFloat { return self.statusHeight + self.titleHeight }
        private init() {}
    }

    // MARK: - 标签栏
    public struct tab {
        public static var tabHeight: CGFloat { 49 }
        public static var indentHeight: CGFloat { return safeArea.bottom }
        public static var fullHeight: CGFloat { return self.tabHeight + self.indentHeight }
        private init() {}
    }

    /// 设计图屏幕尺寸
    fileprivate static var sketchSize = CGSize(width: 375, height: 812)

    private init() {}
}

public extension sizer {
    /// 设置设计图尺寸
    static func setupSketch(size: CGSize) {
        self.sketchSize = size
    }
}

// MARK: - 屏幕适配
private extension sizer {
    /// 宽度比例
    static var wRatio: CGFloat {
        var sketchW = min(self.sketchSize.width, sketchSize.height)
        var screenW = min(self.screen.width, self.screen.height)
        if environment.isLandscape {
            sketchW = max(self.sketchSize.width, self.sketchSize.height)
            screenW = max(self.screen.width, self.screen.height)
        }
        return screenW / sketchW
    }

    /// 高度比例
    static var hRatio: CGFloat {
        var sketchH = max(self.sketchSize.width, self.sketchSize.height)
        var screenH = max(self.screen.width, self.screen.height)
        if environment.isLandscape {
            sketchH = min(self.sketchSize.width, sketchSize.height)
            screenH = min(self.screen.width, self.screen.height)
        }
        return screenH / sketchH
    }

    /// `Any`转`CGFloat`
    /// - Parameter value: 要转换的数据
    /// - Returns: 转换结果
    static func format(from value: Any) -> CGFloat {
        if let value = value as? CGFloat { return value }
        if let value = value as? Double { return value }
        if let value = value as? Float { return value.pd_cgFloat() }
        if let value = value as? Int { return value.pd_cgFloat() }
        return 0
    }

    /// 计算`宽度`
    static func calcWidth(from value: Any) -> CGFloat {
        return self.wRatio * self.format(from: value)
    }

    /// 计算`高度`
    static func calcHeight(from value: Any) -> CGFloat {
        return self.hRatio * self.format(from: value)
    }

    /// 计算`最大宽高`
    static func calcMax(from value: Any) -> CGFloat {
        return max(self.calcWidth(from: value), self.calcHeight(from: value))
    }

    /// 计算`最小宽高`
    static func calcMin(from value: Any) -> CGFloat {
        return min(self.calcWidth(from: value), self.calcHeight(from: value))
    }
}

// MARK: - 屏幕适配(整形)
public extension BinaryInteger {
    /// 适配宽度
    var wAuto: CGFloat { sizer.calcWidth(from: self) }

    /// 适配高度
    var hAuto: CGFloat { sizer.calcHeight(from: self) }

    /// 最大适配(特殊情况)
    var maxAuto: CGFloat { sizer.calcMax(from: self) }

    /// 最小适配(特殊情况)
    var minAuto: CGFloat { sizer.calcMin(from: self) }
}

// MARK: - 屏幕适配(浮点)
public extension BinaryFloatingPoint {
    /// 适配宽度
    var wAuto: CGFloat { sizer.calcWidth(from: self) }

    /// 适配高度
    var hAuto: CGFloat { sizer.calcHeight(from: self) }

    /// 最大适配(特殊情况)
    var maxAuto: CGFloat { sizer.calcMax(from: self) }

    /// 最小适配(特殊情况)
    var minAuto: CGFloat { sizer.calcMin(from: self) }
}
