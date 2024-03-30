//
//  UICollectionViewCell+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import UIKit

// MARK: - 属性
public extension UICollectionViewCell {
    /// 标识符(使用类名注册时)
    var identifier: String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Self.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }
}

// MARK: - 方法
public extension UICollectionViewCell {
    /// `cell`所在`UICollectionView`
    /// - Returns:`UICollectionView`, 未找到返回`nil`
    func findCollectionView() -> UICollectionView? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }
}

// MARK: - Defaultable
public extension UICollectionViewCell {
    typealias Associatedtype = UICollectionViewCell

    override class func `default`() -> Associatedtype {
        let cell = UICollectionViewCell()
        return cell
    }
}

// MARK: - 链式语法
public extension UITableViewCell {}
