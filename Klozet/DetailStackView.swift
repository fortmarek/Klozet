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
        
        //TopAnchor to bottom of navigationBar (by adding its x origin and height)
        guard let navigationController = navigationController else {return}
        let topMainAnchor = navigationController.navigationBar.frame.height + navigationController.navigationBar.frame.origin.x
        topAnchor.constraint(equalTo: view.topAnchor, constant: topMainAnchor).isActive = true
        
        //BottomAnchor
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //WidthAnchor
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        //Axis
        axis = .vertical
        
        distribution = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

