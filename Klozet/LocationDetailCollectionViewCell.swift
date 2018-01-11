//
//  LocationDetailCollectionViewCell.swift
//  Klozet
//
//  Created by Marek Fořt on 1/5/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit

class LocationDetailCollectionViewCell: UICollectionViewCell, Separable {
    
    var separatorView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let locationDetailStackView = UIStackView()
        locationDetailStackView.axis = .vertical
        locationDetailStackView.spacing = 15
        locationDetailStackView.layoutMargins = UIEdgeInsets(top: 18, left: 16, bottom: 10, right: 5)
        locationDetailStackView.isLayoutMarginsRelativeArrangement = true
        locationDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(locationDetailStackView)
        locationDetailStackView.pinToViewHorizontally(self)
        locationDetailStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        locationDetailStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        
        let locationDetailLabel = UILabel()
        locationDetailLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        locationDetailLabel.textColor = .defaultTextColor
        locationDetailLabel.text = "Location details"
        locationDetailLabel.textAlignment = .left
        locationDetailStackView.addArrangedSubview(locationDetailLabel)
        
        
        addSeparator()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
