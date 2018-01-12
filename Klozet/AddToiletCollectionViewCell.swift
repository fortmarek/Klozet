//
//  AddToiletCollectionViewCell.swift
//  Klozet
//
//  Created by Marek Fořt on 1/12/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit

class AddToiletCollectionViewCell: UICollectionViewCell, Separable {
    
    var separatorView: UIView = UIView()
    let tappableCellView = TappableCellView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(tappableCellView)
        tappableCellView.pinToView(self)
        
        addSeparator()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
