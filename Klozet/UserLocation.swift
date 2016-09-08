//
//  UserLocation.swift
//  Klozet
//
//  Created by Marek Fořt on 08/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import MapKit

protocol UserLocation: CLLocationManagerDelegate, MKMapViewDelegate {
    var locationManager: CLLocationManager { get }
    var mapView: MKMapView! { get }
}

extension UserLocation {
    func getUserLocation() -> CLLocation? {
        guard let location = locationManager.location else {return nil}
        return location
    }
    
    func startTrackingLocation() {
        //Tracking user's location init
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
    }
}

extension ViewController: CLLocationManagerDelegate {
    //Heading
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //Ensure heading's value is positive
        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        
        //Orientate map according to where iPhone's facing
        let mapCamera = mapView.camera
        mapCamera.heading = heading
        mapView.setCamera(mapCamera, animated: false)
    }
    
    //The initial positon and region of the map
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Locations.last = current location
        guard let location = locations.last else {return}
        
        //Position
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        //Region
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //Show region in mapView
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    //Location manager fail
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: \(error)")
    }
}


