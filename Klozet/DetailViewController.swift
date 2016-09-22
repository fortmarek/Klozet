//
//  DetailViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 20/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var mainStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStack.frame = view.frame
        
        view.addSubview(mainStack)
        
        guard let navigationController = self.navigationController else {return}
        
        let topMainAnchor = navigationController.navigationBar.frame.height + navigationController.navigationBar.frame.origin.x
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: topMainAnchor).isActive = true
        mainStack.widthAnchor.constraint(equalTo: view.widthAnchor)
        mainStack.axis = .vertical
        
        
        
        
        view.layoutIfNeeded()
        
        let imageStack = UIStackView()
        imageStack.topAnchor.constraint(equalTo: mainStack.topAnchor)
        imageStack.leftAnchor.constraint(equalTo: mainStack.leftAnchor)
        imageStack.rightAnchor.constraint(equalTo: mainStack.rightAnchor)
        imageStack.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.addArrangedSubview(imageStack)

        
        imageStack.axis = .horizontal
        imageStack.alignment = .fill
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ToiletPic")
        
        imageStack.addArrangedSubview(imageView)
        
        
        
        
        view.layoutIfNeeded()
        print(imageStack.frame)
        print(mainStack.frame)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
