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
    
    var mapView: MKMapView = MKMapView()
    
    var locationManager = CLLocationManager()
    
    var toilet: Toilet?
    
    override func viewDidLoad() {
        
        guard let toilet = self.toilet else {return}
        
        setMapView(toilet: toilet)
        startTrackingLocation()
        
        centerMap()
        
    }
    
    private func setMapView(toilet: Toilet) {
        
        mapView.frame = view.frame
        mapView.delegate = self
        view.addSubview(mapView)
        
        DispatchQueue.main.async(execute: {
            self.mapView.addAnnotation(toilet)
        })
        
        //Center map to see both toilet and current location
        centerMap()
    }
    
    func centerMap() {
        
        guard
            let toilet = self.toilet,
            let userLocation = getUserLocation()
        else {return}
        
        //Center map between user location and toilet
        let latitude = (toilet.coordinate.latitude + userLocation.coordinate.latitude) / 2
        let longitude = (toilet.coordinate.longitude + userLocation.coordinate.longitude) / 2
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        
        //Span = distance between locations multiplied by 1.4 so  there is some space on the edges of annotations
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
        
        let toiletAnnotationView = ToiletView(annotation: toiletAnnotation, reuseIdentifier: "singleToilet")
        //Center pin image
        toiletAnnotationView.centerOffset = CGPoint(x: 0, y: -toiletAnnotationView.frame.height/2)
        
        return toiletAnnotationView
    }
}





