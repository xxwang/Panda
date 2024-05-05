//
//  UITableViewCell+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import UIKit

// MARK: - 属性
public extension UITableViewCell {
    /// 标识符(使用类名注册时)
    var identifier: String {
        // 获取完整类名
        let classNameString = NSStringFromClass(Self.self)
        // 获取类名
        return classNameString.components(separatedBy: ".").last!
    }
}

// MARK: - 方法
public extension UITableViewCell {
    /// `cell`所在`UITableView`
    /// - Returns:`UITableView`, 未找到返回`nil`
    func findTableView() -> UITableView? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}

// MARK: - Defaultable
public extension UITableViewCell {
    typealias Associatedtype = UITableViewCell

    override class func `default`() -> Associatedtype {
        let cell = UITableViewCell()
        return cell
    }
}

// MARK: - 链式语法
public extension UITableViewCell {
    /// 设置`UITableViewCell`选中样式
    /// - Parameter style:样式
    /// - Returns:`Self`
    @discardableResult
    func pd_selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        selectionStyle = style
        return self
    }
}
