//
//  TextViewCollectionViewCell.swift
//  Klozet
//
//  Created by Marek Fořt on 1/5/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit

class TextViewCollectionViewCell: UICollectionViewCell, Separable {
    
    var separatorView: UIView = UIView()
    let cellTextView = UITextView()
    let textViewDetailLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let textViewStackView = UIStackView()
        textViewStackView.axis = .vertical
        textViewStackView.spacing = 5
        textViewStackView.layoutMargins = UIEdgeInsets(top: 18, left: 16, bottom: 5, right: 5)
        textViewStackView.isLayoutMarginsRelativeArrangement = true
        textViewStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textViewStackView)
        textViewStackView.pinToViewHorizontally(self)
        textViewStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textViewStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        

        textViewDetailLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textViewDetailLabel.textColor = .defaultTextColor
        textViewDetailLabel.textAlignment = .left
        textViewDetailLabel.heightAnchor.constraint(equalToConstant: textViewDetailLabel.font.getHeight()).isActive = true
        textViewStackView.addArrangedSubview(textViewDetailLabel)
        
        cellTextView.font = UIFont.systemFont(ofSize: 18)
        cellTextView.textColor = .defaultTextColor
        textViewStackView.addArrangedSubview(cellTextView)
        
        
        
        addSeparator()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
