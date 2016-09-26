//
//  DetailTableView.swift
//  Klozet
//
//  Created by Marek Fořt on 23/09/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DetailTableView: UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
                
        //RowHeight
        rowHeight = 60
        
        //Disable scrolling
        isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let toilet = toilet else {return UITableViewCell()}

            return OpenTimeCell(style: .default, reuseIdentifier: "openTimeCell", openTimes: toilet.openTimes)
        }
        
        else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}




protocol LeftLabelInterface {
    
}

extension LeftLabelInterface {
    func setLeftLabel(stackView: UIStackView, text: String) {
        let label = UILabel()
        label.text = text
        label.textColor = Colors.pumpkinColor
        label.font = UIFont.systemFont(ofSize: 18)

        stackView.addArrangedSubview(label)
        label.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 15).isActive = true
    }
}

