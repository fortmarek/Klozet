//
//  FilterPrice.swift
//  Klozet
//
//  Created by Marek Fořt on 09/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class FilterPriceButton: UIButton, FilterOptionButton {
    
    var annotationDelegate: AnnotationController?
    var filterDelegate: FilterInterfaceDelegate?
    var filterButtonDelegate: FilterButtonDelegate?
    var constraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(priceButtonTapped(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInterface() {
        setBasicInterface()
        
        guard let filterDelegate = self.filterDelegate else {return}
        
        self.setImage(UIImage(named: "Price"), for: UIControlState())
        self.setImage(UIImage(named: "PriceSelected"), for: .selected)
        
        let cornerConstant = filterDelegate.cornerConstant
        
        let bottomLayout = filterDelegate.addConstraint(self, attribute: .bottom, constant: -cornerConstant)
        self.constraint = bottomLayout
        
        
        _ = filterDelegate.addConstraint(self, attribute: .trailing, constant: -cornerConstant)

    }
    
    //TODO: Check if other filter is selected
    func priceButtonTapped(_ sender: UIButton) {
        
        defer {
            changeButtonState()
        }
        
        guard let annotationDelegate = self.annotationDelegate else {return}
        
        //Filter all toilets that are not for free
        let toiletsNotForFree = annotationDelegate.toilets.filter({$0.price != "Free".localized})
        
        if self.isSelected == false {
            annotationDelegate.mapView.removeAnnotations(toiletsNotForFree)
        }
        else {
            annotationDelegate.mapView.addAnnotations(toiletsNotForFree)
        }
        
    }
}
