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
        let _ = ListOpenButton(title: "Otevřeno".localized, contentView: contentView, side: .left, toiletsDelegate: toiletsDelegate)
        let _ = ListPriceButton(title: "Zdarma".localized, contentView: contentView, side: .right, toiletsDelegate: toiletsDelegate)
        
        //Otherwise it is left under tableView
        view.bringSubview(toFront: blurredEffectView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





