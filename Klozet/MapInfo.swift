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

class MapInfoView: UIStackView, UserLocation {
    
    let locationManager = CLLocationManager()
    
    //UserLocation
    var mapView: MKMapView = MKMapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(detailStackView: UIStackView, toilet: Toilet, showDelegate: ShowDelegate) {
        self.init()
        
        //Location
        locationManager.startUpdatingLocation()
        
        
        detailStackView.addArrangedSubview(self)
        
        axis = .vertical
        
        //heightAnchor.constraint(equalToConstant: 160).isActive = true
        rightAnchor.constraint(equalTo: detailStackView.rightAnchor).isActive = true
        leftAnchor.constraint(equalTo: detailStackView.leftAnchor).isActive = true
        
        let mapInfo = MapInfoText(mapStack: self, toilet: toilet)
        
        detailStackView.layoutIfNeeded()
        
        let showMapButton = ShowMapButton(frame: mapInfo.frame, toilet: toilet)
        showMapButton.showDelegate = showDelegate
        addSubview(showMapButton)
        bringSubview(toFront: showMapButton)
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MapInfoText: UIStackView, DirectionsDelegate {
    
    var etaImage = UIImageView()
    
    var locationDelegate: UserLocation?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(mapStack: MapInfoView, toilet: Toilet) {
        self.init()
        
        locationDelegate = mapStack
        
        setStack(mapStack: mapStack)
        
        setEtaStack(toilet: toilet)
        
        setAddressInfo(mainAddress: toilet.title, subAddress: toilet.subtitle)
    }
    
    fileprivate func setStack(mapStack: UIStackView) {
        
        
        //Add self to mapStack
        mapStack.addArrangedSubview(self)
        
        //MapInfoText stack properties
        axis = .horizontal
        alignment = .center
        distribution = .fill
        
        //Anchors
        //heightAnchor.constraint(equalToConstant: 90).isActive = true
        rightAnchor.constraint(equalTo: mapStack.rightAnchor).isActive = true
        leftAnchor.constraint(equalTo: mapStack.leftAnchor).isActive = true
    }
    
    fileprivate func setEtaStack(toilet: Toilet) {
        
        //EtaStack init
        let etaStack = UIStackView()
        etaStack.axis = .vertical
        etaStack.alignment = .center
        etaStack.spacing = 3
        addArrangedSubview(etaStack)
        
        //Add walking image
        setEtaImage(etaStack: etaStack)
        
        //Add eta under walking image
        setEtaLabel(etaStack: etaStack, toiletCoordinate: toilet.coordinate)
    }
    
    fileprivate func setEtaLabel(etaStack: UIStackView, toiletCoordinate: CLLocationCoordinate2D) {
        
        //etaLabel init
        let etaLabel = UILabel()
        etaLabel.alpha = 0
        etaLabel.textColor = .mainOrange
        etaLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        
        //Get eta string for etaLabel
        getEta(toiletCoordinate, completion: { eta in
            etaLabel.text = eta
            
            //Prepare eta for animation
            self.etaPrepare(etaStack: etaStack, etaLabel: etaLabel)
            //Animate eta label appearance
            self.etaAppear(etaStack: etaStack, etaLabel: etaLabel)
        })
        
    }
    
    fileprivate func setEtaImage(etaStack: UIStackView) {
        etaImage = UIImageView(image: UIImage(asset: Asset.walkingDetail))
        etaStack.addArrangedSubview(etaImage)
//        etaImage.heightAnchor.constraint(equalToConstant: 36).isActive = true
//        etaImage.widthAnchor.constraint(equalToConstant: 36).isActive = true
        etaImage.leftAnchor.constraint(equalTo: etaStack.leftAnchor, constant: 40).isActive = true
    }
    
    fileprivate func etaPrepare(etaStack: UIStackView, etaLabel: UILabel) {
        etaStack.addArrangedSubview(etaLabel)
        etaLabel.sizeToFit()

        //Have to set position for the CATransform to properly work
        etaLabel.frame.origin.y = self.etaImage.frame.size.height
        etaLabel.frame.origin.x = self.etaImage.frame.origin.x - (etaLabel.frame.size.width - self.etaImage.frame.size.width) / 2
        
        
        //Start with label rotated upside down to then rotate it to the right angle
        etaLabel.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 2), 1, 0, 0)

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
            
            //Animate layout changes
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
        addressStack.spacing = 3
        addArrangedSubview(addressStack)
        addressStack.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        addressStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        let mainAddressLabel = UILabel()
        mainAddressLabel.text = mainAddress
        mainAddressLabel.lineBreakMode = .byWordWrapping
        mainAddressLabel.numberOfLines = 0
        mainAddressLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        addressStack.addArrangedSubview(mainAddressLabel)
        
        let subAddressLabel = UILabel()
        subAddressLabel.text = subAddress
        subAddressLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subAddressLabel.textColor = UIColor.gray
        subAddressLabel.textAlignment = .left
        subAddressLabel.lineBreakMode = .byWordWrapping
        subAddressLabel.numberOfLines = 0
        subAddressLabel.sizeToFit()
        if subAddress == "" {
            subAddressLabel.text = "K"
            subAddressLabel.alpha = 0
        }
        addressStack.addArrangedSubview(subAddressLabel)
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShowMapButton: UIButton, ShowMap {
    
    var toilet: Toilet?
    var showDelegate: ShowDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(frame: CGRect, toilet: Toilet) {
        self.init(frame: frame)
        
        self.toilet = toilet
        
        addTarget(self, action: #selector(showMapAction), for: .touchUpInside)
    }
    
    @objc func showMapAction(sender: UIButton) {
        showMapView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
