//
//  PDTitleBar.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/3.
//

import UIKit
import Panda

 class PDTitleBar: UIImageView {
    /// 返回按钮点击回调
    private var backCallback: (() -> Void)?

    /// 返回按钮
    lazy var backButton: UIButton = {
        let button = UIButton.default()
            .addTapAction(self, #selector(backButtonClick(sender:)))
        return button
    }()

    /// 标题
    lazy var titleLabel: UILabel = {
        let label = UILabel.default()
            .pd_font(.boldSystemFont(ofSize: 18))
            .pd_textColor(.black)
            .pd_contentMode(.center)
        return label
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.pd_isUserInteractionEnabled(true)
            .pd_contentMode(.scaleAspectFill)

        self.backButton.add2(self)
        self.titleLabel.add2(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !self.titleLabel.isHidden {
            let size = self.titleLabel.strSize()
            self.titleLabel.pd_frame(CGRect(center: self.center, size: size))
        }

        if !backButton.isHidden {
            let left = max(10, SizeUtils.safeAreaInsets.left)
            let top = (self.pd_height - 40) / 2
            backButton.pd_frame(CGRect(origin: CGPoint(x: left, y: top), size: 44.toCGSize()))
        }
    }
}

private extension PDTitleBar {
    @objc func backButtonClick(sender: UIButton) {
        if let callback = self.backCallback {
            callback()
        }
    }
}

extension PDTitleBar {
    /// 隐藏返回按钮
    /// - Parameter hidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func hiddenBackButton(_ isHidden: Bool) -> Self {
        self.backButton.pd_isHidden(isHidden)
        self.relayout()
        return self
    }

    /// 设置返回按钮图标
    /// - Parameters:
    ///   - image: 图片
    ///   - state: 状态
    /// - Returns: `Self`
    @discardableResult
    func backButtonImage(_ image: UIImage?, for state: UIButton.State) -> Self {
        self.backButton.pd_image(image, for: state)
        return self
    }

    /// 设置返回按钮点击回调
    /// - Parameters:
    ///   - backCallback: 返回按钮点击回调
    /// - Returns: `Self`
    @discardableResult
    func backButtonCallback(_ backCallback: (() -> Void)?) -> Self {
        self.backCallback = backCallback
        return self
    }

    /// 设置属性标题
    /// - Parameter attributeTitle: 属性字符串标题
    /// - Returns: `Self`
    @discardableResult
    func attributeTitle(_ attributeTitle: NSAttributedString?) -> Self {
        self.titleLabel.pd_attributedText(attributeTitle)
        self.relayout()
        return self
    }

    /// 设置标题栏标题
    /// - Parameter title: 标题
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        self.titleLabel.pd_text(title)
        self.relayout()
        return self
    }

    /// 设置标题字体
    /// - Parameter font: 标题字体
    /// - Returns: `Self`
    @discardableResult
    func titleFont(_ font: UIFont) -> Self {
        self.titleLabel.pd_font(font)
        self.relayout()
        return self
    }

    /// 设置标题栏标题颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func titleColor(_ color: UIColor?) -> Self {
        self.titleLabel.pd_textColor(color ?? .clear)
        return self
    }
}
