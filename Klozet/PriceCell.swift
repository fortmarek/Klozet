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
    
    var widthDimension = NSLayoutDimension()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, price: String, width: CGFloat) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cellStackView = setCellStack(view: self)
        
        setLeftLabel(stackView: cellStackView, text: "Price".localized)
        
        setPriceLabel(stackView: cellStackView, price: price, width: width)
    }
    
    fileprivate func setPriceLabel(stackView: UIStackView, price: String, width: CGFloat) {
        let label = UILabel()
        label.textColor = .vibrantGreen
        label.text = price
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        
        stackView.addArrangedSubview(label)
        
        label.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -15).isActive = true
        
        stackView.layoutIfNeeded()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
