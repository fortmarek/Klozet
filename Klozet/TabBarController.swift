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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        let viewControllTabBarItem = TabBarItem(image: UIImage(asset: .mapIconUnselected), selectedImage: UIImage(asset: .mapIconSelected), title: title, selectedTintColor: .mainBlue)
        viewController.tabBarItem = viewControllTabBarItem
        
        viewControllers = [viewController]
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightSemibold)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
        tabBar.barTintColor = .white 
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
//    
//
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class TabBarItem: UITabBarItem {
    init(image: UIImage, selectedImage: UIImage, title: String?, selectedTintColor: UIColor?) {
        super.init()
        self.image = image.withRenderingMode(.alwaysOriginal)
        self.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        self.title = title


        if let tintColor = selectedTintColor {
            setTitleTextAttributes([NSForegroundColorAttributeName: tintColor], for: .selected)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


