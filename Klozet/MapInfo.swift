//
//  MapInfo.swift
//  Klozet
//
//  Created by Marek Fořt on 29/09/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapInfoView: UIStackView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(detailStackView: UIStackView, toilet: Toilet) {
        self.init()
        
        detailStackView.addArrangedSubview(self)
        
        axis = .vertical
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        rightAnchor.constraint(equalTo: detailStackView.rightAnchor).isActive = true
        leftAnchor.constraint(equalTo: detailStackView.leftAnchor).isActive = true
        
        _ = MapInfoText(mapStack: self, toilet: toilet)
        
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MapInfoText: UIStackView, DirectionsDelegate, UserLocation {
    
    var etaImage = UIImageView()
    
    var locationDelegate: UserLocation?
    
    var locationManager = CLLocationManager()
    
    //UserLocation
    var mapView: MKMapView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(mapStack: UIStackView, toilet: Toilet) {
        self.init()
        
        locationManager.startUpdatingLocation()
        
        locationDelegate = self
        
        mapStack.addArrangedSubview(self)
        
        axis = .horizontal
        alignment = .center
        distribution = .fill
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        rightAnchor.constraint(equalTo: mapStack.rightAnchor).isActive = true
        leftAnchor.constraint(equalTo: mapStack.leftAnchor).isActive = true
        
        let etaStack = UIStackView()
        etaStack.axis = .vertical
        etaStack.alignment = .center
        etaStack.spacing = 3
        addArrangedSubview(etaStack)
    
        setEtaImage(etaStack: etaStack)
        
        setEtaLabel(etaStack: etaStack, toiletCoordinate: toilet.coordinate)
        
        setAddressInfo(mainAddress: toilet.title, subAddress: toilet.subtitle)
    }
    
    fileprivate func setEtaLabel(etaStack: UIStackView, toiletCoordinate: CLLocationCoordinate2D) {
        let etaLabel = UILabel()
        
        etaLabel.alpha = 0
        etaLabel.textColor = Colors.pumpkinColor
        
        getEta(toiletCoordinate, completion: {
            eta in
            etaLabel.text = eta
            
            self.etaPrepare(etaStack: etaStack, etaLabel: etaLabel)
            self.etaAppear(etaStack: etaStack, etaLabel: etaLabel)
        })
        
    }
    
    fileprivate func setEtaImage(etaStack: UIStackView) {
        etaImage = UIImageView(image: UIImage(named: "WalkingDetail"))
        etaStack.addArrangedSubview(etaImage)
        etaImage.heightAnchor.constraint(equalToConstant: 36).isActive = true
        etaImage.widthAnchor.constraint(equalToConstant: 36).isActive = true
        etaImage.leftAnchor.constraint(equalTo: etaStack.leftAnchor, constant: 40).isActive = true
    }
    
    fileprivate func etaPrepare(etaStack: UIStackView, etaLabel: UILabel) {
        etaLabel.sizeToFit()
        
        etaLabel.frame.origin.y = self.etaImage.frame.size.height
        etaLabel.frame.origin.x = self.etaImage.frame.origin.x - (etaLabel.frame.size.width - self.etaImage.frame.size.width) / 2
        
        self.layoutIfNeeded()
        
        //Start with label rotated upside down to then rotate it to the right angle
        etaLabel.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI / 2), 1, 0, 0)
        
        etaStack.addArrangedSubview(etaLabel)

    }
    
    fileprivate func etaAppear(etaStack: UIStackView, etaLabel: UILabel) {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions(), animations: {
            //Rotation - 3D animation
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / 500
            //0, 0, 0, 0 because we want default value (we start this animation with already rotated title)
            etaLabel.layer.transform = CATransform3DConcat(perspective, CATransform3DMakeRotation(0, 0, 0, 0))
            
            //Opacity
            etaLabel.alpha = 1
            
            //Needed to animate imageEdgeInset
            etaStack.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    
    fileprivate func setAddressInfo(mainAddress: String?, subAddress: String?) {
        
        guard
            let mainAddress = mainAddress,
            let subAddress = subAddress
        else {return}
        
        let addressStack = UIStackView()
        addressStack.axis = .vertical
        addressStack.alignment = .leading
        addArrangedSubview(addressStack)
        addressStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        let mainAddressLabel = UILabel()
        mainAddressLabel.text = mainAddress
        addressStack.addArrangedSubview(mainAddressLabel)
        
        let subAddressLabel = UILabel()
        subAddressLabel.text = subAddress
        addressStack.addArrangedSubview(subAddressLabel)
        
        
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
