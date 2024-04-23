//
//  PDNavigationBar.swift
//  Panda
//
//  Created by 奥尔良小短腿 on 2024/4/3.
//

import Panda
import UIKit

class PDNavigationBar: UIImageView {
    // MARK: - 分割线
    private var separatorHeight: CGFloat = 0.5
    private var separatorColor = UIColor.black.pd_alpha(0.05)

    // MARK: - 导航栏阴影
    private var navigationShadowColor = UIColor.black.pd_alpha(0.2)
    private var navigationShadowRadius: CGFloat = 5
    private var navigationShadowOffset = CGSize(width: 0, height: 5)
    private var navigationShadowOpacity: Float = 0.25

    /// 状态栏
    lazy var statusBar: PDStatusBar = {
        let statusBar = PDStatusBar()
        return statusBar
    }()

    /// 标题栏
    lazy var titleBar: PDTitleBar = {
        let titleBar = PDTitleBar()
        return titleBar
    }()

    /// 分隔线
    lazy var separatorView: UIView = {
        let view = UIView.default()
            .pd_backgroundColor(self.separatorColor)
        return view
    }()

    override init(frame: CGRect = .zero) {
        let size = CGSize(width: sizer.screen.width, height: sizer.nav.fullHeight)
        let rect = CGRect(origin: .zero, size: size)
        super.init(frame: rect)

        self.pd_isUserInteractionEnabled(true)
            .pd_clipsToBounds(false)
            .pd_masksToBounds(false)
            .pd_backgroundColor(.white)
            .pd_shadowColor(navigationShadowColor)
            .pd_shadowRadius(navigationShadowRadius)
            .pd_shadowOffset(navigationShadowOffset)
            .pd_shadowOpacity(navigationShadowOpacity)

        self.statusBar.add2(self)
        self.titleBar.add2(self)
        self.separatorView.add2(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PDNavigationBar {
    override func layoutSubviews() {
        super.layoutSubviews()

        var navigationFullHeight: CGFloat = 0

        if !statusBar.isHidden {
            let size = CGSize(width: sizer.screen.width, height: sizer.nav.statusHeight)
            self.statusBar.pd_frame(CGRect(origin: .zero, size: size))
            navigationFullHeight += sizer.nav.statusHeight
        }

        if !titleBar.isHidden {
            let top: CGFloat = !statusBar.isHidden ? sizer.nav.statusHeight : 0
            let size = CGSize(width: sizer.screen.width, height: sizer.nav.titleHeight)
            self.titleBar.pd_frame(CGRect(origin: CGPoint(x: 0, y: top), size: size))
            navigationFullHeight += sizer.nav.titleHeight
        }

        if !separatorView.isHidden {
            let top = navigationFullHeight - separatorHeight
            let size = CGSize(width: sizer.screen.width, height: separatorHeight)
            self.separatorView.pd_frame(CGRect(origin: CGPoint(x: 0, y: top), size: size))
        }

        let size = CGSize(width: sizer.screen.width, height: navigationFullHeight)
        self.pd_frame(CGRect(origin: .zero, size: size))
    }
}

// MARK: - 状态栏
extension PDNavigationBar {
    /// 隐藏状态栏
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func hiddenStatusBar(_ isHidden: Bool) -> Self {
        self.statusBar.pd_isHidden(isHidden)
        self.relayout()
        return self
    }

    /// 设置状态栏背景颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func statusBarBackgroundColor(_ color: UIColor?) -> Self {
        self.statusBar.pd_backgroundColor(color ?? .clear)
        return self
    }

    /// 设置状态栏背景图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func statusBarBackgroundImage(_ image: UIImage?) -> Self {
        self.statusBar.pd_image(image)
        return self
    }

    /// 设置状态栏内容模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    @discardableResult
    func statusBarContentMode(_ mode: UIView.ContentMode) -> Self {
        self.statusBar.pd_contentMode(mode)
        return self
    }
}

// MARK: - 标题栏
extension PDNavigationBar {
    /// 隐藏标题栏
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func hiddenTitleBar(_ isHidden: Bool) -> Self {
        self.titleBar.pd_isHidden(isHidden)
        self.relayout()
        return self
    }

    /// 设置标题栏背景颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func titleBarBackgroundColor(_ color: UIColor?) -> Self {
        self.titleBar.pd_backgroundColor(color ?? .clear)
        return self
    }

