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
        
        allowsSelection = false
        
        //Set height to rowHeight * 2
        heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let toilet = toilet else {return UITableViewCell()}
        
        //FIX:
//        if indexPath.row == 0 {
//            let openTimeCell = OpenTimeCell(style: .default, reuseIdentifier: "openTimeCell", openTimes: toilet.openTimes)
//            widthDimension = openTimeCell.widthDimension
//            return openTimeCell
//        }
//
//        else {
//            let priceCell = PriceCell(style: .default, reuseIdentifier: "priceCell", price: toilet.price, width: widthDimension)
//            return priceCell
//        }
        
        let priceCell = PriceCell(style: .default, reuseIdentifier: "priceCell", price: toilet.price, width: widthDimension)
        return priceCell
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
    func setLeftLabel(stackView: UIStackView, text: String) {
        let label = UILabel()
        label.text = text
        label.textColor = .mainBlue
        label.font = UIFont.systemFont(ofSize: 18)

        stackView.addArrangedSubview(label)
        label.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
    }
    
    func setCellStack(view: UIView) -> UIStackView {
        let cellStackView = UIStackView()
        cellStackView.axis = .horizontal
        cellStackView.alignment = .center
        cellStackView.spacing = 5
        
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cellStackView)
        
        cellStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cellStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        cellStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        
        return cellStackView
    }
}

