//
//  AddMapViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 1/11/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit
import MapKit

class AddMapToiletViewController: UIViewController, MKMapViewDelegate, UserLocation {
    
    var toilet: Toilet?
    let mapView: MKMapView = MKMapView()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .mainOrange
        
        startTrackingLocation()
        
        mapView.frame = view.frame
        mapView.delegate = self
        view.addSubview(mapView)
        
        let toiletPinImageView = UIImageView()
        toiletPinImageView.image = UIImage(asset: Asset.pin)
        view.addSubview(toiletPinImageView)
        toiletPinImageView.centerInView(view)
        
        centerMap()
        
    }
    
    func centerMap() {
        guard let toilet = self.toilet else {return}
        
        let center = CLLocationCoordinate2DMake(toilet.coordinate.latitude, toilet.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        //Show region in mapView
        mapView.setRegion(region, animated: true)
    }

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard mapView.centerCoordinate.latitude != 0 else {return}
        toilet?.coordinate = mapView.centerCoordinate
    }

    
}
