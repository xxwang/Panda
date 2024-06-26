//
//  UISearchBar+.swift
//
//
//  Created by xxwang on 2023/5/22.
//

import UIKit

// MARK: - 属性
public extension UISearchBar {
    /// 搜索栏中的`UITextField`(如果适用)
    var pd_textField: UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        }
        let subViews = subviews.flatMap(\.subviews)
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }

    /// 返回去除开头与结尾空字符的字符串
    var pd_trimmedText: String? {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - 方法
public extension UISearchBar {
    /// 清空内容
    func pd_clear() {
        self.text = ""
    }
}

// MARK: - Defaultable
public extension UISearchBar {
    typealias Associatedtype = UISearchBar

    @objc override class func `default`() -> Associatedtype {
        let searchBar = UISearchBar()
        return searchBar
    }
}

// MARK: - 链式语法
public extension UISearchBar {}
