//
//  Separable.swift
//  Klozet
//
//  Created by Marek Fořt on 1/5/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit


protocol Separable {
    var separatorView: UIView {get}
}

extension Separable where Self: UIView {
    
    func addSeparator() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        addSubview(separatorView)
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.pinToViewHorizontally(self)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

