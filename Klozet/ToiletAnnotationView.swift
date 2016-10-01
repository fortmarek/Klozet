//
//  ToiletAnnotationView.swift
//  Klozet
//
//  Created by Marek Fořt on 07/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ToiltetAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.annotation = annotation
        self.canShowCallout = true
        self.image = UIImage(named: "Pin")
        
        setCalloutAccessoryView()
    }
    
    fileprivate func setCalloutAccessoryView() {
        
        //Detailed toilet info button
        let rightButton = UIButton.init(type: .detailDisclosure)
        rightCalloutAccessoryView = rightButton
        
        guard let toiletAnnotation = annotation as? Toilet else {return}
        
        //Left button with ETA
        leftCalloutAccessoryView = DirectionButton(annotation: toiletAnnotation)
        
        //Add target to get directions
        //leftButton.addTarget(self, action: #selector(getDirectionsFromAnnotation), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//DirectionButton
class DirectionButton: UIButton, DirectionsDelegate {
    
    var annotation: Toilet
    
    var locationDelegate: UserLocation?
    
    init(annotation: Toilet) {
        
        //Annotation for directions
        self.annotation = annotation
        
        super.init(frame: CGRect(x: 0, y: 0, width: 55, height: 50))
        
        self.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        
        //BackgroundColor
        backgroundColor = Colors.pumpkinColor
        
        //Image
        setImage(UIImage(named: "Walking"), for: UIControlState())
        setImage((UIImage(named: "Walking")), for: .highlighted)
        
        //Center image in view, 22 is for image width
        let leftImageInset = (frame.size.width - 22) / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: leftImageInset, bottom: 0, right: leftImageInset)
        
        //Title inset
        titleEdgeInsets = UIEdgeInsets(top: 30, left: -22.5, bottom: 0, right: 0)
        titleLabel?.textAlignment = .center
    }
    
    func setEtaTitle() {

        getEta(annotation.coordinate, completion: {eta in
            //Title with attributes
            self.titleLabel?.alpha = 0
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.white]
            self.setAttributedTitle(NSAttributedString(string: eta, attributes: attributes), for: UIControlState())
            self.setAttributedTitle(NSAttributedString(string: eta, attributes: attributes), for: .highlighted)
            
            //Animating ETA title appearance
            self.animateETA()
        })
    }
    
    //Animating appearance of ETA title
    fileprivate func animateETA() {
        
        //Start with label rotated upside down to then rotate it to the right angle
        titleLabel?.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI / 2), 1, 0, 0)
        titleLabel?.sizeToFit()
        
        guard let superview = self.superview else {return}
        
        //layoutIfNeeded after sizeToFit() so I don't animate the position of title only rotation
        superview.layoutIfNeeded()
        
        //Image position after adding title
        //Center image in view, 22 is for image width
        let leftImageInset = (frame.size.width - 22) / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: leftImageInset, bottom: 10, right: leftImageInset)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions(), animations: {
            //Rotation - 3D animation
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / 500
            //0, 0, 0, 0 because we want default value (we start this animation with already rotated title)
            self.layer.transform = CATransform3DConcat(perspective, CATransform3DMakeRotation(0, 0, 0, 0))
            
            //Opacity
            self.alpha = 1
            
            //Needed to animate imageEdgeInset
            superview.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    //Opening Apple maps with directions to the toilet
    func getDirections(_ sender: DirectionButton) {
        let destination = sender.annotation.coordinate
        
        // TODO: Pass maps the adress
        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        destinationMapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

