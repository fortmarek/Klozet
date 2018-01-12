//
//  PriceCollectionViewCell.swift
//  Klozet
//
//  Created by Marek Fořt on 1/12/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit

class PriceCollectionViewCell: UICollectionViewCell, Separable {
    
    var prices: [String] = []
    var separatorView: UIView = UIView()
    let tappableCellView = TappableCellView()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(tappableCellView)
        tappableCellView.pinToView(self)
        
        priceLabel.textColor = .defaultTextColor
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        priceLabel.text = "Free"
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(priceLabel)
        priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true 
        priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60).isActive = true
        
        addSeparator()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


