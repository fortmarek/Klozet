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
        rowHeight = 70
        
        //Disable scrolling
        isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let toilet = toilet else {return UITableViewCell()}
        
        
        if indexPath.row == 0 {
            return OpenTimeCell(style: .default, reuseIdentifier: "openTimeCell", openTimes: toilet.openTimes)
        }
        
        else {
            return PriceCell(style: .default, reuseIdentifier: "priceCell", price: toilet.price)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}




protocol DetailCell {
    
}

extension DetailCell {
    func setLeftLabel(stackView: UIStackView, text: String){
        let label = UILabel()
        label.text = text
        label.textColor = Colors.pumpkinColor
        label.font = UIFont.systemFont(ofSize: 18)

        stackView.addArrangedSubview(label)
        label.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 15).isActive = true
    }
    
    func setCellStack(view: UIView) -> UIStackView {
        let cellStackView = UIStackView()
        cellStackView.axis = .horizontal
        cellStackView.alignment = .center
        
        
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cellStackView)
        
        cellStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cellStackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cellStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        
        return cellStackView
    }
}

