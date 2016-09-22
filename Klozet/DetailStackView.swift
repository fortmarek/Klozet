//
//  DetailStackView.swift
//  Klozet
//
//  Created by Marek Fořt on 22/09/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class DetailStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    convenience init(view: UIView, navigationController: UINavigationController?) {
        self.init()
        
        //self.frame = view.frame
        view.layoutIfNeeded()
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        guard let navigationController = navigationController else {return}
        
        //TopAnchor to bottom of navigationBar (by adding its x origin and height)
        let topMainAnchor = navigationController.navigationBar.frame.height + navigationController.navigationBar.frame.origin.x
        
        topAnchor.constraint(equalTo: view.topAnchor, constant: topMainAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor)
        axis = .vertical
        
        
        setImageStack()
        
        
        
    }
    
    fileprivate func setImageStack() {
        
        let imageStack = UIStackView()
        
        addArrangedSubview(imageStack)
        
        imageStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageStack.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageStack.translatesAutoresizingMaskIntoConstraints = false
        
        imageStack.axis = .horizontal
        imageStack.alignment = .fill
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ToiletPic")
        
        imageStack.addArrangedSubview(imageView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

