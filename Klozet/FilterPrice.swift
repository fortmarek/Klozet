//
//  FilterPrice.swift
//  Klozet
//
//  Created by Marek Fořt on 09/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class FilterPriceButton: UIButton, FilterButton {
    var annotationDelegate: AnnotationController?
    var filterDelegate: FilterController?
    var constraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(priceButtonTapped(_:)), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInterface() {
        setBasicInterface()
        
        guard let filterDelegate = self.filterDelegate else {return}
        
        self.setImage(UIImage(named: "Price"), forState: .Normal)
        self.setImage(UIImage(named: "PriceSelected"), forState: .Selected)
        
        let cornerConstant = filterDelegate.cornerConstant
        
        let bottomLayout = filterDelegate.addConstraint(self, attribute: .Bottom, constant: -cornerConstant)
        self.constraint = bottomLayout
        
        
        filterDelegate.addConstraint(self, attribute: .Trailing, constant: -cornerConstant)

    }
    
    func priceButtonTapped(sender: UIButton) {
        
        defer {
            changeButtonState()
        }
        
        guard let annotationDelegate = self.annotationDelegate else {return}
        
        //Filter all toilets that are not for free
        let toiletsNotForFree = annotationDelegate.toilets.filter({$0.price != "Zdarma"})
        
        if self.selected == false {
            annotationDelegate.mapView.removeAnnotations(toiletsNotForFree)
        }
        else {
            annotationDelegate.mapView.addAnnotations(toiletsNotForFree)
        }
        
    }
}