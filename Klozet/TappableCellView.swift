//
//  TappableCellView.swift
//  Klozet
//
//  Created by Marek Fořt on 1/5/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit

class TappableCellView: UIStackView {
    
    let cellViewLabel: UILabel = UILabel()
    
     init() {
        super.init(frame: .zero)
        
        axis = .horizontal
        alignment = .center
        layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 18)
        isLayoutMarginsRelativeArrangement = true
        heightAnchor.constraint(equalToConstant: 53).isActive = true
        
        
        cellViewLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cellViewLabel.textColor = .defaultTextColor
        cellViewLabel.textAlignment = .left
        addArrangedSubview(cellViewLabel)
        
        let chevron = UIImageView(image: UIImage(asset: Asset.backChevron))
        addArrangedSubview(chevron)
        chevron.widthAnchor.constraint(equalToConstant: 9).isActive = true
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
