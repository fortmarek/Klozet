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
        let viewController = ViewController()
        let navigationViewController = createViewControllerTab(viewController, title: "Map", asset: .mapIconUnselected, selectedAsset: .mapIconSelected)
        let listViewController = ListViewController()
        let listNavigationController = createViewControllerTab(listViewController, title: "List", asset: .listIcon, selectedAsset: .listIconSelected)
        let viewControllerr = createViewControllerTab(ViewController(), title: "Map", asset: .mapIconUnselected, selectedAsset: .mapIconSelected)
        
        listViewController.toiletsViewModel = viewController.toiletsViewModel
        
        viewControllers = [navigationViewController, viewControllerr, listNavigationController]
                
        tabBar.barTintColor = .white 
    }
    
    private func createViewControllerTab<T: UIViewController>(_ viewController: T, title: String, asset: Asset, selectedAsset: Asset) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewController)
        //navigationController.setDefaultBackButtonWithTitle(title)
        navigationController.setDefaultNavigationBar()

        let viewControllTabBarItem = TabBarItem(image: UIImage(asset: asset), selectedImage: UIImage(asset: selectedAsset), title: title, selectedTintColor: .mainOrange)
        navigationController.tabBarItem = viewControllTabBarItem
        viewController.tabBarItem = viewControllTabBarItem
        return navigationController
    }

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
            setTitleTextAttributes([.foregroundColor: tintColor], for: .selected)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//class TabBarItem: UITabBarItem {
//    init(image: UIImage, selectedImage: UIImage, selectedTintColor: UIColor?) {
//        super.init()
//        self.image = image.withRenderingMode(.alwaysOriginal)
//        self.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
//        self.title = ""
//        imageInsets.top = 7
//        imageInsets.bottom = -7
//
//        if let tintColor = selectedTintColor {
//            setTitleTextAttributes([NSAttributedStringKey.foregroundColor: tintColor], for: .selected)
//        }
//    }
//
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


