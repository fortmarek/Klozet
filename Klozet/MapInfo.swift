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
        
        axis = .vertical
        alignment = .leading
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        rightAnchor.constraint(equalTo: mapStack.rightAnchor).isActive = true
        leftAnchor.constraint(equalTo: mapStack.leftAnchor).isActive = true
        
        setEtaImage()
        
        setEtaLabel(toiletCoordinate: toilet.coordinate)
    }
    
    fileprivate func setEtaLabel(toiletCoordinate: CLLocationCoordinate2D) {
        let etaLabel = UILabel()
        addArrangedSubview(etaLabel)
        
        etaLabel.alpha = 0
        
        getEta(toiletCoordinate, completion: {
            eta in
            etaLabel.text = eta
            
            //Start with label rotated upside down to then rotate it to the right angle
            etaLabel.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI / 2), 1, 0, 0)
            etaLabel.sizeToFit()
            
            self.layoutIfNeeded()
            
            self.etaAppear(etaLabel: etaLabel)
        })
        
    }
    
    fileprivate func setEtaImage() {
        etaImage = UIImageView(image: UIImage(named: "WalkingDetail"))
        addArrangedSubview(etaImage)
        etaImage.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        etaImage.heightAnchor.constraint(equalToConstant: 36).isActive = true
        etaImage.widthAnchor.constraint(equalToConstant: 36).isActive = true
        etaImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        
        
        
    }
    
    fileprivate func etaAppear(etaLabel: UILabel) {
        
        etaLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 58 - (etaLabel.frame.size.width / 2)).isActive = true
        print(etaLabel.frame)

        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions(), animations: {
            
            self.etaImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            print(etaLabel.frame.size.height)
            //Rotation - 3D animation
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / 500
            //0, 0, 0, 0 because we want default value (we start this animation with already rotated title)
            etaLabel.layer.transform = CATransform3DConcat(perspective, CATransform3DMakeRotation(0, 0, 0, 0))
            
            //Opacity
            etaLabel.alpha = 1
            
            //Needed to animate imageEdgeInset
            self.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
