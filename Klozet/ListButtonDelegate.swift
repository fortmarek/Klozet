//
//  ListButtonDelegate.swift
//  Klozet
//
//  Created by Marek Fořt on 19/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit


protocol ListButtonDelegate {
    var toiletsDelegate: ListToiletsDelegate? { get set }
    var locationDelegate: UserLocation? { get set }
    var listControllerDelegate: ListControllerDelegate? { get set }
}

enum ListButtonSide {
    case left, right
}



extension ListButtonDelegate where Self: UIButton, Self: FilterOpen, Self: DirectionsDelegate {
    
    init(frame: CGRect) {
        self.init(frame: frame)
    }
    
    init(title: String, contentView: UIView, side: ListButtonSide, toiletsDelegate: ListToiletsDelegate, listControllerDelegate: ListControllerDelegate) {
        self.init()
        
        //Delegates
        self.toiletsDelegate = toiletsDelegate
        self.locationDelegate = toiletsDelegate.locationDelegate
        self.listControllerDelegate = listControllerDelegate
        
        
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
                isToiletOpen($0) && $0.price == "Free".localized
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
                $0.price == "Free".localized
            })
        }
            
            //Get all toilets
        else {
            toilets = toiletsDelegate.allToilets
        }
        
        toiletsDelegate.toilets = toilets
        
        
        //Update table
        toiletsDelegate.reloadTable()
        
        
    }
    
    //MARK: Interface
    
    func changeInterface(isSelected: Bool){
        if isSelected {
            backgroundColor = .mainOrange
        }
        else {
            backgroundColor = UIColor.clear
        }
        self.isSelected = !(self.isSelected)
        
        guard let listControllerDelegate = self.listControllerDelegate else {return}
        
        listControllerDelegate.changeMiddleBorderColor()
    }
    
    fileprivate func addButtonConstraints(contentView: UIView, side: ListButtonSide) {
        translatesAutoresizingMaskIntoConstraints = false
        
        //Height
        contentView.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30))
        
        //Center vertically
        contentView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        //Distance between listButtons
        let constant = contentView.frame.size.width / 2 + 0.5
        
        //Horizontal position
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
        
        //Colors also for highlighted, text was changing color before background (that only responds to touchUpInside)
        setTitleColor(.mainOrange, for: .normal)
        setTitleColor(UIColor.white, for: .selected)
        setTitleColor(.mainOrange, for: .highlighted)
        setTitleColor(UIColor.white, for: [.highlighted, .selected])
        
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
        
        layer.mask = borderLayer
        
        
    }
    
    
    
}