    /// 设置标题栏背景图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func titleBarBackgroundImage(_ image: UIImage?) -> Self {
        self.titleBar.pd_image(image)
        return self
    }

    /// 设置状态栏内容模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    @discardableResult
    func titleBarContentMode(_ mode: UIView.ContentMode) -> Self {
        self.titleBar.pd_contentMode(mode)
        return self
    }

    /// 设置标题栏属性标题
    /// - Parameter attributeTitle: 属性字符串标题
    /// - Returns: `Self`
    @discardableResult
    func attributeTitle(_ attributeTitle: NSAttributedString?) -> Self {
        self.titleBar.attributeTitle(attributeTitle)
        return self
    }

    /// 设置标题栏标题
    /// - Parameter title: 标题
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        self.titleBar.title(title)
        return self
    }

    /// 设置标题栏标题字体
    /// - Parameter font: 标题字体
    /// - Returns: `Self`
    @discardableResult
    func titleFont(_ font: UIFont) -> Self {
        self.titleBar.titleFont(font)
        return self
    }

    /// 设置标题栏标题颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func titleColor(_ color: UIColor?) -> Self {
        self.titleBar.titleColor(color)
        return self
    }

    /// 隐藏返回按钮
    /// - Parameter hidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func hiddenBackButton(_ hidden: Bool) -> Self {
        self.titleBar.hiddenBackButton(hidden)
        return self
    }

    /// 设置返回按钮图标
    /// - Parameters:
    ///   - image: 图片
    ///   - state: 状态
    /// - Returns: `Self`
    @discardableResult
    func backButtonImage(_ image: UIImage?, for state: UIButton.State) -> Self {
        self.titleBar.backButtonImage(image, for: state)
        return self
    }

    /// 设置返回按钮点击回调
    /// - Parameters:
    ///   - backCallback: 返回按钮点击回调
    /// - Returns: `Self`
    @discardableResult
    func backButtonCallback(_ backCallback: (() -> Void)?) -> Self {
        self.titleBar.backButtonCallback(backCallback)
        return self
    }
}

// MARK: - 分隔线
extension PDNavigationBar {
    /// 隐藏分隔线
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func hiddenSeparator(_ isHidden: Bool) -> Self {
        self.separatorView.pd_isHidden(isHidden)
        self.relayout()
        return self
    }

    /// 分隔线颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func separatorColor(_ color: UIColor?) -> Self {
        self.separatorView.pd_backgroundColor(color ?? .clear)
        return self
    }

    /// 分隔线高度
    /// - Parameter height: 调度
    /// - Returns: `Self`
    @discardableResult
    func separatorHeight(_ height: CGFloat) -> Self {
        self.separatorHeight = height
        self.relayout()
        return self
    }
}

// MARK: - 导航栏
extension PDNavigationBar {
    /// 隐藏导航栏
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func hiddenNavigationBar(_ isHidden: Bool) -> Self {
        self.pd_isHidden(isHidden)
    }

    /// 设置导航栏背景颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func navigationBarBackgroundColor(_ color: UIColor?) -> Self {
        self.pd_backgroundColor(color ?? .clear)
    }

    /// 设置导航栏背景图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func navigationBarBackgroundImage(_ image: UIImage?) -> Self {
        self.pd_image(image)
    }

    /// 设置状态栏内容模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    @discardableResult
    func navigationBarContentMode(_ mode: UIView.ContentMode) -> Self {
        self.pd_contentMode(mode)
    }
}

// MARK: - 阴影
extension PDNavigationBar {
    /// 阴影的显示及隐藏
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: `Self`
    @discardableResult
    func hiddenShadow(_ isHidden: Bool) -> Self {
        self.pd_shadowOpacity(isHidden ? 0 : navigationShadowOpacity)
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color: 阴影颜色
    /// - Returns: `Self`
    @discardableResult
    func shadowColor(_ color: UIColor) -> Self {
        self.navigationShadowColor = color
        self.updateShadow()
        return self
    }

    /// 设置阴影半径
    /// - Parameter radius: 半径
    /// - Returns: `Self`
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        self.navigationShadowRadius = radius
        self.updateShadow()
        return self
    }

    /// 设置阴影不透明度
    /// - Parameter color: 不透明度
    /// - Returns: `Self`
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        self.navigationShadowOpacity = opacity
        self.updateShadow()
        return self
    }

    /// 设置阴影偏移
    /// - Parameter color: 不透明度
    /// - Returns: `Self`
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        self.navigationShadowOffset = offset
        self.updateShadow()
        return self
    }

    /// 更新阴影
    private func updateShadow() {
        self.pd_shadowColor(navigationShadowColor)
            .pd_shadowRadius(navigationShadowRadius)
            .pd_shadowOffset(navigationShadowOffset)
            .pd_shadowOpacity(navigationShadowOpacity)
    }
}
