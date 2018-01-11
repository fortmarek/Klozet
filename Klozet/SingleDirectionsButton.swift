//
//  SingleDirectionsButton.swift
//  Klozet
//
//  Created by Marek Fořt on 1/11/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit 

class SingleDirectionsButton: UIBarButtonItem, MapsDirections {
    
    var annotation: Toilet
    
    init(annotation: Toilet) {
        self.annotation = annotation
        super.init()
        
        style = .plain
        title = "Directions".localized
        action = #selector(callDirectionsMapsFunc)
        target = self
        
    }
    
    @objc func callDirectionsMapsFunc() {
        //Open Apple Maps
        getDirections(coordinate: annotation.coordinate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
