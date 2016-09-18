//
//  ListController.swift
//  Klozet
//
//  Created by Marek Fořt on 17/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class ListControllerContainer: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(view: UIView) {
        self.init(frame: CGRect())
        
        //BlurEffect
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        view.addSubview(blurredEffectView)
        
        
        
        
        //ListController
        let _ = ListButton(title: "Otevřeno".localized, contentView: blurredEffectView.contentView, side: .left)
        let _ = ListButton(title: "Zdarma".localized, contentView: blurredEffectView.contentView, side: .right)
        
        //Otherwise it is left under tableView
        view.bringSubview(toFront: blurredEffectView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




class ListButton: UIButton, FilterOpen, ListButtonDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



protocol ListButtonDelegate {
    
}


enum ListButtonSide {
    case left, right
}

extension ListButtonDelegate where Self: UIButton {
    
    init(title: String, contentView: UIView, side: ListButtonSide) {
        self.init()
        
        //Title
        setTitleLabel(title: title)
        
        //Adding subview to superview plus constraints
        contentView.addSubview(self)
        addButtonConstraints(contentView: contentView, side: side)
        
        setButtonBorder(side: side)
    }
    
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
