//
//  IndexPath+.swift
//
//
//  Created by 王斌 on 2023/5/20.
//

import UIKit

public extension IndexPath {
    /// 字符串描述
    /// - Returns: `String`
    func toString() -> String {
        String(format: "{section: %d, row: %d}", section, row)
    }

    /// 当前`IndexPath`的前一个
    func previousIndexPath(_ view: Any) -> IndexPath? {
        if let tableView = view as? UITableView {
            var maxSectionNum = tableView.numberOfSections - 1
            if row > 0 {
                return IndexPath(row: row - 1, section: section)
            } else if row == 0, section > 0 {
                let lastRow = tableView.numberOfRows(inSection: section - 1) - 1
                return IndexPath(row: lastRow, section: section - 1)
            }
        } else if let collectionView = view as? UICollectionView {
            if row > 0 {
                return IndexPath(item: item - 1, section: section)
            } else if row == 0, section > 0 {
                let lastItem = collectionView.numberOfItems(inSection: section - 1) - 1
                return IndexPath(item: lastItem, section: section - 1)
            }
        }
        return nil
    }

    /// 当前`IndexPath`的下一个
    func nextIndexPath(_ view: Any) -> IndexPath? {
        if let tableView = view as? UITableView {
            var maxSectionIndex = tableView.numberOfSections - 1
            var maxRowInSection = tableView.numberOfRows(inSection: section) - 1

            if row < maxRowInSection {
                return IndexPath(row: row + 1, section: section)
            } else if row == maxRowInSection, section < maxSectionIndex {
                return IndexPath(row: 0, section: section + 1)
            }
        } else if let collectionView = view as? UICollectionView {
            var maxSectionIndex = collectionView.numberOfSections - 1
            var maxItemInSection = collectionView.numberOfItems(inSection: section) - 1

            if row < maxItemInSection {
                return IndexPath(item: item + 1, section: section)
            } else if row == maxItemInSection, section < maxSectionIndex {
                return IndexPath(item: 0, section: section + 1)
            }
        }
        return nil
    }
}
