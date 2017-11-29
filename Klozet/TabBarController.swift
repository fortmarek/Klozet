//
//  TabBarController.swift
//  Klozet
//
//  Created by Marek Fořt on 10/24/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//

import UIKit



import UIKit

class TabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
       let viewController = createViewController(viewControllerIdentifier: "HomeNavigationController", asset: .mapIconUnselected, selectedAsset: .mapIconSelected)
        let listNavigationController = createViewController(viewControllerIdentifier: "ListNavigationController", asset: .listIcon, selectedAsset: .listIconSelected)
        
        viewControllers = [viewController, listNavigationController]
                
        tabBar.barTintColor = .white 
    }
    
    private func createViewController(viewControllerIdentifier: String, asset: Asset, selectedAsset: Asset) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        let viewControllTabBarItem = TabBarItem(image: UIImage(asset: asset), selectedImage: UIImage(asset: selectedAsset), selectedTintColor: .mainBlue)
        viewController.tabBarItem = viewControllTabBarItem
        return viewController
    }
    
//    private func createViewControllerTab<T: UIViewController>(_ viewController: T, title: String, asset: Asset, selectedAsset: Asset) -> UIViewController {
//        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.setDefaultBackButtonWithTitle(title)
//        navigationController.setDefaultNavigationBar()
//
//        let viewControllTabBarItem = TabBarItem(image: UIImage(asset: asset), selectedImage: UIImage(asset: selectedAsset), title: title, selectedTintColor: .cornflower)
//        navigationController.tabBarItem = viewControllTabBarItem
//        return navigationController
//    }
    

    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class TabBarItem: UITabBarItem {
    init(image: UIImage, selectedImage: UIImage, selectedTintColor: UIColor?) {
        super.init()
        self.image = image.withRenderingMode(.alwaysOriginal)
        self.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        self.title = ""
        imageInsets.top = 7
        imageInsets.bottom = -7

        if let tintColor = selectedTintColor {
            setTitleTextAttributes([NSAttributedStringKey.foregroundColor: tintColor], for: .selected)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


