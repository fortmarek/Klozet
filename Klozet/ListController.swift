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
    
    convenience init(view: UIView, toiletsDelegate: ListToiletsDelegate) {
        self.init(frame: CGRect())
        
        //BlurEffect
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50)
        view.addSubview(blurredEffectView)
        
        
        
        
        //ListController
        let contentView = blurredEffectView.contentView
        let listOpenButton = ListOpenButton(title: "Otevřeno".localized, contentView: contentView, side: .left, toiletsDelegate: toiletsDelegate)
        let listPriceButton = ListPriceButton(title: "Zdarma".localized, contentView: contentView, side: .right, toiletsDelegate: toiletsDelegate)
        
        let border = setListControllerBorder(listOpenButton: listOpenButton, listPriceButton: listPriceButton)
        blurredEffectView.contentView.addSubview(border)
        
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
        
        
        /*
        let path = UIBezierPath(roundedRect: rounderRect, byRoundingCorners: cornersToRound, cornerRadii: CGSize(width: 5, height: 5))
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = 1
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = Colors.pumpkinColor.cgColor
        
        layer.addSublayer(borderLayer)
 
 */
    }
    
}





