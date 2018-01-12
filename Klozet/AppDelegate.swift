//
//  AppDelegate.swift
//  Klozet
//
//  Created by Marek Fořt on 13/08/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = TabBarController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let attributes: [NSAttributedStringKey : Any] = [.font: UIFont.systemFont(ofSize: 19, weight: .semibold), .foregroundColor : UIColor.mainOrange]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        return true
    }

}


//https://stackoverflow.com/questions/35644128/how-do-i-make-text-labels-scale-the-font-size-with-different-apple-product-scree?noredirect=1&lq=1
extension AppDelegate {
    static var isScreenSmall: Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 568.0
    }
    static var isScreenMedium: Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 667.0
    }
    static var isScreenBig: Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 736.0
    }
    
    static var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

