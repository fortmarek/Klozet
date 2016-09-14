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
    fileprivate func setButtonProperties(_ button: UIButton, image: String, selectedImage: String, action: Selector, attribute: NSLayoutAttribute) {
        
        //image
        button.setImage(UIImage(named: image), for: UIControlState())
        button.setImage(UIImage(named: selectedImage), for: .selected)
        button.setImage(UIImage(named: selectedImage), for: .highlighted)
        
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
        setButtonProperties(currentLocationButton, image: "CurrentLocation", selectedImage: "CurrentLocationSelected", action: #selector(currentLocationButtonTapped(_:)), attribute: .leading)
        
        //View first appears at user's location (therefore current location button should be set as selected)
        currentLocationButton.isSelected = true
        currentLocationButton.setImage(UIImage(named:"CurrentLocationSelected"), for: [.selected, .highlighted])
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
