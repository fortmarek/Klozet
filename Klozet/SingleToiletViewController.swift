//
//  SingleToiletViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 03/10/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SingleToiletViewController: UIViewController, MKMapViewDelegate, UserLocation {
    
    var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var toilet: Toilet?
    
    override func viewDidLoad() {
        //Mapview 
        mapView = MKMapView()
        mapView.frame = view.frame
        mapView.delegate = self
        
        view.addSubview(mapView)
        
        guard let toilet = self.toilet else {return}
        DispatchQueue.main.async(execute: {
            self.mapView.addAnnotation(toilet)
        })
        
        centerMap()
        
        startTrackingLocation()
        
        let rightBarButtonItem = SingleDirectionsButton(annotation: toilet)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        navigationController?.navigationBar.tintColor = Colors.pumpkinColor
    }
    
    private func centerMap() {
        guard
            let toilet = self.toilet,
            let userLocation = getUserLocation()
        else {return}
        
        
        let latitude = (toilet.coordinate.latitude + userLocation.coordinate.latitude) / 2
        let longitude = (toilet.coordinate.longitude + userLocation.coordinate.longitude) / 2
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        
        let latitudeDelta = abs(toilet.coordinate.latitude - userLocation.coordinate.latitude) * 1.4
        let longitudeDelta = abs(toilet.coordinate.longitude - userLocation.coordinate.longitude) * 1.4
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        //Show region in mapView
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Checking that annotation really is a Toilet class
        guard let toiletAnnotation = annotation as? Toilet else {return nil}
        
        let toiletAnnotationView = ToiltetAnnotationView(annotation: toiletAnnotation, reuseIdentifier: "singleToiletAnnotation")
        
        //Center pin image
        toiletAnnotationView.centerOffset = CGPoint(x: 0, y: -toiletAnnotationView.frame.height/2)
        
        return toiletAnnotationView
    }
}


class SingleDirectionsButton: UIBarButtonItem, MapsDirections {
    
    var annotation: Toilet
    
    init(annotation: Toilet) {
        self.annotation = annotation
        super.init()
        
        style = .plain
        title = "Navigovat".localized
        action = #selector(callDirectionsMapsFunc)
        target = self
        
    }
    
    func callDirectionsMapsFunc() {
        getDirections()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}


