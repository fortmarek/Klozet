//
//  ViewControllerAnimations.swift
//  Klozet
//
//  Created by Marek Fořt on 16/08/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    func filterButtonTapped(sender: UIButton) {
        
        isFilterSelected = !(isFilterSelected)
        
        rotate(filterImage)
        rotate(cancelImage)
        fadeOut()
        colorTransition()
        animateOptionButtons()
        
    }
    
    private func colorTransition() {
        let color = isFilterSelected ? UIColor(red:1.00, green:0.42, blue:0.20, alpha: 1.0) : UIColor.whiteColor()
        UIView.animateWithDuration(0.6, animations: {
            self.filterButton.backgroundColor = color
        })
    }
    
    private func rotate(image: UIImageView) {
        UIView.animateKeyframesWithDuration(0.6, delay: 0, options: [.CalculationModePaced, UIViewKeyframeAnimationOptions(animationOptions: .CurveEaseOut)], animations: {
            
            let fullRotation = CGFloat(M_PI * 2)
            
            for i in 1...3 {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: Double(i) / 3, animations: {
                    image.transform = CGAffineTransformMakeRotation(CGFloat(i) / 3 * fullRotation)
                })
            }
            
            }, completion: nil)
    }
    
    private func fadeOut() {
        
        let filterImageAlpha: CGFloat = isFilterSelected ? 0.0 : 1.0
        let cancelImageAlpha: CGFloat = isFilterSelected ? 1.0 : 0.0
        
        UIView.animateWithDuration(0.3, animations: {
            self.filterImage.alpha = filterImageAlpha
            self.cancelImage.alpha = cancelImageAlpha
            })
    }
    
    private func animateOptionButtons() {
        animateShadows()
        bounceOptionButtons()
    }
    
    private func bounceOptionButtons() {
        let offset: CGFloat = isFilterSelected ? -75 : 75
        let springDamping: CGFloat = isFilterSelected ? 0.4 : 1.0
        let duration: Double = isFilterSelected ? 0.6 : 0.3
        
        priceButtonConstraint.constant += offset
        timeButtonConstraint.constant += offset
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: 1, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func animateShadows() {
        
        let toShadowAlpha: Float = isFilterSelected ? 0.5 : 0.0
        let fromShadowAlpha: Float = isFilterSelected ? 0.0 : 0.5
        
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        
        shadowAnimation.fromValue = NSNumber(float: fromShadowAlpha)
        shadowAnimation.toValue = NSNumber(float: toShadowAlpha)
        shadowAnimation.duration = 0.1
        
        self.timeButton.layer.addAnimation(shadowAnimation, forKey: "shadowOpacity")
        self.priceButton.layer.addAnimation(shadowAnimation, forKey: "shadowOpacity")
        self.timeButton.layer.shadowOpacity = toShadowAlpha
        self.priceButton.layer.shadowOpacity = toShadowAlpha
        
    }
    
    func animateETA(leftButton: UIButton) {
    
        //Start with label rotated to then rotate it to the right angle
        leftButton.titleLabel?.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI / 2), 1, 0, 0)
        leftButton.titleLabel?.sizeToFit()
        
        //layoutIfNeeded after sizeToFit() so I don't animate the position only rotation
        view.layoutIfNeeded()
        
        //Center image in view, 22 is for image width
        let leftImageInset = (leftButton.frame.size.width - 22) / 2
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: leftImageInset, bottom: 10, right: leftImageInset)
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: {
            //Rotation
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / 500
            leftButton.titleLabel?.layer.transform = CATransform3DConcat(perspective, CATransform3DMakeRotation(0, 0, 0, 0))
            
            //Opacity
            leftButton.titleLabel?.alpha = 1
            
            //Needed to animate imageEdgeInset
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
}

extension UIViewKeyframeAnimationOptions {
    init(animationOptions: UIViewAnimationOptions) {
        rawValue = animationOptions.rawValue
    }
    
}


