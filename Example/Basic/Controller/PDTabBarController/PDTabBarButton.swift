//
//  PDTabBarButton.swift
//  Example
//
//  Created by 奥尔良小短腿 on 2024/4/4.
//

import Panda
import UIKit

class PDTabBarButton: PDControl {
    // 图标
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.default()
            .pd_contentMode(.scaleAspectFit)
        return imageView
    }()

    // 标题
    lazy var titleLabel: UILabel = {
        let label = UILabel.default()
            .pd_adjustsFontSizeToFitWidth(true)
            .pd_textAlignment(.center)
            .pd_font(.pingFang(.regular, size: 13))
            .pd_textColor(.gray)
            .pd_highlightedTextColor(.black)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.imageView.add2(self)
        self.titleLabel.add2(self)
    }
}

extension PDTabBarButton {
    func select() {
        self.imageView.isHighlighted = true
        self.titleLabel.isHighlighted = true
    }

    func deSelect() {
        self.imageView.isHighlighted = false
        self.titleLabel.isHighlighted = false
    }
}

extension PDTabBarButton {
    @discardableResult
    func pd_image(_ image: UIImage?) -> Self {
        self.imageView.image = image
        self.relayout()
        return self
    }

    @discardableResult
    func pd_selectedImage(_ image: UIImage?) -> Self {
        self.imageView.highlightedImage = image
        self.relayout()
        return self
    }

    @discardableResult
    func pd_title(_ title: String?) -> Self {
        self.titleLabel.text = title
        self.relayout()
        return self
    }

    @discardableResult
    func pd_titleColor(_ color: UIColor?) -> Self {
        self.titleLabel.textColor = color
        self.relayout()
        return self
    }

    @discardableResult
    func pd_highlightedTextColor(_ color: UIColor?) -> Self {
        self.titleLabel.highlightedTextColor = color
        self.relayout()
        return self
    }

    @discardableResult
    func pd_font(_ font: UIFont) -> Self {
        self.titleLabel.pd_font(font)
        self.relayout()
        return self
    }
}

extension PDTabBarButton {
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let normalImage = self.imageView.image else { return }
        guard let _ = self.titleLabel.text else { return }

        let imageSize = normalImage.size
        let titleSize = self.titleLabel.strSize()

        if EnvUtils.isLandscape { // 横屏
            // 图片与标题之间的间距
            let middleMargin: CGFloat = 4

            // 图片
            let imageX = (self.pd_width - imageSize.width - titleSize.width - middleMargin) / 2
            let imageY = (self.pd_height - imageSize.height) / 2
            self.imageView.pd_frame(CGRect(origin: CGPoint(x: imageX, y: imageY), size: imageSize))

            // 标题
            let titleX = imageX + imageSize.width + middleMargin
            let titleY = (self.pd_height - titleSize.height) / 2
            self.titleLabel.frame = CGRect(origin: CGPoint(x: titleX, y: titleY), size: titleSize)
        } else { // 竖屏
            // 图片与标题之间的间距
            let middleMargin: CGFloat = 2.5

            // 图片
            let imageX = (self.pd_width - imageSize.width) / 2
            let imageY = (self.pd_height - imageSize.height - titleSize.height - middleMargin) * 0.6
            self.imageView.frame = CGRect(origin: CGPoint(x: imageX, y: imageY), size: imageSize)

            // 标题
            let titleX = (self.pd_width - titleSize.width) / 2
            let titleY = (imageY + imageSize.height + middleMargin)
            self.titleLabel.frame = CGRect(origin: CGPoint(x: titleX, y: titleY), size: titleSize)
        }
    }
}
