//
//  UITableView+.swift
//  Panda-time
//
//  Created by 王斌 on 2023/5/22.
//

import UIKit

// MARK: - MJRefresh
// public extension UITableView {
//    /// 设置头部刷新控件(下拉刷新)
//    func setupHeaderRefreshing(refreshingCallback:@escaping MJRefreshComponentAction) {
//        let header = MJRefreshNormalHeader(refreshingBlock:refreshingCallback)
//        mj_header = header
//    }
//
//    /// 设置底部刷新控件(上拉加载更多)
//    func setupFooterRefreshing(refreshingCallback:@escaping MJRefreshComponentAction, noMoreDataText:String = "已经到底了") {
//        let footer = MJRefreshBackNormalFooter(refreshingBlock:refreshingCallback)
//        footer.setTitle(noMoreDataText, for:.noMoreData)
//        mj_footer = footer
//    }
//
//    /// 结束刷新动作
//    func endRefreshing(_ moreData:Bool = true) {
//        // 结束下拉刷新
//        endHeaderRefreshing()
//        // 结束上拉刷新
//        endFooterRefreshing(moreData)
//    }
//
//    /// 结束下拉刷新
//    func endHeaderRefreshing() {
//        mj_header?.endRefreshing()
//    }
//
//    /// 结束上拉刷新
//    func endFooterRefreshing(_ moreData:Bool) {
//        if moreData {
//            mj_footer?.endRefreshing()
//        } else {
//            mj_footer?.endRefreshingWithNoMoreData()
//        }
//    }
// }
