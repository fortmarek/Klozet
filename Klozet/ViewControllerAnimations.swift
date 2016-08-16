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
        
    }
    
    private func colorTransition() {
        let color = isFilterSelected ? UIColor(red:1.00, green:0.42, blue:0.20, alpha: 1.0) : UIColor.whiteColor()
        UIView.animateWithDuration(1, animations: {
            self.filterButton.backgroundColor = color
        })
    }
    
    private func rotate(image: UIImageView) {
        UIView.animateKeyframesWithDuration(1, delay: 0, options: [.CalculationModePaced, UIViewKeyframeAnimationOptions(animationOptions: .CurveEaseOut)], animations: {
            
            let fullRotation = CGFloat(M_PI * 2)
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/3, animations: {
                image.transform = CGAffineTransformMakeRotation(1 / 3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
                image.transform = CGAffineTransformMakeRotation(2 / 3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                image.transform = CGAffineTransformMakeRotation(3 / 3 * fullRotation)
            })
            
            }, completion: nil)
        
        
    }
    
    private func fadeOut() {
        
        let filterImageAlpha = isFilterSelected ? 0.0 : 1.0
        let cancelImageAlpha = isFilterSelected ? 1.0 : 0.0
        
        UIView.animateWithDuration(1, animations: {
            self.filterImage.alpha = CGFloat(filterImageAlpha)
            self.cancelImage.alpha = CGFloat(cancelImageAlpha)
            }, completion: nil)
        
    }
}

extension UIViewKeyframeAnimationOptions {
    
    init(animationOptions: UIViewAnimationOptions) {
        rawValue = animationOptions.rawValue
    }
    
}


