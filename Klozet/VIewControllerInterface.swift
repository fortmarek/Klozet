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
    
    func createButtons() {
        
        //Adding all buttons to the ViewController
        addSubviews()
        
        //Setting properties that are same for every button
        setForEveryButton()
        
        //CurrentLocationButton
        setCurrentLocationButton()
        
        filterButton.filterDelegate = self
        filterButton.setInterface()
        
        //OptionButtons
        setOptionButtons()
    }
    
    
    fileprivate func addSubviews() {
        
        //Order of the views is important, change with caution (concerning filterButton and its images)
        let subViews = [timeButton, priceButton, currentLocationButton, filterButton]
        
        //Adding subview to mapView
        for subView in subViews {
            view.addSubview(subView)
            
            //To front otherwise it's under mapView
            view.bringSubview(toFront: subView)
        }
    }
    
    //These properties are same for every button in array
    fileprivate func setForEveryButton() {
        let buttons = [currentLocationButton, filterButton, timeButton, priceButton]
        
        for button in buttons {
            addShadow(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.adjustsImageWhenHighlighted = false
            
            //Width and height
            view.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: sizeConstant))
            view.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: sizeConstant))
        }
    }
    
    //Button properties
    fileprivate func setButtonProperties(_ button: UIButton, imageAsset: Asset, selectedImageAsset: Asset, action: Selector, attribute: NSLayoutAttribute) {
        
        //image
        button.setImage(UIImage(asset: imageAsset), for: .normal)
        button.setImage(UIImage(asset: selectedImageAsset), for: .selected)
        button.setImage(UIImage(asset: selectedImageAsset), for: .highlighted)
        
        //Target function
        button.addTarget(UIButton(), action: action, for: .touchUpInside)
        
        //Constraint
        //If constraint leading (ie on the left of the screen) constraint positive, if trailing negative
        let constant = attribute == .leading ? CGFloat(cornerConstant) : CGFloat(-cornerConstant)
        
        //Constraints for button to be in the bottom left/right corner
        view.addConstraint(NSLayoutConstraint(item: button, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1.0, constant: constant))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -cornerConstant))
    }
    
    //Shadow for buttons
    fileprivate func addShadow(_ button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 5)
        button.layer.shadowRadius = 6
    }
    
    fileprivate func setCurrentLocationButton() {
        currentLocationButton.backgroundColor = .white
        currentLocationButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: 13, bottom: 12, right: 13)
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        currentLocationButton.layer.cornerRadius = 26
        currentLocationButton.imageView?.contentMode = .scaleAspectFit
        currentLocationButton.setHeightAndWidthAnchorToConstant(52)
        setButtonProperties(currentLocationButton, imageAsset: .directionIcon, selectedImageAsset: .directionIconSelected, action: #selector(currentLocationButtonTapped(_:)), attribute: .leading)
        
        //View first appears at user's location (therefore current location button should be set as selected)
        currentLocationButton.isSelected = true
        currentLocationButton.setImage(UIImage(asset: .currentLocationSelected), for: [.selected, .highlighted])
    }
    
    fileprivate func setOptionButtons() {
        timeButton.annotationDelegate = self
        timeButton.filterDelegate = self
        timeButton.filterButtonDelegate = filterButton
        
        priceButton.filterDelegate = self
        priceButton.annotationDelegate = self
        priceButton.filterButtonDelegate = filterButton
        
        priceButton.setInterface()
        timeButton.setInterface()
    }
}
