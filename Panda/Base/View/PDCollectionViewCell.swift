//
//  PDCollectionViewCell.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import UIKit

open class PDCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.pd_backgroundColor(.clear)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
