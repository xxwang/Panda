//
//  PDStatusBar.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/3.
//

import UIKit

public class PDStatusBar: UIImageView {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.pd_isUserInteractionEnabled(true)
            .pd_contentMode(.scaleAspectFill)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
