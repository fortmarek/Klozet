//
//  VIewControllerInterface.swift
//  Klozet
//
//  Created by Marek Fořt on 16/08/16.
//  Copyright © cornerConstant16 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    func createButtons() {
        
        addSubviews()
        
        setForEveryButton()
        setButtonProperties(currentLocationButton, image: "CurrentLocation", selectedImage: "CurrentLocation", action: #selector(currentLocationButtonTapped(_:)), attribute: .Leading)
        setFilterButton()
        setOptionButtons()
    }
    
    //Same for every button
    private func setForEveryButton() {
        let buttons = [currentLocationButton, filterButton, timeButton, priceButton]

        for button in buttons {
            addShadow(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            //Width and height
            view.addConstraint(NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: sizeConstant))
            view.addConstraint(NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: sizeConstant))
        }
    }
    
    private func addSubviews() {
        
        //Order of the views is important, change with caution (concerning filterButton and its images)
        let subViews = [timeButton, priceButton, currentLocationButton, filterButton, filterImage, cancelImage]
        
        for subView in subViews {
            view.addSubview(subView)
            view.bringSubviewToFront(subView)
        }
    }
    
    private func addShadow(button: UIButton) {
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 5)
        button.layer.shadowRadius = 6
    }
    
    private func setButtonProperties(button: UIButton, image: String, selectedImage: String, action: Selector, attribute: NSLayoutAttribute) {
        button.setImage(UIImage(named: image), forState: .Normal)
        button.setImage(UIImage(named: selectedImage), forState: .Selected)
        button.addTarget(UIButton(), action: action, forControlEvents: .TouchUpInside)
        let constant = attribute == .Leading ? CGFloat(cornerConstant) : CGFloat(-cornerConstant)
        view.addConstraint(NSLayoutConstraint(item: button, attribute: attribute, relatedBy: .Equal, toItem: view, attribute: attribute, multiplier: 1.0, constant: constant))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -cornerConstant))
    }
    
    private func setFilterButton() {
        view.addConstraint(NSLayoutConstraint(item: filterButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -cornerConstant))
        view.addConstraint(NSLayoutConstraint(item: filterButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -cornerConstant))
        
        filterButton.backgroundColor = UIColor.whiteColor()
        filterButton.layer.cornerRadius = 27.5
        
        filterButton.addTarget(UIButton(), action: #selector(filterButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        addFilterImages()
    }
    
    private func addFilterImages() {
        
        filterImage.image = UIImage(named:"Filter")
        cancelImage.image = UIImage(named:"Cancel")
        cancelImage.alpha = 0.0
        
        // cornerConstant for filterButton constraint, 22.5 for center of filterButton, 31 / 2 for center of filterImage
        let constant = (cornerConstant + 27.5) - 31 / 2
        
        //Bottom constraint for filterImage is different (shape makes it look not centerd when it is centered)
        view.addConstraint(NSLayoutConstraint(item: filterImage, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: CGFloat(-constant + 3)))
        
        //Bottom constraint for cancelImage
        view.addConstraint(NSLayoutConstraint(item: cancelImage, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: CGFloat(-constant)))
        
        let filterImages = [filterImage, cancelImage]
        
        for image in filterImages {
            
            image.translatesAutoresizingMaskIntoConstraints = false
            
            //Width and height
            view.addConstraint(NSLayoutConstraint(item: image, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 31))
            view.addConstraint(NSLayoutConstraint(item: image, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 31))
        
            view.addConstraint(NSLayoutConstraint(item: image, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: CGFloat(-constant)))
            
        }
        
    }
    
    
    private func setOptionButtons() {
        
        timeButton.layer.shadowOpacity = 0.0
        priceButton.layer.shadowOpacity = 0.0
        
        timeButton.setImage(UIImage(named: "Clock"), forState: .Normal)
        timeButton.setImage(UIImage(named: "ClockSelected"), forState: .Selected)
        priceButton.setImage(UIImage(named: "Price"), forState: .Normal)
        priceButton.setImage(UIImage(named: "PriceSelected"), forState: .Selected)
        
        let bottomLayout = NSLayoutConstraint(item: priceButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -cornerConstant)
        let trailingLayout = NSLayoutConstraint(item: timeButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -cornerConstant)
        
        priceButtonConstraint = bottomLayout
        timeButtonConstraint = trailingLayout
        
        view.addConstraint(priceButtonConstraint)
        view.addConstraint(timeButtonConstraint)
        view.addConstraint(NSLayoutConstraint(item: priceButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -cornerConstant))
        view.addConstraint(NSLayoutConstraint(item: timeButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -cornerConstant))
    
    }
}