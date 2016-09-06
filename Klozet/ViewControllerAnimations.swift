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
        
        animateSwitch()
        
        animateOptionButtons()
        
    }
    
    //MARK: Cancel and filter switch
    
    //Animate switching from filter to cancel and vice versa
    private func animateSwitch() {
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
    private func colorTransition() {
        //Determine what color based on if filter is selected or not
        let color = isFilterSelected ? UIColor(red:1.00, green:0.42, blue:0.20, alpha: 1.0) : UIColor.whiteColor()
        
        //Animate color with duration
        UIView.animateWithDuration(0.6, animations: {
            self.filterButton.backgroundColor = color
        })
    }
    
    
    private func rotate(image: UIImageView) {
        
        //360° rotation (key frame is needed because 360° might as well equal to 0° rotation)
        UIView.animateKeyframesWithDuration(0.6, delay: 0, options: [.CalculationModePaced, UIViewKeyframeAnimationOptions(animationOptions: .CurveEaseOut)], animations: {
            
            //360°
            let fullRotation = CGFloat(M_PI * 2)
            
            //At least three key frames (not only 360° is not unequivocal, neither is 180°)
            for i in 1...3 {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: Double(i) / 3, animations: {
                    image.transform = CGAffineTransformMakeRotation(CGFloat(i) / 3 * fullRotation)
                })
            }
            }, completion: nil)
    }
    
    private func fadeOut() {
        
        //if isFilterSelected == true, filterImageAlpha is 0 (when selected, cancel button should appear)
        let filterImageAlpha: CGFloat = isFilterSelected ? 0.0 : 1.0
        let cancelImageAlpha: CGFloat = isFilterSelected ? 1.0 : 0.0
        
        //Animate alpha - fade out / in
        UIView.animateWithDuration(0.3, animations: {
            self.filterImage.alpha = filterImageAlpha
            self.cancelImage.alpha = cancelImageAlpha
            })
    }
    
    
    //MARK: Option buttons animation
    
    private func animateOptionButtons() {
        animateShadows()
        bounceOptionButtons()
    }
    
    private func bounceOptionButtons() {
        
        //if isFilterSelected == false, buttons appear
        let offset: CGFloat = isFilterSelected ? -75 : 75
        let springDamping: CGFloat = isFilterSelected ? 0.4 : 1.0
        let duration: Double = isFilterSelected ? 0.6 : 0.3
        
        //Using constraints to change buttons' locations
        priceButtonConstraint.constant += offset
        timeButtonConstraint.constant += offset
        
        //Animate (dis)appearance of option buttons with spring (bounce)
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: 1, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    private func animateShadows() {
        
        let toShadowAlpha: Float = isFilterSelected ? 0.5 : 0.0
        let fromShadowAlpha: Float = isFilterSelected ? 0.0 : 0.5
        
        //Can't use UIViewAnimation with shadows, they only work with CABasicAnimation
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        
        //Duration and shadow values
        shadowAnimation.fromValue = NSNumber(float: fromShadowAlpha)
        shadowAnimation.toValue = NSNumber(float: toShadowAlpha)
        shadowAnimation.duration = 0.1
        
        //Animation init
        self.timeButton.layer.addAnimation(shadowAnimation, forKey: "shadowOpacity")
        self.priceButton.layer.addAnimation(shadowAnimation, forKey: "shadowOpacity")
        
        //Preserving final value after animation is ended
        self.timeButton.layer.shadowOpacity = toShadowAlpha
        self.priceButton.layer.shadowOpacity = toShadowAlpha
        
    }
    
    //MARK: MKAnnotationView ETA title
    
    func animateETA(leftButton: UIButton) {
    
        //Start with label rotated upside down to then rotate it to the right angle
        leftButton.titleLabel?.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI / 2), 1, 0, 0)
        leftButton.titleLabel?.sizeToFit()
        
        //layoutIfNeeded after sizeToFit() so I don't animate the position of title only rotation
        view.layoutIfNeeded()
        
        //Image position after adding title
        //Center image in view, 22 is for image width
        let leftImageInset = (leftButton.frame.size.width - 22) / 2
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: leftImageInset, bottom: 10, right: leftImageInset)
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: {
            //Rotation - 3D animation
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / 500
            //0, 0, 0, 0 because we want default value (we start this animation with already rotated title)
            leftButton.titleLabel?.layer.transform = CATransform3DConcat(perspective, CATransform3DMakeRotation(0, 0, 0, 0))
            
            //Opacity
            leftButton.titleLabel?.alpha = 1
            
            //Needed to animate imageEdgeInset
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
}

//Extension to simplify setting options for UIViewKeyFrameAnimation
extension UIViewKeyframeAnimationOptions {
    init(animationOptions: UIViewAnimationOptions) {
        rawValue = animationOptions.rawValue
    }
    
}


