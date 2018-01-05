//
//  AddToiletViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 1/5/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit

class AddToiletViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Toilet"
        
        view.backgroundColor = .white

        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonTapped))
        let cancelAttributes: [NSAttributedStringKey : Any] = [.font : UIFont.systemFont(ofSize: 17, weight: .medium), .foregroundColor : UIColor.mainOrange]
        cancelBarButtonItem.setTitleTextAttributes(cancelAttributes, for: .normal)
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    @objc private func cancelBarButtonTapped() {
        
        //TODO: Alert when some info filled in?
        dismiss(animated: true, completion: nil)
    }
}
