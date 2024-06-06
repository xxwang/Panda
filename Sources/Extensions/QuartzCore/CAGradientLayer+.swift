
import QuartzCore
import UIKit

public extension CAGradientLayer {
    convenience init(_ frame: CGRect = .zero,
                     colors: [UIColor],
                     locations: [CGFloat]? = nil,
                     start: CGPoint,
                     end: CGPoint,
                     type: CAGradientLayerType = .axial)
    {
        self.init()

        sk_frame(frame)
            .sk_colors(colors)
            .sk_locations(locations ?? [])
            .sk_start(start)
            .sk_end(end)
            .sk_type(type)
    }
}

public extension CAGradientLayer {
    typealias Associatedtype = CAGradientLayer

    override class func `default`() -> Associatedtype {
        let layer = CAGradientLayer()
        return layer
    }
}

public extension CAGradientLayer {
    @discardableResult
    func sk_colors(_ colors: [UIColor]) -> Self {
        let cgColors = colors.map(\.cgColor)
        self.colors = cgColors
        return self
    }

    @discardableResult
    func sk_locations(_ locations: [CGFloat] = [0, 1]) -> Self {
        let locationNumbers = locations.map { flt in
            NSNumber(floatLiteral: flt)
        }
        self.locations = locationNumbers
        return self
    }

    @discardableResult
    func sk_start(_ startPoint: CGPoint = .zero) -> Self {
        self.startPoint = startPoint
        return self
    }

    @discardableResult
    func sk_end(_ endPoint: CGPoint = .zero) -> Self {
        self.endPoint = endPoint
        return self
    }

    @discardableResult
    func sk_type(_ type: CAGradientLayerType) -> Self {
        self.type = type
        return self
    }
}
