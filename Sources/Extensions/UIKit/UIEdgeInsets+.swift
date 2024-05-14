
import UIKit

public extension UIEdgeInsets {

    var xx_horizontal: CGFloat {
        return self.left + self.right
    }

    var xx_vertical: CGFloat {
        return self.top + self.bottom
    }
}

public extension UIEdgeInsets {

    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical / 2, left: horizontal / 2, bottom: vertical / 2, right: horizontal / 2)
    }
}

public extension UIEdgeInsets {
    typealias Associatedtype = UIEdgeInsets

    static func `default`() -> Associatedtype {
        UIEdgeInsets.zero
    }
}

public extension UIEdgeInsets {

    @discardableResult
    func xx_insetBy(top: CGFloat) -> Self {
        return UIEdgeInsets(top: self.top + top, left: left, bottom: bottom, right: right)
    }

    @discardableResult
    func xx_insetBy(left: CGFloat) -> Self {
        return UIEdgeInsets(top: top, left: self.left + left, bottom: bottom, right: right)
    }

    @discardableResult
    func xx_insetBy(bottom: CGFloat) -> Self {
        return UIEdgeInsets(top: top, left: left, bottom: self.bottom + bottom, right: right)
    }

    @discardableResult
    func xx_insetBy(right: CGFloat) -> Self {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: self.right + right)
    }

    @discardableResult
    func xx_insetBy(horizontal: CGFloat) -> Self {
        return UIEdgeInsets(top: top, left: left + horizontal / 2, bottom: bottom, right: right + horizontal / 2)
    }

    @discardableResult
    func xx_insetBy(vertical: CGFloat) -> Self {
        return UIEdgeInsets(top: top + vertical / 2, left: left, bottom: bottom + vertical / 2, right: right)
    }
}

public extension UIEdgeInsets {

    static func == (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> Bool {
        return lhs.top == rhs.top &&
            lhs.left == rhs.left &&
            lhs.bottom == rhs.bottom &&
            lhs.right == rhs.right
    }

    static func + (_ lhs: UIEdgeInsets, _ rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top + rhs.top,
                            left: lhs.left + rhs.left,
                            bottom: lhs.bottom + rhs.bottom,
                            right: lhs.right + rhs.right)
    }

    static func += (_ lhs: inout UIEdgeInsets, _ rhs: UIEdgeInsets) {
        lhs.top += rhs.top
        lhs.left += rhs.left
        lhs.bottom += rhs.bottom
        lhs.right += rhs.right
    }
}
