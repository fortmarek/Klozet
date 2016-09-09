//
//  FilterPrice.swift
//  Klozet
//
//  Created by Marek Fořt on 09/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class FilterPriceButton: UIButton, FilterAnimation {
    var filterDelegate: FilterController?
    var constraint: NSLayoutConstraint?
    
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
}