//
//  SettingsViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 06/10/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        
        let settingsStack = setSettingsStack()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setSettingsStack() -> UIStackView {
        let settingsStack = UIStackView()
        view.addSubview(settingsStack)
        settingsStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        settingsStack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        return settingsStack
    }
    
    private func setNavigation() {
        //Navigation title
        navigationItem.title = "Nastavení".localized
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Colors.pumpkinColor]
        
        //Left navigation item (action to return to MainViewController)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Zavřít".localized, style: .plain, target: self, action: #selector(dismissToMap))
        
        navigationController?.navigationBar.tintColor = Colors.pumpkinColor
    }
    
    func dismissToMap() {
        self.dismiss(animated: true, completion: nil)
    }

}
