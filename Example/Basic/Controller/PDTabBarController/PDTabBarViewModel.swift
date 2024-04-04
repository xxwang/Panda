//
//  PDTabBarViewModel.swift
//  Example
//
//  Created by 奥尔良小短腿 on 2024/4/4.
//

import UIKit

class PDTabBarViewModel: PDViewModel {
    // 默认选中标签索引
    var selectedIndex: Int = 0

    // 标题颜色
    var normalColor: UIColor?
    var selectedColor: UIColor?

    // 标题字体
    var titleFont: UIFont?

    // 标题数组
    var titles: [String] = []
    // 图片名称数组
    var imageNames: [String] = []
    // 控制器数组
    var controllers: [PDViewController] = []

    var maskFillColor: UIColor = .white
    var maskShadowColor: UIColor = .black.alpha(0.5)
    var maskShadowRadius: CGFloat = 4
    var maskShadowOffset: CGSize = .init(width: 0, height: -2)
    var maskShadowOpacity: Float = 0.25
}

extension PDTabBarViewModel {
    func viewControllers() -> [PDNavigationController] {
        var navigationControllers: [PDNavigationController] = []

        for i in 0 ..< self.controllers.count {
            // 标题
            let title = self.titles[i]

            // 图标名称
            let imageName = self.imageNames[i]
            let selectedImageName = "\(imageName)_selected"

            // 图标图片
            let image = imageName.toImage()!.withRenderingMode(.alwaysOriginal)
            let selectedImage = selectedImageName.toImage()!.withRenderingMode(.alwaysOriginal)

            // 对应控制器
            let controller = self.controllers[i]

            // 导航控制器
            let navigationController = PDNavigationController(rootViewController: controller)

            // 设置tabBarItem
            if let tabBarItem = navigationController.tabBarItem {
                tabBarItem
                    .pd_title(title)
                    .pd_image(image)
                    .pd_selectedImage(selectedImage)

                tabBarItem.setTitleTextAttributes([
                    .foregroundColor: self.normalColor!,
                    .font: self.titleFont!,
                ], for: .normal)
                
                tabBarItem.setTitleTextAttributes([
                    .foregroundColor: self.selectedColor!,
                    .font: self.titleFont!,
                ], for: .selected)

                navigationController.tabBarItem = tabBarItem
            }
            navigationControllers.append(navigationController)
        }
        return navigationControllers
    }
}
