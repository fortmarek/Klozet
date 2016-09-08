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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setImageBackground()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setImageBackground() {
        imageBackground.layer.cornerRadius = 10
    }

}
