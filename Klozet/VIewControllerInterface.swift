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
        
        //We start with O shadow opacity, otherwise it could be seen from behind the filter button (the shadow is animated when buttons appear)
        timeButton.layer.shadowOpacity = 0.0
        priceButton.layer.shadowOpacity = 0.0
        
        //Button targets
        timeButton.addTarget(self, action: #selector(timeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        priceButton.addTarget(self, action: #selector(priceButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        //Images
        timeButton.setImage(UIImage(named: "Clock"), forState: .Normal)
        timeButton.setImage(UIImage(named: "ClockSelected"), forState: .Selected)
        priceButton.setImage(UIImage(named: "Price"), forState: .Normal)
        priceButton.setImage(UIImage(named: "PriceSelected"), forState: .Selected)
        
        //Bottom priceButton layout, trailing timeButton layout
        let bottomLayout = NSLayoutConstraint(item: priceButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -cornerConstant)
        let trailingLayout = NSLayoutConstraint(item: timeButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -cornerConstant)
        
        //Setting constraint as variables, needed for option buttons animations
        priceButtonConstraint = bottomLayout
        timeButtonConstraint = trailingLayout
        
        //Adding var constraint plus other two constraints, not needed as vars because they are not used in the animations
        view.addConstraint(priceButtonConstraint)
        view.addConstraint(timeButtonConstraint)
        view.addConstraint(NSLayoutConstraint(item: priceButton, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -cornerConstant))
        view.addConstraint(NSLayoutConstraint(item: timeButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -cornerConstant))
    
    }
    
    //MARK: MKAnnotationView interface
    
    //Left callout view in MKAnnotationView
    func setLeftCalloutView() -> UIButton {
        
        let leftButton = UIButton.init(type: .Custom)
        leftButton.frame = CGRect(x: 0, y: 0, width: 55, height: 50)
        
        //BackgroundColor
        leftButton.backgroundColor = pumpkinColor
        
        
        //Image
        leftButton.setImage(UIImage(named: "Walking"), forState: .Normal)
        leftButton.setImage((UIImage(named: "Walking")), forState: .Highlighted)
        
        //Center image in view, 22 is for image width
        let leftImageInset = (leftButton.frame.size.width - 22) / 2
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: leftImageInset, bottom: 0, right: leftImageInset)
        
        
        //Title inset
        leftButton.titleEdgeInsets = UIEdgeInsets(top: 30, left: -22.5, bottom: 0, right: 0)
        leftButton.titleLabel?.textAlignment = .Center
        
        return leftButton
    }
    
    //ETA for annotation view
    func getEta(destination: CLLocationCoordinate2D, annotationView: MKAnnotationView) {
        
        //Set path
        let directions = requestDirections(destination)
        
        //Calculate ETA
        directions.calculateETAWithCompletionHandler({
            etaResponse, error in
            guard let expectedTravelTime = etaResponse?.expectedTravelTime else {return}
            
            //Function to properly display ETA
            self.setTitle(expectedTravelTime, annotationView: annotationView)
            
        })
    }
    
    private func setTitle(ETA: NSTimeInterval, annotationView: MKAnnotationView) {
        
        //Getting leftCalloutAccessoryView
        guard let leftButton = annotationView.leftCalloutAccessoryView as? UIButton else {return}
        
        //Converting ETA in NSTimeInterval to minutes or hours
        let etaInt = NSInteger(ETA)
        var time = ""
        
        let oneHour = 3600
        let minutes = (etaInt / 60) % 60
        if etaInt > oneHour {
            let hours = (etaInt / oneHour) % oneHour
            time = "\(hours)h \(minutes)m"
        }
            
        else {
            time = "\(minutes) min"
        }
        
        //Title with attributes
        leftButton.titleLabel?.alpha = 0
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: UIColor.whiteColor()]
        leftButton.setAttributedTitle(NSAttributedString(string: time, attributes: attributes), forState: .Normal)
        leftButton.setAttributedTitle(NSAttributedString(string: time, attributes: attributes), forState: .Highlighted)
        
        //Animating ETA title appearance
        animateETA(leftButton)
        
    }
}