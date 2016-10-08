//
//  SettingsViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 06/10/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var supportCellDelegate: SupportCellDelegate?
    var shareCellDelegate: ShareCellDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        
        let settingsStack = setSettingsStack()
        
        let iconView = UIImageView(image: UIImage(named: "icon"))
        settingsStack.addArrangedSubview(iconView)
        iconView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        iconView.backgroundColor = UIColor.black
        
        let settingsTableView = SettingsTableView()
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsStack.addArrangedSubview(settingsTableView)
        settingsTableView.leftAnchor.constraint(equalTo: settingsStack.leftAnchor).isActive = true
        settingsTableView.rightAnchor.constraint(equalTo: settingsStack.rightAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    private func setSettingsStack() -> UIStackView {
        let settingsStack = UIStackView()
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsStack)
        
        guard let navigationHeight = navigationController?.navigationBar.frame.size.height else {return UIStackView()}
        settingsStack.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationHeight).isActive = true
        settingsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        settingsStack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        settingsStack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        settingsStack.axis = .vertical
        settingsStack.alignment = .center
        
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


extension SettingsViewController: PresentDelegate {
    func showViewController(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}


