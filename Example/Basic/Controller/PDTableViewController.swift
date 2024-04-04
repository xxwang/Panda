//
//  PDTableViewController.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import Panda
import UIKit

class PDTableViewController: PDViewController {
    /// 列表视图
    lazy var tableView: UITableView = {
        let tableView = UITableView.default()
            .pd_backgroundColor(.clear)
            .pd_dataSource(self)
            .pd_delegate(self)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加到导航栏下面 确保导航栏阴影可以正常显示
        self.view.insertSubview(tableView, belowSubview: navigationBar)
        self.tableView.pd_frame(CGRect(
            x: 0,
            y: self.navigationBar.isHidden ? 0 : self.navigationBar.pd_height,
            width: self.view.pd_width,
            height: self.view.pd_height
        ))
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PDTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return PDTableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {}
}
