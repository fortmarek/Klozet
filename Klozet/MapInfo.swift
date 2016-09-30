//
//  MapInfo.swift
//  Klozet
//
//  Created by Marek Fořt on 29/09/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class MapInfoView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(detailStackView: UIStackView) {
        self.init()
        detailStackView.addArrangedSubview(self)
        
        axis = .vertical
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        rightAnchor.constraint(equalTo: detailStackView.rightAnchor).isActive = true
        leftAnchor.constraint(equalTo: detailStackView.leftAnchor).isActive = true
        
        _ = MapInfoText(mapStack: self)
        
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MapInfoText: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(mapStack: UIStackView) {
        self.init()
        
        mapStack.addArrangedSubview(self)
        
        axis = .vertical
        alignment = .leading
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        rightAnchor.constraint(equalTo: mapStack.rightAnchor).isActive = true
        leftAnchor.constraint(equalTo: mapStack.leftAnchor).isActive = true
        
        setEta()
    }
    
    fileprivate func setEta() {
        let etaImage = UIImageView(image: UIImage(named: "WalkingDetail"))
        addArrangedSubview(etaImage)
        etaImage.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        etaImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        etaImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        etaImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        
        
        let label = UILabel()
        addArrangedSubview(label)
        label.text = "KKKKKK"
        label.sizeToFit()
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 65 - (label.frame.size.width / 2)).isActive = true
        
        
        

        
       
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
