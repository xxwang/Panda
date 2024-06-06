
import UIKit

public extension UIStackView {

    convenience init(
        arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0.0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}

public extension UIStackView {

    func sk_addSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        if #available(iOS 11.0, *) {
            self.setCustomSpacing(spacing, after: arrangedSubview)
        } else {
            let separatorView = UIView(frame: .zero)
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            switch axis {
            case .horizontal:
                separatorView.widthAnchor.constraint(equalToConstant: spacing).isActive = true
            case .vertical:
                separatorView.heightAnchor.constraint(equalToConstant: spacing).isActive = true
            default:
                print("unknown")
            }
            if let index = arrangedSubviews.firstIndex(of: arrangedSubview) {
                insertArrangedSubview(separatorView, at: index + 1)
            }
        }
    }

    func sk_addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }


    func sk_removeArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
        }
    }

    func sk_switch(_ view1: UIView, _ view2: UIView) {
        guard let view1Index = arrangedSubviews.firstIndex(of: view1),
              let view2Index = arrangedSubviews.firstIndex(of: view2) else { return }
        removeArrangedSubview(view1)
        insertArrangedSubview(view1, at: view2Index)

        removeArrangedSubview(view2)
        insertArrangedSubview(view2, at: view1Index)
    }

    func sk_swap(_ view1: UIView, _ view2: UIView,
                 animated: Bool = false,
                 duration: TimeInterval = 0.25,
                 delay: TimeInterval = 0,
                 options: UIView.AnimationOptions = .curveLinear,
                 completion: ((Bool) -> Void)? = nil)
    {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
                self.sk_switch(view1, view2)
                self.layoutIfNeeded()
            }, completion: completion)
        } else {
            self.sk_switch(view1, view2)
        }
    }
}

public extension UIStackView {
    typealias Associatedtype = UIStackView

    override class func `default`() -> Associatedtype {
        let stackView = UIStackView()
        return stackView
    }
}

public extension UIStackView {

    @discardableResult
    func sk_isBaselineRelativeArrangement(_ arrangement: Bool) -> Self {
        isBaselineRelativeArrangement = arrangement
        return self
    }

    @discardableResult
    func sk_isLayoutMarginsRelativeArrangement(_ arrangement: Bool) -> Self {
        isLayoutMarginsRelativeArrangement = arrangement
        return self
    }

    @discardableResult
    func sk_axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }

    @discardableResult
    func sk_distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }

    @discardableResult
    func sk_alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }

    @discardableResult
    func sk_spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

    @discardableResult
    func sk_addArrangedSubviews(_ items: UIView...) -> Self {
        if items.isEmpty {
            return self
        }

        items.compactMap { $0 }.forEach {
            addArrangedSubview($0)
        }
        return self
    }
}
