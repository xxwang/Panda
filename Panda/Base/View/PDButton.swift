//
//  PDButton.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/2.
//

import UIKit

open class PDButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 取消按住高亮
    override public var isHighlighted: Bool {
        didSet {
            super.isHighlighted = false
        }
    }
}
