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
        
        let cellStackView = setCellStack(view: self)
        
        setLeftLabel(stackView: cellStackView, text: "Cena".localized)
        
        setPriceLabel(stackView: cellStackView, price: price)
    }
    
    fileprivate func setPriceLabel(stackView: UIStackView, price: String) {
        let label = UILabel()
        label.textColor = Colors.greenColor
        label.text = price
        
        stackView.addArrangedSubview(label)
        
        label.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 15)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
