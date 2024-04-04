//
//  PDTabBar.swift
//  Example
//
//  Created by 奥尔良小短腿 on 2024/4/4.
//

import Panda
import UIKit

protocol PDTabBarDelegate: NSObjectProtocol {
    func middleButtonClick(tabBar: PDTabBar, button: UIButton, rect: CGRect)
}

class PDTabBar: UITabBar {
    weak var customDelegate: (any PDTabBarDelegate)?
    weak var viewModel: PDTabBarViewModel!

    var maskLayer: CAShapeLayer?

    /// 中间按钮
    private lazy var middleButton: UIButton = {
        // 加号图标
        let image = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        // 按钮大小
        let btnSize = 56.toCGSize()

        // 创建中间按钮
        let button = UIButton.default()
            .pd_frame(CGRect(origin: .zero, size: btnSize))
            .pd_image(image)
            .pd_backgroundColor("#5DC77D".toHexColor())
            .pd_cornerRadius(btnSize.width * 0.5)
            .pd_masksToBounds(true)
            .pd_action(self, action: #selector(middleButtonClick(_:)))

        return button
    }()

    init(vm: PDTabBarViewModel, frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = vm

        self.pd_isTranslucent(true) // 设置背景不半透明
            .pd_backgroundColor(with: .clear) // 背景颜色
            .pd_shadowImage(UIImage(with: .clear)) // 隐藏阴影线

        // 中间按钮
        middleButton.add2(self)

//        // 设置自定义按钮
//        for data in viewModel {
//            let button = createWBTabBarButton(with: data)
//            // 添加到数组
//            viewModel.buttons.append(button)
//
//            if viewModel.selectedIndex == button.data.index {
//                button.isSelected = true
//            }
//        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PDTabBar {
    override func layoutSubviews() {
        super.layoutSubviews()

//        // 按钮宽度
//        let btnWidth = bounds.width / (viewModel.datas.count + 1).toCGFloat()
//        // 按钮高度
//        let btnHeight = SizeUtils.tabBarHeight
//
//        // 选项按钮
//        for (index, button) in viewModel.buttons.enumerated() {
//            // 按钮X坐标
//            let btnX = btnWidth * index.toCGFloat() + (index >= 2 ? btnWidth : 0)
//            // 更新frame
//            button.frame = CGRect(x: btnX, y: 0, width: btnWidth, height: btnHeight)
//            // 更新按钮的布局
//            button.relayout()
//        }
//
//        // 中间按钮
//        let middleBtnSize = middleButton.pd_size
//        middleButton.frame = CGRect(
//            origin: CGPoint(
//                x: (SizeUtils.screenWidth - middleBtnSize.width) / 2,
//                y: -(middleBtnSize.height / 2)
//            ),
//            size: middleBtnSize
//        )
//        // 调整中间按钮响应范围
//        middleButton.expandSize(size: (btnWidth - middleBtnSize.width) / 2)
    }
}

extension PDTabBar {
//    /// 根据模型创建按钮
//    func createWBTabBarButton(with data: WBTabBarData) -> PDTabBarButton {
//        // 按钮宽度
//        let btnWidth = pd_width / (viewModel.datas.count + 1).toCGFloat()
//        // 按钮高度
//        let btnHeight = SizeUtils.tabBarHeight
//        // 按钮X坐标
//        let btnX = btnWidth * data.index.toCGFloat() + (data.index >= 2 ? btnWidth : 0)
//
//        // 创建按钮
//        let button = PDTabBarButton(with: data, WBTabBar: self)
//        button.frame = CGRect(x: btnX, y: 0, width: btnWidth, height: btnHeight)
//        button.addTarget(self, action: #selector(WBTabBarButtonClick(sender:)), for: .touchUpInside)
//
//        // 添加到TabBar
//        button.add2(self)
//
//        return button
//    }
//
//    /// 按钮点击
//    @objc func WBTabBarButtonClick(sender: PDTabBarButton) {
//        if sender.isSelected {
//            return
//        }
//        // 震动
//        AudioUtils.shared.shake(.middle)
//
//        // 取消之前选中按钮的选中状态
//        let previousButton = viewModel.buttons[viewModel.selectedIndex]
//        previousButton.isSelected = false
//
//        // 为被点击的按钮添加状态
//        viewModel.selectedIndex = sender.data.index
//        sender.isSelected = true
//
//        // 回调点击
//        viewModel.tabBarDelegate?.tabBarButtonClick(tabBar: self, unselectedButton: previousButton, selectedButton: sender)
//    }
}

// MARK: - 中心按钮
extension PDTabBar {
    /// 中心按钮点击
    /// - Parameter sender: 被点击的按钮
    @objc private func middleButtonClick(_ sender: UIButton) {
        self.customDelegate?.middleButtonClick(tabBar: self, button: sender, rect: middleButton.frame)
    }
}

// MARK: - 移除系统自带UITabBarButton
extension PDTabBar {
//    override var items: [UITabBarItem]? {
//        didSet {
//            clearTabBarItems()
//        }
//    }
//
//    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
//        clearTabBarItems()
//    }
//
//    /// 移除系统自带UITabBarButton
//    private func clearTabBarItems() {
//        subviews.filter {
//            String(describing: type(of: $0)) == "UITabBarButton"
//        }.forEach {
//            $0.removeFromSuperview()
//        }
//    }
}

// MARK: - 重写系统方法
extension PDTabBar {
    /// 尺寸计算
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = SizeUtils.tabBarFullHeight
        return sizeThatFits
    }

    /// 处理中心按钮点击响应范围
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if middleButton.frame.contains(point) {
            return middleButton
        }
        return super.hitTest(point, with: event)
    }
}

