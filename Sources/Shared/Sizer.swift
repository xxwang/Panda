import UIKit

public struct sizer {
    public struct screen {
        public static var bounds: CGRect { return UIScreen.main.bounds }
        public static var size: CGSize { return self.bounds.size }
        public static var width: CGFloat { return self.bounds.width }
        public static var height: CGFloat { return self.bounds.height }
        private init() {}
    }

    public struct safeArea {
        public static var insets: UIEdgeInsets {
            if #available(iOS 11.0, *) {
                return UIWindow.xx_main?.safeAreaInsets ?? .zero
            }
            return .zero
        }

        public static var top: CGFloat { return self.insets.top }
        public static var bottom: CGFloat { return self.insets.bottom }
        public static var left: CGFloat { return self.insets.left }
        public static var right: CGFloat { return self.insets.right }
        private init() {}
    }

    public struct nav {
        public static var statusHeight: CGFloat {
            if #available(iOS 13.0, *) {
                if let statusbar = UIWindow.xx_main?.windowScene?.statusBarManager {
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

    public struct tab {
        public static var tabHeight: CGFloat { 49 }
        public static var indentHeight: CGFloat { return safeArea.bottom }
        public static var fullHeight: CGFloat { return self.tabHeight + self.indentHeight }
        private init() {}
    }

    fileprivate static var sketchSize = CGSize(width: 375, height: 812)

    private init() {}
}

public extension sizer {
    static func setupSketch(size: CGSize) {
        self.sketchSize = size
    }
}

private extension sizer {
    static var wRatio: CGFloat {
        var sketchW = min(self.sketchSize.width, sketchSize.height)
        var screenW = min(self.screen.width, self.screen.height)
        if environment.isLandscape {
            sketchW = max(self.sketchSize.width, self.sketchSize.height)
            screenW = max(self.screen.width, self.screen.height)
        }
        return screenW / sketchW
    }

    static var hRatio: CGFloat {
        var sketchH = max(self.sketchSize.width, self.sketchSize.height)
        var screenH = max(self.screen.width, self.screen.height)
        if environment.isLandscape {
            sketchH = min(self.sketchSize.width, sketchSize.height)
            screenH = min(self.screen.width, self.screen.height)
        }
        return screenH / sketchH
    }

    static func format(from value: Any) -> CGFloat {
        if let value = value as? CGFloat { return value }
        if let value = value as? Double { return value }
        if let value = value as? Float { return value.xx_cgFloat() }
        if let value = value as? Int { return value.xx_cgFloat() }
        return 0
    }

    static func calcWidth(from value: Any) -> CGFloat {
        return self.wRatio * self.format(from: value)
    }

    static func calcHeight(from value: Any) -> CGFloat {
        return self.hRatio * self.format(from: value)
    }

    static func calcMax(from value: Any) -> CGFloat {
        return max(self.calcWidth(from: value), self.calcHeight(from: value))
    }

    static func calcMin(from value: Any) -> CGFloat {
        return min(self.calcWidth(from: value), self.calcHeight(from: value))
    }
}

public extension BinaryInteger {
    var wAuto: CGFloat { sizer.calcWidth(from: self) }
    var hAuto: CGFloat { sizer.calcHeight(from: self) }
    var maxAuto: CGFloat { sizer.calcMax(from: self) }
    var minAuto: CGFloat { sizer.calcMin(from: self) }
}

public extension BinaryFloatingPoint {
    var wAuto: CGFloat { sizer.calcWidth(from: self) }
    var hAuto: CGFloat { sizer.calcHeight(from: self) }
    var maxAuto: CGFloat { sizer.calcMax(from: self) }
    var minAuto: CGFloat { sizer.calcMin(from: self) }
}
