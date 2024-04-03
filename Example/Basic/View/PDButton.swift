//
//  PDButton.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import UIKit

 class PDButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 取消按住高亮
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = false
        }
    }
}
