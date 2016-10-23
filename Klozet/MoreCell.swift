//
//  MoreCell.swift
//  Klozet
//
//  Created by Marek Fořt on 23/10/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {
    
    let moreStack = UIStackView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addSubview(moreStack)
        moreStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        moreStack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 60).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setLabel() {
        let moreLabel = UILabel()
        moreLabel.text = "Načíst další".localized
        moreStack.addSubview(moreLabel)
    }

}
