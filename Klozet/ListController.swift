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
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = CGRect(x: 0, y: view.frame.size.height - 60, width: view.frame.size.width, height: 60)
        view.addSubview(blurredEffectView)
        
        
        let listController = ListController(items: ["first", "second"])
        listController.tintColor = UIColor.orange
        listController.translatesAutoresizingMaskIntoConstraints = false
        
        blurredEffectView.contentView.addSubview(listController)
        
        blurredEffectView.contentView.addConstraint(NSLayoutConstraint(item: listController, attribute: .leading, relatedBy: .equal, toItem: blurredEffectView.contentView, attribute: .leading, multiplier: 1.0, constant: 40))
        blurredEffectView.contentView.addConstraint(NSLayoutConstraint(item: listController, attribute: .trailing, relatedBy: .equal, toItem: blurredEffectView.contentView, attribute: .trailing, multiplier: 1.0, constant: -40))
        blurredEffectView.contentView.addConstraint(NSLayoutConstraint(item: listController, attribute: .centerY, relatedBy: .equal, toItem: blurredEffectView.contentView, attribute: .centerY, multiplier: 1.0, constant: 0))
        blurredEffectView.contentView.addConstraint(NSLayoutConstraint(item: listController, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30))
        
        blurredEffectView.contentView.layoutIfNeeded()
        
        view.bringSubview(toFront: blurredEffectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}




class ListController: UISegmentedControl {
    
}


