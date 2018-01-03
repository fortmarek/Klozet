//
//  FilterPrice.swift
//  Klozet
//
//  Created by Marek Fořt on 09/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class FilterPriceButton: ButtonColorChangeable {
    
    var toiletController: ToiletController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        addTarget(self, action: #selector(priceButtonTapped), for: .touchUpInside)
        setButton(with: title, normalColor: .mainOrange, selectedColor: .white)
    }
    
    //TODO: Check if other filter is selected
    @objc func priceButtonTapped(_ sender: UIButton) {
        
        guard let toiletController = self.toiletController else {return}
        
        //Filter all toilets that are not for free
        let toiletsNotForFree = toiletController.toilets.filter({$0.price != "Free".localized})
        
        if self.isSelected == false {
            toiletController.removeToilets(toiletsNotForFree)
        }
        else {
            toiletController.addToilets(toiletsNotForFree)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
