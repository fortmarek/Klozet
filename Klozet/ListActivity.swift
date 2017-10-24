//
//  ListActivity.swift
//  Klozet
//
//  Created by Marek Fořt on 21/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class ActivityView: UIView {
    
    var activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(view: UIView) {
        self.init()
        
        view.layoutIfNeeded()
        
        isHidden = false
        //- 50 for listController at the bottom
        frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        
        backgroundColor = UIColor.white
        view.addSubview(self)
        view.bringSubview(toFront: self)
        
        initActivityStack(view: self)
        
    }
    
    
    fileprivate func initActivityStack(view: UIView) {
        
        let activityStack = UIStackView()
        view.addSubview(activityStack)
        
        setStackViewProperties(activityStack: activityStack)
        
        //Activity stack position
        activityStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //ActivityIndicator properties
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.startAnimating()
        
        
        //ActivityLabel
        let activityLabel = UILabel()
        activityLabel.text = "...loading".localized
        activityLabel.textColor = UIColor.gray
        
        activityStack.addArrangedSubview(activityIndicator)
        activityStack.addArrangedSubview(activityLabel)
        
        
    }
    
    fileprivate func setStackViewProperties(activityStack: UIStackView) {
        activityStack.axis = .vertical
        activityStack.spacing = 13
        activityStack.alignment = .center
        activityStack.translatesAutoresizingMaskIntoConstraints = false
        activityStack.backgroundColor = .mainBlue 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
