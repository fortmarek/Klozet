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
    let locationDetailTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let locationDetailStackView = UIStackView()
        locationDetailStackView.axis = .vertical
        locationDetailStackView.spacing = 5
        locationDetailStackView.layoutMargins = UIEdgeInsets(top: 18, left: 16, bottom: 5, right: 5)
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
        locationDetailLabel.heightAnchor.constraint(equalToConstant: locationDetailLabel.font.getHeight()).isActive = true
        locationDetailStackView.addArrangedSubview(locationDetailLabel)
        
        locationDetailTextView.font = UIFont.systemFont(ofSize: 18)
        locationDetailTextView.textColor = .defaultTextColor
        locationDetailStackView.addArrangedSubview(locationDetailTextView)
        
        
        
        addSeparator()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
