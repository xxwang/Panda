
import UIKit


public extension UISegmentedControl {

    var xx_images: [UIImage] {
        get {
            let range = 0 ..< numberOfSegments
            return range.compactMap { self.imageForSegment(at: $0) }
        }
        set {
            removeAllSegments()
            for (index, image) in newValue.enumerated() {
                insertSegment(with: image, at: index, animated: false)
            }
        }
    }

    var xx_titles: [String] {
        get {
            let range = 0 ..< numberOfSegments
            return range.compactMap { self.titleForSegment(at: $0) }
        }
        set {
            removeAllSegments()
            for (index, title) in newValue.enumerated() {
                insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }
}


public extension UISegmentedControl {
    typealias Associatedtype = UISegmentedControl

    @objc override class func `default`() -> Associatedtype {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
    }
}


public extension UISegmentedControl {}
