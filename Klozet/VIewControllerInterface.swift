//
//  VIewControllerInterface.swift
//  Klozet
//
//  Created by Marek Fořt on 16/08/16.
//  Copyright © cornerConstant16 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ViewController {
    
    //Shadow for buttons
    fileprivate func addShadow(_ button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 3, height: 5)
        button.layer.shadowRadius = 6
    }
    
    func setCurrentLocationButton() {
        currentLocationButton.backgroundColor = .white
        currentLocationButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: 13, bottom: 12, right: 13)
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        currentLocationButton.layer.cornerRadius = 26
        currentLocationButton.imageView?.contentMode = .scaleAspectFit
        addShadow(currentLocationButton)
        view.addSubview(currentLocationButton)
        view.bringSubview(toFront: currentLocationButton)
        currentLocationButton.setHeightAndWidthAnchorToConstant(52)
        currentLocationButton.setImage(UIImage(asset: Asset.directionIcon), for: .normal)
        currentLocationButton.setImage(UIImage(asset: Asset.directionIconSelected), for: .selected)
        currentLocationButton.setImage(UIImage(asset: Asset.directionIconSelected), for: .highlighted)
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped(_:)), for: .touchUpInside)
        
        
        currentLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17).isActive = true
        currentLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        
        //View first appears at user's location (therefore current location button should be set as selected)
        currentLocationButton.isSelected = true
        currentLocationButton.setImage(UIImage(asset: Asset.currentLocationSelected), for: [.selected, .highlighted])
    }
}
