//
//  UISegmentedControl+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import UIKit

// MARK: - 属性
public extension UISegmentedControl {
    /// 图片数组
    var pd_images: [UIImage] {
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

    /// 标题数组
    var pd_titles: [String] {
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

// MARK: - Defaultable
public extension UISegmentedControl {
    typealias Associatedtype = UISegmentedControl

    @objc override class func `default`() -> Associatedtype {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
    }
}

// MARK: - 链式语法
public extension UISegmentedControl {}
