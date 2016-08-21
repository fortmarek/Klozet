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
        
        //CurrentLocationButton
        setCurrentLocationButton()
        
        //FilterButton
        setFilterButton()
        
        //OptionButtons
        setOptionButtons()
    }
    
    //Left callout view in MKAnnotationView
    func setLeftCalloutView() -> UIButton {
        let leftButton = UIButton.init(type: .Custom)
        leftButton.frame = CGRect(x: 0, y: 0, width: 55, height: 50)
        //BackgroundColor
        leftButton.backgroundColor = UIColor.orangeColor()
        
        //Image
        leftButton.setImage(UIImage(named: "Walking"), forState: .Normal)
        leftButton.setImage((UIImage(named: "Walking")), forState: .Highlighted)
        
        
        //Center image in view, 22 is for image width
        let leftImageInset = (leftButton.frame.size.width - 22) / 2
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: leftImageInset, bottom: 10, right: 0)
        
        //Title
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: UIColor.whiteColor()]
        let randNumber = Int(arc4random_uniform(100))
        leftButton.setAttributedTitle(NSAttributedString(string: "\(randNumber) min", attributes: attributes), forState: .Normal)
        leftButton.setAttributedTitle(NSAttributedString(string: "\(randNumber) min", attributes: attributes), forState: .Highlighted)
        
        //Title inset
        guard let titleLabel = leftButton.titleLabel else {return leftButton}
        let leftTitleLabelInset = -(titleLabel.frame.size.width) / 2 - (leftButton.frame.size.width - titleLabel.frame.size.width) / 2 + 5
        leftButton.titleEdgeInsets = UIEdgeInsets(top: 30, left: leftTitleLabelInset, bottom: 0, right: 0)
        
        return leftButton
    }
    
    private func setCurrentLocationButton() {
        setButtonProperties(currentLocationButton, image: "CurrentLocation", selectedImage: "CurrentLocationSelected", action: #selector(currentLocationButtonTapped(_:)), attribute: .Leading)
        currentLocationButton.selected = true
        currentLocationButton.adjustsImageWhenHighlighted = false
        currentLocationButton.setImage(UIImage(named:"CurrentLocationSelected"), forState: [.Selected, .Highlighted])
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
        
        //image
        button.setImage(UIImage(named: image), forState: .Normal)
        button.setImage(UIImage(named: selectedImage), forState: .Selected)
        button.setImage(UIImage(named: selectedImage), forState: .Highlighted)
        
        //Target function
        button.addTarget(UIButton(), action: action, forControlEvents: .TouchUpInside)
        
        //Constraint
        //If constraint leading (ie on the left of the screen) constraint positive, if trailing negative
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
        
        timeButton.addTarget(self, action: #selector(timeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        priceButton.addTarget(self, action: #selector(priceButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
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