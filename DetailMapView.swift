//
//  DetailMapView.swift
//  Klozet
//
//  Created by Marek Fořt on 03/10/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import MapKit




class DetailMapStack: UIStackView, MKMapViewDelegate {
    
    convenience init(detailStackView: UIStackView, toilet: Toilet, presentDelegate: PresentDelegate) {
        self.init()
        
        axis = .vertical
        
        detailStackView.addArrangedSubview(self)
        
        
        let mapView = DetailMapView(mapDelegate: self, toilet: toilet)
        
        detailStackView.layoutIfNeeded()

        
        let overlayButton = MapOverlayButton(frame: mapView.frame, toilet: toilet)
        overlayButton.presentDelegate = presentDelegate
        addSubview(overlayButton)
        bringSubview(toFront: overlayButton)
    
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //Checking that annotation really is a Toilet class
        guard let toiletAnnotation = annotation as? Toilet else {return nil}
        
        let toiletAnnotationView = ToiletAnnotationView(annotation: toiletAnnotation, reuseIdentifier: "toiletDetailAnnotation")
        
        //Center pin image
        toiletAnnotationView.centerOffset = CGPoint(x: 0, y: -toiletAnnotationView.frame.height/2)
        
        return toiletAnnotationView
    }
    
    
}

class DetailMapView: MKMapView {
    
    convenience init(mapDelegate: DetailMapStack, toilet: Toilet) {
        self.init()
        
        mapDelegate.addArrangedSubview(self)
        
        //delegate = mapDelegate
        
        //Map position and span
        
        //Region
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        //Move map so the pin appears a little bit under the center
        let latitude = toilet.coordinate.latitude + span.latitudeDelta * 0.3
        
        let center = CLLocationCoordinate2DMake(latitude, toilet.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: span)
        
        //Show region in mapView
        setRegion(region, animated: true)
        
        delegate = mapDelegate
        
        DispatchQueue.main.async(execute: {
            self.addAnnotation(toilet)
        })
        
    }
    
    
}

class MapOverlayButton: UIButton, ShowMap {
    
    var toilet: Toilet?
    
    var presentDelegate: PresentDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    convenience init(frame: CGRect, toilet: Toilet) {
        self.init(frame: frame)

        self.toilet = toilet
        
        createGradientLayer()
        
        addTarget(self, action: #selector(showMapAction), for: .touchUpInside)
    }
    
    private func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.init(white: 1, alpha: 0.9).cgColor, UIColor.init(white: 1, alpha: 0).cgColor]
        gradientLayer.locations = [0.0, 0.2, 0.4]
        
        layer.addSublayer(gradientLayer)
    }
    
    func showMapAction(sender: UIButton) {
        showMapView()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol ShowMap {
    var toilet: Toilet? { get }
    var presentDelegate: PresentDelegate? { get }
}

extension ShowMap where Self: UIButton {
    func showMapView() {
        guard
            let toilet = self.toilet,
            let singleToiletVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "singleToiletVC") as? SingleToiletViewController
            else {return}
        
        singleToiletVC.toilet = toilet
        
        presentDelegate?.showViewController(viewController: singleToiletVC)
    }
}



