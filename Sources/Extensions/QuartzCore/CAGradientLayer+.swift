
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

        pd_frame(frame)
            .pd_colors(colors)
            .pd_locations(locations ?? [])
            .pd_start(start)
            .pd_end(end)
            .pd_type(type)
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
    func pd_colors(_ colors: [UIColor]) -> Self {
        let cgColors = colors.map(\.cgColor)
        self.colors = cgColors
        return self
    }

    @discardableResult
    func pd_locations(_ locations: [CGFloat] = [0, 1]) -> Self {
        let locationNumbers = locations.map { flt in
            NSNumber(floatLiteral: flt)
        }
        self.locations = locationNumbers
        return self
    }

    @discardableResult
    func pd_start(_ startPoint: CGPoint = .zero) -> Self {
        self.startPoint = startPoint
        return self
    }

    @discardableResult
    func pd_end(_ endPoint: CGPoint = .zero) -> Self {
        self.endPoint = endPoint
        return self
    }

    @discardableResult
    func pd_type(_ type: CAGradientLayerType) -> Self {
        self.type = type
        return self
    }
}
