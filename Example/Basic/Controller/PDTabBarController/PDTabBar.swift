//
//  PDTabBar.swift
//  Example
//
//  Created by 奥尔良小短腿 on 2024/4/4.
//

import Panda
import UIKit

protocol PDTabBarDelegate: NSObjectProtocol {
    func tabBarButtonClick(_ tabBar: PDTabBar, clicked index: Int)
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

        let buttonWidth = SizeUtils.screenWidth / (viewModel.titles.count + 1).toCGFloat()
        button.expandSize(size: (buttonWidth - btnSize.width) / 2)

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
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PDTabBar {
    override func layoutSubviews() {
        super.layoutSubviews()

        // 多一个中间按钮
        let buttonCount = self.viewModel.titles.count + 1
        let buttonWidth = self.pd_width / buttonCount.toCGFloat()
        let buttonHeight = SizeUtils.tabBarHeight

        let titleButtons = self.titleButtons()
        for (i, button) in titleButtons.enumerated() {
            let buttonX = buttonWidth * i.toCGFloat() + (i >= 2 ? buttonWidth : 0)
            button.pd_frame(CGRect(x: buttonX, y: 0, width: buttonWidth, height: buttonHeight))
        }

        // 中间按钮
        let middleBtnSize = self.middleButton.pd_size
        self.middleButton.frame = CGRect(
            origin: CGPoint(
                x: (SizeUtils.screenWidth - middleBtnSize.width) / 2,
                y: -(middleBtnSize.height / 2)
            ),
            size: middleBtnSize
        )
    }
}

extension PDTabBar {
    func createButtons() {
        for i in 0 ..< self.viewModel.titles.count {
            let title = self.viewModel.titles[i]
            let imageName = self.viewModel.imageNames[i]
            let selectedImageName = "\(imageName)_selected"

            let image = imageName.toImage()
            let selectedImage = selectedImageName.toImage()

            let button = PDTabBarButton()
                .pd_tag(i)
                .pd_image(image!)
                .pd_selectedImage(selectedImage!)
                .pd_title(title)
                .pd_titleColor(viewModel.normalColor)
                .pd_highlightedTextColor(viewModel.selectedColor)
                .pd_font(viewModel.titleFont ?? .system(size: 12))
            button.addTarget(self, action: #selector(buttonClick(sender:)), for: .touchUpInside)

            viewModel.selectedIndex == i ? button.select() : button.deSelect()

            button.add2(self)
        }
    }

    @objc func buttonClick(sender: PDTabBarButton) {
        let titleButtons = self.titleButtons()
        // 取消之前选中按钮的状态
        let preSelectButton = titleButtons[viewModel.selectedIndex]
        preSelectButton.deSelect()

        // 选中点击的按钮
        sender.select()
        // 记录点击按钮的索引
        viewModel.selectedIndex = sender.tag

        // 回调点击索引到控制器
        self.customDelegate?.tabBarButtonClick(self, clicked: sender.tag)
    }

    // 获取所有标签按钮
    func titleButtons() -> [PDTabBarButton] {
        let titleButtons = self.subviews.filter { subview in
            return subview is PDTabBarButton
        }.map { subview in
            return subview as! PDTabBarButton
        }
        return titleButtons
    }
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
    override var items: [UITabBarItem]? {
        didSet {
            self.clearTabBarItems()
            self.createButtons()
        }
    }

    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        self.clearTabBarItems()
        self.createButtons()
    }

    /// 移除系统自带UITabBarButton
    private func clearTabBarItems() {
        self.subviews.filter {
            String(describing: type(of: $0)) == "UITabBarButton"
        }.forEach {
            $0.removeFromSuperview()
        }
    }
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
