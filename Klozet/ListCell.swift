//
//  ListCell.swift
//  Klozet
//
//  Created by Marek Fořt on 08/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    //Background for toilet image
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var priceBubble: UIView!
    @IBOutlet weak var openBubble: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setCornerRadius(imageBackground, cornerRadius: 10)
        setCornerRadius(priceBubble, cornerRadius: 7)
        setCornerRadius(openBubble, cornerRadius: 7)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCornerRadius(view: UIView, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
    }
}


