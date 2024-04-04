//
//  PDTabBarViewModel.swift
//  Example
//
//  Created by 奥尔良小短腿 on 2024/4/4.
//

import Foundation

class PDTabBarViewModel: PDViewModel {
    
    var selectedIndex: Int = 0
    
    var normalColor: UIColor?
    var selectedColor: UIColor?
    var titleFont: UIFont?
    
    var controllers: [PDViewController.Type] = []
    var titles: [String] = []
    var imageNames: [String] = []
    
    var tabBarFillColor: UIColor = .white
    var tabBarShadowColor: UIColor = .black.alpha(0.5)
    var tabBarShadowRadius: CGFloat = 4
    var tabBarShadowOpacity: Float = 0.25
    
}

extension PDTabBarViewModel {
    
    func viewControllers() -> [PDViewController] {
        
        var navigationControllers: [PDNavigationController] = []
        for i in 0..<self.controllers.count {
            let title = self.titles[i]
            let imageName = self.imageNames[i]
            let selectedImageName = "\(imageName)_selected"
            let image = imageName.toImage()?.withRenderingMode(.alwaysOriginal)
            let selectedImage = selectedImageName.toImage().withRenderingMode(.alwaysOriginal)
            
            let controllerType = self.controllers[i]
            let controller = controllerType.init()
            let navigationVC = PDNavigationController(rootViewController: controller)
            let tabBarItem = navController.tabBarItem
            tabBarItem?
                .pd_title(title)
                .pd_image(image!)
                .pd_selectedImage(selectedImage!)
            navigationVC.tabBarItem = tabBarItem
            navigationControllers.append(navigationVC)
        }
    }
}