// MARK: - 绘制背景图层
extension PDTabBar {
    /// 绘制背景图层
    func drawMask() {
        // 防止重复添加
        if self.maskLayer?.superlayer != nil {
            self.maskLayer?.removeFromSuperlayer()
            self.maskLayer = nil
            self.layer.mask = nil
        }

        // 背景图层绘制路径
        let shapePath = self.drawMaskPath().cgPath

        // 形状图层
        self.maskLayer = CAShapeLayer.default()
            .pd_path(shapePath)
            .pd_fillColor(viewModel.maskFillColor)
            .pd_shadowColor(viewModel.maskShadowColor)
            .pd_shadowRadius(viewModel.maskShadowRadius)
            .pd_shadowOpacity(viewModel.maskShadowOpacity)
            .pd_shadowOffset(viewModel.maskShadowOffset)
            .pd_shouldRasterize(true)
            .pd_rasterizationScale(UIScreen.main.scale)

        self.layer.mask = maskLayer
        self.layer.insertSublayer(maskLayer!, at: 0)
    }

    /// 背景图层路径
    func drawMaskPath() -> UIBezierPath {
        // 最大绘制区域
        let drawRect = CGRect(x: 0, y: 0, width: SizeUtils.screenWidth, height: SizeUtils.tabBarFullHeight)

        let path = UIBezierPath()
        // 画笔移动到CGPoint(0, 0)
        path.move(to: .zero)

        // 绘制左上圆角
        var radius: CGFloat = 19
        var center = CGPoint(x: radius, y: radius)
        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: 180.toRadians(),
            endAngle: (180 + 90).toRadians(),
            clockwise: true
        )

        // 绘制中间左边圆角
        let middleDiameter: CGFloat = 76
        center.x = (drawRect.width - middleDiameter) / 2 - radius + middleDiameter * 0.04
        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: 270.toRadians(),
            endAngle: (270 + 70).toRadians(),
            clockwise: true
        )

        // 绘制中间凹陷的弧形
        radius = 38
        center = CGPoint(x: drawRect.width / 2, y: 0)
        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: 160.toRadians(),
            endAngle: 20.toRadians(),
            clockwise: false
        )

        // 绘制中间右边圆角
        radius = 19
        center = CGPoint(x: (drawRect.width + middleDiameter) / 2 + radius - middleDiameter * 0.04, y: radius)
        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: 200.toRadians(),
            endAngle: (200 + 70).toRadians(),
            clockwise: true
        )

        // 绘制右上圆角
        center = CGPoint(x: drawRect.width - radius, y: radius)
        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: 270.toRadians(),
            endAngle: (270 + 90).toRadians(),
            clockwise: true
        )

        // 绘制右侧竖线
        path.addLine(to: CGPoint(x: drawRect.size.width, y: drawRect.size.height))
        // 绘制底部横线
        path.addLine(to: CGPoint(x: 0, y: drawRect.size.height))
        // 关闭路径(绘制左侧竖线)
        path.close()

        return path
    }
}
