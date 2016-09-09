//
//  Filter.swift
//  Klozet
//
//  Created by Marek Fořt on 09/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

protocol FilterAnimation {
    var constraint: NSLayoutConstraint? { get set }
    var filterDelegate: FilterController? { get }
}


extension FilterAnimation where Self: UIButton {
    func appear() {
        animateShadows()
        bounceUp()
    }
    
    private func bounceUp() {
        
        //Unwrap filterDelegate
        guard let filterDelegate = self.filterDelegate else {return}
        
        //Getting filter state from filterDelegate
        let isFilterSelected = filterDelegate.isFilterSelected
        
        //if isFilterSelected == false, buttons appear
        let offset: CGFloat = isFilterSelected ? -75 : 75
        let springDamping: CGFloat = isFilterSelected ? 0.4 : 1.0
        let duration: Double = isFilterSelected ? 0.6 : 0.3
        
        //Using constraints to change buttons' locations
        constraint?.constant += offset
        
        //Animate (dis)appearance of option buttons with spring (bounce)
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: 1, options: [], animations: {
            guard let superview = self.superview else {return}
            superview.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    private func animateShadows() {
        
        //Unwrap filterDelegate
        guard let filterDelegate = self.filterDelegate else {return}
        
        //Getting filter state from filterDelegate
        let isFilterSelected = filterDelegate.isFilterSelected
        
        let toShadowAlpha: Float = isFilterSelected ? 0.5 : 0.0
        let fromShadowAlpha: Float = isFilterSelected ? 0.0 : 0.5
        
        //Can't use UIViewAnimation with shadows, they only work with CABasicAnimation
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        
        //Duration and shadow values
        shadowAnimation.fromValue = NSNumber(float: fromShadowAlpha)
        shadowAnimation.toValue = NSNumber(float: toShadowAlpha)
        shadowAnimation.duration = 0.1
        
        //Animation init
        self.layer.addAnimation(shadowAnimation, forKey: "shadowOpacity")
        
        //Preserving final value after animation is ended
        self.layer.shadowOpacity = toShadowAlpha
        
    }
}