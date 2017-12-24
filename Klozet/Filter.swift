//
//  Filter.swift
//  Klozet
//
//  Created by Marek Fořt on 12/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

protocol FilterButtonDelegate {
    var isFilterSelected: Bool { get }
}

class FilterButton: UIButton, FilterButtonDelegate {
    
    var filterDelegate: FilterInterfaceDelegate?
    
    let filterImage = UIImageView()
    let cancelImage = UIImageView()
    
    var isFilterSelected = false
    
    //Filter button interface
    
    func setInterface() {
        
        guard let filterDelegate = self.filterDelegate else {return}
        
        //Constraints
        
        let constant = filterDelegate.cornerConstant
        _ = filterDelegate.addConstraint(self, attribute: .trailing, constant: -constant)
        _ = filterDelegate.addConstraint(self, attribute: .bottom, constant: -constant)
        
        //Button design
        backgroundColor = UIColor.white
        layer.cornerRadius = 27.5
        
        addTarget(UIButton(), action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        //Button has two images for two states
        addFilterImages()
    }
    
    fileprivate func addFilterImages() {
        
        //Not selected filter button
        filterImage.image = UIImage(named:"Filter")
        
        //Selected filter button
        cancelImage.image = UIImage(named:"Cancel")
        cancelImage.alpha = 0.0
        
        guard let filterDelegate = self.filterDelegate else {return}
        
        filterDelegate.addSubview(filterImage)
        filterDelegate.addSubview(cancelImage)
        
        //Constraints
        let cornerConstant = filterDelegate.cornerConstant
        
        // cornerConstant for filterButton constraint, 27.5 for center of filterButton, 31 / 2 is center of filterImage
        let constant = (cornerConstant + 27.5) - 31 / 2
        
        //Bottom constraint of filterImage is with + 3 because shape makes it look not centered, even though it is centered
        _ = filterDelegate.addConstraint(filterImage, attribute: .bottom, constant: -constant + 3)
        
        //Bottom constraint for cancelImage
        _ = filterDelegate.addConstraint(cancelImage, attribute: .bottom, constant: -constant)
        
        let filterImages = [filterImage, cancelImage]
        
        for image in filterImages {
            
            image.translatesAutoresizingMaskIntoConstraints = false
            
            //Width and height
            image.addConstraint(NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 31))
            image.addConstraint(NSLayoutConstraint(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 31))
            
            //Trailing constraint
            _ = filterDelegate.addConstraint(image, attribute: .trailing, constant: -constant)
            
            
        }
        
    }
}

//MARK: Animations

extension FilterButton {
    @objc func filterButtonTapped(_ sender: UIButton) {
        
        animateSwitch()
        
        
        //Animate option buttons
        guard let filterDelegate = self.filterDelegate else {return}
        
        filterDelegate.timeButton.appear()
        filterDelegate.priceButton.appear()
        
    
    }
    
    
    //Animate switching from filter to cancel and vice versa
    fileprivate func animateSwitch() {
        //Change the state of filter button
        isFilterSelected = !(isFilterSelected)
        
        //Rotating buttons
        rotate(filterImage)
        rotate(cancelImage)
        
        //Fading out unselected button, fading in selected button
        fadeOut()
        
        //Animating color change (cancel button background is orange and icon white with filterButton it is vice versa
        colorTransition()
    }
    
    //Color change
    fileprivate func colorTransition() {
        //Determine what color based on if filter is selected or not
        let color = isFilterSelected ? .mainOrange : UIColor.white
        
        //Animate color with duration
        UIView.animate(withDuration: 0.6, animations: {
            self.backgroundColor = color
        })
    }
    
    
    fileprivate func rotate(_ image: UIImageView) {
        
        //360° rotation (key frame is needed because 360° might as well equal to 0° rotation)
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [.calculationModePaced, UIViewKeyframeAnimationOptions(animationOptions: .curveEaseOut)], animations: {
            
            //360°
            let fullRotation = CGFloat(Double.pi * 2)
            
            //At least three key frames (not only 360° is not unequivocal, neither is 180°)
            for i in 1...3 {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: Double(i) / 3, animations: {
                    image.transform = CGAffineTransform(rotationAngle: CGFloat(i) / 3 * fullRotation)
                })
            }
            }, completion: nil)
    }
    
    fileprivate func fadeOut() {
        
        //if isFilterSelected == true, filterImageAlpha is 0 (when selected, cancel button should appear)
        let filterImageAlpha: CGFloat = isFilterSelected ? 0.0 : 1.0
        let cancelImageAlpha: CGFloat = isFilterSelected ? 1.0 : 0.0
        
        //Animate alpha - fade out / in
        UIView.animate(withDuration: 0.3, animations: {
            self.filterImage.alpha = filterImageAlpha
            self.cancelImage.alpha = cancelImageAlpha
        })
    }
}


//Extension to simplify setting options for UIViewKeyFrameAnimation
extension UIViewKeyframeAnimationOptions {
    init(animationOptions: UIViewAnimationOptions) {
        rawValue = animationOptions.rawValue
    }
    
}

