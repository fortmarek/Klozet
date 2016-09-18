//
//  ListButton.swift
//  Klozet
//
//  Created by Marek Fořt on 18/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class ListOpenButton: UIButton, FilterOpen, ListButtonDelegate, DirectionsDelegate {
    
    var toiletsDelegate: ListToiletsDelegate?
    var locationDelegate: UserLocation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addTarget(self, action: #selector(filterOpenButtonTapped), for: .touchUpInside)
    }
    
    func filterOpenButtonTapped(sender: ListOpenButton) {
        guard var toiletsDelegate = self.toiletsDelegate else {return}
        
        toiletsDelegate.startUpdating()
        
        //Change value to opposite
        toiletsDelegate.isFilterOpenSelected = !(toiletsDelegate.isFilterOpenSelected)
        
        DispatchQueue.main.async {
            self.isSelected = !(self.isSelected)
            self.changeInterface(isSelected: toiletsDelegate.isFilterOpenSelected)
        }
        
        
        DispatchQueue.global().async {
            self.filterToilets()
        }
        
        
    }
    
    func changeInterface(isSelected: Bool){
        if isSelected {
            backgroundColor = Colors.pumpkinColor
            titleLabel?.textColor = UIColor.white
        }
        else {
            backgroundColor = UIColor.clear
            titleLabel?.textColor = Colors.pumpkinColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ListPriceButton: UIButton, FilterOpen, ListButtonDelegate, DirectionsDelegate {
    var toiletsDelegate: ListToiletsDelegate?
    var locationDelegate: UserLocation?
    
    var allToilets = [Toilet]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        //Save all toilets so they can be readded later
        guard let toiletsDelegate = self.toiletsDelegate else {return}
        allToilets = toiletsDelegate.toilets
        
        addTarget(self, action: #selector(filterPriceButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func filterPriceButtonTapped(sender: ListPriceButton) {
        guard var toiletsDelegate = self.toiletsDelegate else {return}
        
        
        
        //Only free toilets
        if isSelected {
            let toiletsForFree = toiletsDelegate.toilets.filter({$0.price == "Zdarma"})
            toiletsDelegate.toilets = toiletsForFree
        }
        
        //All toilets
        else {
            toiletsDelegate.toilets = allToilets
        }
        
        toiletsDelegate.reloadTable()
    
    }
    
}



protocol ListButtonDelegate {
    var toiletsDelegate: ListToiletsDelegate? { get set }
    var locationDelegate: UserLocation? { get set }
}

enum ListButtonSide {
    case left, right
}



extension ListButtonDelegate where Self: UIButton, Self: FilterOpen, Self: DirectionsDelegate {
    
    init(frame: CGRect) {
        self.init(frame: frame)
    }
    
    init(title: String, contentView: UIView, side: ListButtonSide, toiletsDelegate: ListToiletsDelegate) {
        self.init()
        
        self.toiletsDelegate = toiletsDelegate
        self.locationDelegate = toiletsDelegate.locationDelegate
        
        
        //Title
        setTitleLabel(title: title)
        
        //Adding subview to superview plus constraints
        contentView.addSubview(self)
        addButtonConstraints(contentView: contentView, side: side)
        
        setButtonBorder(side: side)
        
    }
    
    func filterToilets() {
        guard var toiletsDelegate = self.toiletsDelegate else {return}
        
        var toilets = toiletsDelegate.toilets
        
        let isFilterOpenSelected = toiletsDelegate.isFilterOpenSelected
        let isFilterPriceSelected = toiletsDelegate.isFilterPriceSelected
        
        //Get only open and free toilets
        if isFilterOpenSelected && isFilterPriceSelected {
            toilets = toiletsDelegate.allToilets.filter({
                isToiletOpen($0) && $0.price == "Zdarma"
            })
        }
        
        //Get open toilets
        else if isFilterOpenSelected {
            toilets = toiletsDelegate.allToilets.filter({
                isToiletOpen($0)
            })
        }
        
        //Get free toilets
        else if isFilterPriceSelected {
            toilets = toiletsDelegate.allToilets.filter({
                $0.price == "Zdarma"
            })
        }
        
        //Get all toilets
        else {
            toilets = toiletsDelegate.allToilets
        }
        
        //Order filtered toilets by distance
        toiletsDelegate.toilets = toilets.sorted(by: {
            getDistance($0.coordinate) < getDistance($1.coordinate)
        })
        
        
        //Update table
        toiletsDelegate.reloadTable()
        
        
    }
    
    
    //MARK: Interface
    
    fileprivate func addButtonConstraints(contentView: UIView, side: ListButtonSide) {
        translatesAutoresizingMaskIntoConstraints = false
        
        //Height
        contentView.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30))
        
        //Center vertically
        contentView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        //Distance between listButtons
        let constant = contentView.frame.size.width / 2
        
        //Horizontal possition
        if side == .left {
            contentView.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -constant))
            contentView.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 40))
            
        }
            
        else {
            contentView.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: constant))
            contentView.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -40))
        }
        
        //Applying constraints
        contentView.layoutIfNeeded()
    }
    
    fileprivate func setTitleLabel(title: String) {
        //Title
        setTitle(title, for: .normal)
        setTitle(title, for: .selected)
        
        setTitleColor(UIColor.orange, for: .normal)
        setTitleColor(UIColor.white, for: .selected)
        
        titleLabel?.font = titleLabel?.font.withSize(15)
    }
    
    fileprivate func setButtonBorder(side: ListButtonSide) {
        
        var cornersToRound = UIRectCorner()
        
        if side == .left {
            cornersToRound = [.topLeft, .bottomLeft]
        }
            
        else {
            cornersToRound = [.topRight, .bottomRight]
        }
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: cornersToRound, cornerRadii: CGSize(width: 5, height: 5))
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = 1
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = Colors.pumpkinColor.cgColor
        
        layer.addSublayer(borderLayer)
        
    }
    
    
    
}
