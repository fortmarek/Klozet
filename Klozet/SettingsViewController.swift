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
    
    var settingsTableView = SettingsTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.95, alpha: 1.0)
        
        setNavigation()
        
        let settingsStack = setSettingsStack()
        
        setIconView(settingsStack: settingsStack)
        
        let settingsTableStack = UIStackView()
        settingsStack.addArrangedSubview(settingsTableStack)
        settingsTableStack.axis = .vertical
        settingsTableStack.alignment = .center
        settingsTableStack.spacing = 15
        
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableStack.addArrangedSubview(settingsTableView)
        settingsTableView.leftAnchor.constraint(equalTo: settingsStack.leftAnchor).isActive = true
        settingsTableView.rightAnchor.constraint(equalTo: settingsStack.rightAnchor).isActive = true
        
        
        let creditsLabel = UILabel()
        creditsLabel.text = "Version 1.0.1\nCreated by Marek Fořt".localized
        creditsLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        creditsLabel.textAlignment = .center
        creditsLabel.numberOfLines = 2
        settingsTableStack.addArrangedSubview(creditsLabel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setIconView(settingsStack: UIStackView) {
        
        let iconStackView = UIStackView()
        settingsStack.addArrangedSubview(iconStackView)
        iconStackView.distribution = .equalSpacing
        iconStackView.axis = .vertical
        iconStackView.alignment = .center
        iconStackView.spacing = 20
        
        let iconView = UIImageView(image: UIImage(named: "icon"))
        iconStackView.addArrangedSubview(iconView)
        iconView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = "Klozet"
        nameLabel.font = UIFont.systemFont(ofSize: 19)
        iconStackView.addArrangedSubview(nameLabel)
        
    }
    
    private func setSettingsStack() -> UIStackView {
        let settingsStack = UIStackView()
        settingsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsStack)
        
        
        settingsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        settingsStack.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        settingsStack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        settingsStack.axis = .vertical
        settingsStack.alignment = .center
        settingsStack.distribution = .equalCentering
        settingsStack.spacing = 50
        
        return settingsStack
    }
    
    private func setNavigation() {
        //Navigation title
        navigationItem.title = "Settings".localized
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.mainOrange]
        
        //Left navigation item (action to return to MainViewController)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close".localized, style: .plain, target: self, action: #selector(dismissToMap))
        
        navigationController?.navigationBar.tintColor = .mainOrange
    }
    
    @objc func dismissToMap() {
        self.dismiss(animated: true, completion: nil)
    }

}


extension SettingsViewController: ShowDelegate {
    func showViewController(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}


