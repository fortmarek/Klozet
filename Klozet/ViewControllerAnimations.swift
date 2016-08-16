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
        print("HEY")
        rotate()
        fadeOut()
        
    }
    
    func rotate() {
        UIView.animateKeyframesWithDuration(1, delay: 0, options: [.CalculationModePaced, UIViewKeyframeAnimationOptions(animationOptions: .CurveEaseOut)], animations: {
            
            let fullRotation = CGFloat(M_PI * 2)
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/3, animations: {
                self.filterImage.transform = CGAffineTransformMakeRotation(1 / 3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
                self.filterImage.transform = CGAffineTransformMakeRotation(2 / 3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                self.filterImage.transform = CGAffineTransformMakeRotation(3 / 3 * fullRotation)
            })
            
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animateWithDuration(1, animations: {
            self.filterImage.alpha = 0.0
            }, completion: nil)
        
        UIView.animateWithDuration(1, animations: {
            self.cancelImage.alpha = 1.0
            }, completion: nil)
    }
}