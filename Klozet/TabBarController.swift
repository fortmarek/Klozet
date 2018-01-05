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
        let navigationViewController = createViewControllerTab(viewController, title: "Map", asset: Asset.mapIconUnselected, selectedAsset: Asset.mapIconSelected)
        let listViewController = ListViewController()
        let listNavigationController = createViewControllerTab(listViewController, title: "List", asset: Asset.listIcon, selectedAsset: Asset.listIconSelected)
        let addProxyViewController = UIViewController()
        let addProxyViewControllerTabBarItem = TabBarItem(image: UIImage(asset: Asset.addIcon), selectedImage: UIImage(asset: Asset.addIconSelected), title: "Add", selectedTintColor: .mainOrange)
        addProxyViewController.tabBarItem = addProxyViewControllerTabBarItem
        
        listViewController.toiletsViewModel = viewController.toiletsViewModel
        listViewController.locationDelegate = viewController
        
        viewControllers = [navigationViewController, addProxyViewController, listNavigationController]
                
        tabBar.barTintColor = .white 
    }
    
    private func createViewControllerTab<T: UIViewController>(_ viewController: T, title: String, asset: ImageAsset, selectedAsset: ImageAsset) -> UIViewController {
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


