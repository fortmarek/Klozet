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


let pumpkinColor = UIColor(red: 1.00, green: 0.42, blue: 0.20, alpha: 1.0)

extension ViewController {
    
    func createButtons() {
        
        //Adding all buttons to the ViewController
        addSubviews()
        
        //Setting properties that are same for every button
        setForEveryButton()
        
        //CurrentLocationButton
        setCurrentLocationButton()
        
        //FilterButton
        setFilterButton()
        
        //OptionButtons
        setOptionButtons()
    }
    
    
    private func addSubviews() {
        
        //Order of the views is important, change with caution (concerning filterButton and its images)
        let subViews = [timeButton, priceButton, currentLocationButton, filterButton, filterImage, cancelImage]
        
        //Adding subview to mapView
        for subView in subViews {
            view.addSubview(subView)
            
            //To front otherwise it's under mapView
            view.bringSubviewToFront(subView)
        }
    }
    
    //These properties are same for every button in array
    private func setForEveryButton() {
        let buttons = [currentLocationButton, filterButton, timeButton, priceButton]
        
        for button in buttons {
            addShadow(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.adjustsImageWhenHighlighted = false
            
            //Width and height
            view.addConstraint(NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: sizeConstant))
            view.addConstraint(NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: sizeConstant))
        }
    }
    
    //Button properties
    private func setButtonProperties(button: UIButton, image: String, selectedImage: String, action: Selector, attribute: NSLayoutAttribute) {
        
        //image
        button.setImage(UIImage(named: image), forState: .Normal)
        button.setImage(UIImage(named: selectedImage), forState: .Selected)
        button.setImage(UIImage(named: selectedImage), forState: .Highlighted)
        
        //Target function
        button.addTarget(UIButton(), action: action, forControlEvents: .TouchUpInside)
        
        //Constraint
        //If constraint leading (ie on the left of the screen) constraint positive, if trailing negative
        let constant = attribute == .Leading ? CGFloat(cornerConstant) : CGFloat(-cornerConstant)
        
        //Constraints for button to be in the bottom left/right corner
        view.addConstraint(NSLayoutConstraint(item: button, attribute: attribute, relatedBy: .Equal, toItem: view, attribute: attribute, multiplier: 1.0, constant: constant))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -cornerConstant))
    }
    
    //Shadow for buttons
    private func addShadow(button: UIButton) {
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 5)
        button.layer.shadowRadius = 6
    }
    
    private func setCurrentLocationButton() {
        setButtonProperties(currentLocationButton, image: "CurrentLocation", selectedImage: "CurrentLocationSelected", action: #selector(currentLocationButtonTapped(_:)), attribute: .Leading)
        
        //View first appears at user's location (therefore current location button should be set as selected)
        currentLocationButton.selected = true
        currentLocationButton.setImage(UIImage(named:"CurrentLocationSelected"), forState: [.Selected, .Highlighted])
    }
    
    //MARK: Individual button properties
    
    private func setFilterButton() {
        
        //Constraints
        view.addConstraint(NSLayoutConstraint(item: filterButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -cornerConstant))
        view.addConstraint(NSLayoutConstraint(item: filterButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -cornerConstant))
        
        filterButton.backgroundColor = UIColor.whiteColor()
        filterButton.layer.cornerRadius = 27.5
        
        filterButton.addTarget(UIButton(), action: #selector(filterButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        //Button has two images for two states
        addFilterImages()
    }
    
    
    private func addFilterImages() {
        
        //Not selected filter button
        filterImage.image = UIImage(named:"Filter")
        
        //Selected filter button
        cancelImage.image = UIImage(named:"Cancel")
        cancelImage.alpha = 0.0
        
        // cornerConstant for filterButton constraint, 27.5 for center of filterButton, 31 / 2 is center of filterImage
        let constant = (cornerConstant + 27.5) - 31 / 2
        
        //Bottom constraint of filterImage is with + 3 because shape makes it look not centered, even though it is centered
        view.addConstraint(NSLayoutConstraint(item: filterImage, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: CGFloat(-constant + 3)))
        
        //Bottom constraint for cancelImage
        view.addConstraint(NSLayoutConstraint(item: cancelImage, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: CGFloat(-constant)))
        
        let filterImages = [filterImage, cancelImage]
        
        for image in filterImages {
            
            image.translatesAutoresizingMaskIntoConstraints = false
            
            //Width and height
            view.addConstraint(NSLayoutConstraint(item: image, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 31))
            view.addConstraint(NSLayoutConstraint(item: image, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 31))
            
            //Trailing constraint
            view.addConstraint(NSLayoutConstraint(item: image, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: CGFloat(-constant)))
            
        }
        
    }
    
    
    private func setOptionButtons() {
        
        timeButton.annotationDelegate = self
        timeButton.filterDelegate = self
        
        priceButton.filterDelegate = self
        
        priceButton.setInterface()
        
        timeButton.setInterface()
        
        //Button targets
        priceButton.addTarget(self, action: #selector(priceButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        
    
    }
}