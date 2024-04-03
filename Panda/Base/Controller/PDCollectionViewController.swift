//
//  PDCollectionViewController.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import UIKit

open class PDCollectionViewController: PDViewController {
    /// `UICollectionView`布局
    public lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()

    /// `UICollectionView`
    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
            .pd_dataSource(self)
            .pd_delegate(self)
            .pd_bounces(true)
            .pd_isPagingEnabled(false)
            .pd_isScrollEnabled(true)
            .pd_showsHorizontalScrollIndicator(false)
            .pd_showsVerticalScrollIndicator(false)
            .pd_backgroundColor(.clear)
        return collectionView
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()

        // 添加到导航栏下面 确保导航栏阴影可以正常显示
        self.view.insertSubview(collectionView, belowSubview: navigationBar)
        self.collectionView.pd_frame(CGRect(
            x: 0,
            y: self.navigationBar.isHidden ? 0 : self.navigationBar.pd_height,
            width: self.view.pd_width,
            height: self.view.pd_height - (self.navigationBar.isHidden ? 0 : self.navigationBar.pd_height)
        ))
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension PDCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return PDCollectionViewCell()
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }

    /// 滚动方向
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }

    /// 滚动垂直方向
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return PDCollectionReusableView()
    }
}
