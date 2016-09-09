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
        
        timeButton.appear()
        priceButton.appear()
        
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
}

//Extension to simplify setting options for UIViewKeyFrameAnimation
extension UIViewKeyframeAnimationOptions {
    init(animationOptions: UIViewAnimationOptions) {
        rawValue = animationOptions.rawValue
    }
    
}


