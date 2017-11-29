//
//  ListButton.swift
//  Klozet
//
//  Created by Marek Fořt on 18/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class ListOpenButton: UIButton, FilterOpen, ListButtonDelegate, DirectionsDelegate {
    
    var toiletsDelegate: ListToiletsDelegate?
    var locationDelegate: UserLocation?
    var listControllerDelegate: ListControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(filterOpenButtonTapped), for: .touchUpInside)
    }
    
    @objc func filterOpenButtonTapped(sender: ListOpenButton) {
        guard var toiletsDelegate = self.toiletsDelegate else {return}
        
        //toiletsDelegate.startUpdating()
        
        //Change value to opposite
        toiletsDelegate.isFilterOpenSelected = !(toiletsDelegate.isFilterOpenSelected)
        
        self.changeInterface(isSelected: toiletsDelegate.isFilterOpenSelected)
        
        self.filterToilets()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ListPriceButton: UIButton, FilterOpen, ListButtonDelegate, DirectionsDelegate {
    var toiletsDelegate: ListToiletsDelegate?
    var locationDelegate: UserLocation?
    var listControllerDelegate: ListControllerDelegate?
    
    var allToilets = [Toilet]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(filterPriceButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func filterPriceButtonTapped(sender: ListPriceButton) {
        guard var toiletsDelegate = self.toiletsDelegate else {return}
        
        //toiletsDelegate.startUpdating()
        
        //Change value to opposite
        toiletsDelegate.isFilterPriceSelected = !(toiletsDelegate.isFilterPriceSelected)
        
        self.changeInterface(isSelected: toiletsDelegate.isFilterPriceSelected)

        self.filterToilets()
    
    }
    
    
}



