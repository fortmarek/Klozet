//
//  PriceCell.swift
//  Klozet
//
//  Created by Marek Fořt on 27/09/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class PriceCell: UITableViewCell, DetailCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, price: String) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cellStackView = UIStackView()
        
        
        setLeftLabel(stackView: cellStackView, text: "Cena".localized)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
