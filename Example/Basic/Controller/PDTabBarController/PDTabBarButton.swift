//
//  PDTabBarButton.swift
//  Example
//
//  Created by 奥尔良小短腿 on 2024/4/4.
//

import Panda
import UIKit

class PDTabBarButton: PDControl {

//    lazy var imageView: UIImageView = {
//        let imageView = UIImageView.default()
//        return imageView
//    }()
//    
//    lazy var titleLabel: UILabel = {
//        let label = UILabel.default()
//        return label
//    }()
//    
//    init(title: String? = nil, image: UIImage, selectedImage: UIImage) {
//        super.init(frame: .zero)
//
//        // 设置资源
//        prepareUI()
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}

//extension PDTabBarButton {
//    /// 设置资源
//    private func prepareUI() {
//        // 默认图片
//        let image = data.image
//        setImage(image, for: .normal)
//
//        // 选中图片
//        let selectImage = data.selectedImage
//        setImage(selectImage, for: .selected)
//
//        // 标题
//        let title = data.title ?? ""
//        let appearance = WBTabBar.standardAppearance
//
//        // 默认状态
//        let normalAttributes = appearance.stackedLayoutAppearance.normal.titleTextAttributes
//        let titleAttributedString = title.toMutableAttributedString()
//            .pd_addAttributes(normalAttributes, for: title)
//            .pd_addAttributes([
//                .foregroundColor: data.forgroundColor as Any,
//                .font: data.font as Any,
//            ], for: title.fullNSRange())
//        setAttributedTitle(titleAttributedString, for: .normal)
//
//        // 选中状态
//        let selectedAttributes = appearance.stackedLayoutAppearance.selected.titleTextAttributes
//        let selectedTitleAttributedString = title.toMutableAttributedString()
//            .pd_addAttributes(selectedAttributes, for: title)
//            .pd_addAttributes([
//                .foregroundColor: data.selectedForgroundColor as Any,
//                .font: data.font as Any,
//            ], for: title.fullNSRange())
//        setAttributedTitle(selectedTitleAttributedString, for: .selected)
//    }
//}

//extension PDTabBarButton {
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // 图片大小
//        let imageSize = imageView?.image?.size ?? .zero
//        // 标题大小
//        let titleSize = titleLabel?.textSize() ?? .zero
//
//        if EnvUtils.isLandscape { // 横屏
//            // 图片与标题之间的间距
//            let middleMargin: CGFloat = 4
//
//            // 图片
//            let imageX = (pd_frame.width - imageSize.width - titleSize.width - middleMargin) / 2
//            let imageY = (pd_frame.height - imageSize.height) / 2
//            imageView?.frame = CGRect(origin: CGPoint(x: imageX, y: imageY), size: imageSize)
//
//            // 标题
//            let titleX = imageX + imageSize.width + middleMargin
//            let titleY = (pd_frame.height - titleSize.height) / 2
//            titleLabel?.frame = CGRect(origin: CGPoint(x: titleX, y: titleY), size: titleSize)
//        } else { // 竖屏
//            // 图片与标题之间的间距
//            let middleMargin: CGFloat = 2.5
//
//            // 图片
//            let imageX = (pd_frame.width - imageSize.width) / 2
//            let imageY = (pd_frame.height - imageSize.height - titleSize.height - middleMargin) * 0.6
//            imageView?.frame = CGRect(origin: CGPoint(x: imageX, y: imageY), size: imageSize)
//
//            // 标题
//            let titleX = (pd_frame.width - titleSize.width) / 2
//            let titleY = (imageY + imageSize.height + middleMargin)
//            titleLabel?.frame = CGRect(origin: CGPoint(x: titleX, y: titleY), size: titleSize)
//        }
//    }
//}
