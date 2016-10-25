//
//  ListController.swift
//  Klozet
//
//  Created by Marek Fořt on 17/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

protocol ListControllerDelegate {
    func changeMiddleBorderColor()
}

class ListControllerContainer: UIView, ListControllerDelegate {
    
    var middleBorder = UIView()
    var toiletsDelegate: ListToiletsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(view: UIView, toiletsDelegate: ListToiletsDelegate) {
        self.init(frame: CGRect())
        
        self.toiletsDelegate = toiletsDelegate
        
        //BlurEffect
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        view.addSubview(blurredEffectView)
        
        
        //ListController
        let contentView = blurredEffectView.contentView
        let listOpenButton = ListOpenButton(title: "Open".localized, contentView: contentView, side: .left, toiletsDelegate: toiletsDelegate, listControllerDelegate: self)
        let listPriceButton = ListPriceButton(title: "Free".localized, contentView: contentView, side: .right, toiletsDelegate: toiletsDelegate, listControllerDelegate: self)
        
        let border = setListControllerBorder(listOpenButton: listOpenButton, listPriceButton: listPriceButton)
        blurredEffectView.contentView.addSubview(border)
        
        setMiddleBorder(listPriceButton: listPriceButton, contentView: blurredEffectView.contentView)
        
        blurredEffectView.contentView.bringSubview(toFront: listOpenButton)
        blurredEffectView.contentView.bringSubview(toFront: listPriceButton)
        
        //Otherwise it is left under tableView
        view.bringSubview(toFront: blurredEffectView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setListControllerBorder(listOpenButton: ListOpenButton, listPriceButton: ListPriceButton) -> UIView {
        
        let border = UIView()
        border.backgroundColor = UIColor.clear
        
        let width = 2 * listPriceButton.frame.width + 1
        
        border.frame = CGRect(x: listOpenButton.frame.origin.x, y: listOpenButton.frame.origin.y, width: width, height: 30)
        border.layer.cornerRadius = 5
        border.layer.borderColor = Colors.pumpkinColor.cgColor
        border.layer.borderWidth = 1
        
        return border
    }
    
    fileprivate func setMiddleBorder(listPriceButton: ListPriceButton, contentView: UIView) {
        middleBorder.frame = CGRect(x: listPriceButton.frame.origin.x - 1 , y: listPriceButton.frame.origin.y, width: 1, height: 30)
        
        //Default backgroundColor
        middleBorder.backgroundColor = Colors.pumpkinColor
        
        contentView.addSubview(middleBorder)
    }
    
    func changeMiddleBorderColor() {
        guard let toiletsDelegate = self.toiletsDelegate else {return}
        if toiletsDelegate.isFilterOpenSelected && toiletsDelegate.isFilterPriceSelected {
            middleBorder.backgroundColor = UIColor.clear
        }
        else {
            middleBorder.backgroundColor = Colors.pumpkinColor
        }
    }
    
}





