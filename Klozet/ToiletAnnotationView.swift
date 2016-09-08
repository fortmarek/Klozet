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

class ToiltetAnnotationView: MKAnnotationView, DirectionsDelegate {
    
    var locationDelegate: UserLocation?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.annotation = annotation
        self.canShowCallout = true
        self.image = UIImage(named: "Pin")
        
        setCalloutAccessoryView()
    }
    private func setCalloutAccessoryView() {
        
        //Detailed toilet info button
        let rightButton = UIButton.init(type: .DetailDisclosure)
        rightCalloutAccessoryView = rightButton
        
        guard let toiletAnnotation = annotation as? Toilet else {return}
        
        //Left button with ETA
        leftCalloutAccessoryView = DirectionButton(annotation: toiletAnnotation)
        
        //Add target to get directions
        //leftButton.addTarget(self, action: #selector(getDirectionsFromAnnotation), forControlEvents: .TouchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class DirectionButton: UIButton, DirectionsDelegate {
    
    var annotation: Toilet
    
    var locationDelegate: UserLocation?
    
    init(annotation: Toilet) {
        
        //Annotation for directions
        self.annotation = annotation
        
        super.init(frame: CGRect(x: 0, y: 0, width: 55, height: 50))
        
        self.addTarget(self, action: #selector(getDirections), forControlEvents: .TouchUpInside)
        
        //BackgroundColor
        backgroundColor = pumpkinColor
        
        //Image
        setImage(UIImage(named: "Walking"), forState: .Normal)
        setImage((UIImage(named: "Walking")), forState: .Highlighted)
        
        //Center image in view, 22 is for image width
        let leftImageInset = (frame.size.width - 22) / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: leftImageInset, bottom: 0, right: leftImageInset)
        
        //Title inset
        titleEdgeInsets = UIEdgeInsets(top: 30, left: -22.5, bottom: 0, right: 0)
        titleLabel?.textAlignment = .Center
    }
    
    func setEtaTitle() {

        getEta(annotation.coordinate, completion: {eta in
            //Title with attributes
            self.titleLabel?.alpha = 0
            let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.setAttributedTitle(NSAttributedString(string: eta, attributes: attributes), forState: .Normal)
            self.setAttributedTitle(NSAttributedString(string: eta, attributes: attributes), forState: .Highlighted)
            
            //Animating ETA title appearance
            self.animateETA()
        })
    }
    
    //Opening Apple maps with directions to the toilet
    func getDirections(sender: DirectionButton) {
        let destination = sender.annotation.coordinate
        
        // TODO: Pass maps the adress
        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        destinationMapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    private func animateETA() {
        
        //Start with label rotated upside down to then rotate it to the right angle
        titleLabel?.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI / 2), 1, 0, 0)
        titleLabel?.sizeToFit()
        
        //layoutIfNeeded after sizeToFit() so I don't animate the position of title only rotation
        self.superview!.layoutIfNeeded()
        
        //Image position after adding title
        //Center image in view, 22 is for image width
        let leftImageInset = (frame.size.width - 22) / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: leftImageInset, bottom: 10, right: leftImageInset)
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: {
            //Rotation - 3D animation
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / 500
            //0, 0, 0, 0 because we want default value (we start this animation with already rotated title)
            self.titleLabel?.layer.transform = CATransform3DConcat(perspective, CATransform3DMakeRotation(0, 0, 0, 0))
            
            //Opacity
            self.titleLabel?.alpha = 1
            
            //Needed to animate imageEdgeInset
            self.superview!.layoutIfNeeded()
            
            }, completion: nil)
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

