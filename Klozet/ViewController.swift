//
//  ViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 13/08/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    //UI elements
    @IBOutlet weak var mapView: MKMapView!
    let currentLocationButton = UIButton()
    let filterButton = UIButton()
    let filterImage = UIImageView()
    let cancelImage = UIImageView()
    
    //Default button distance from the edges of the screen
    let cornerConstant = CGFloat(20)
    //Default width and height of buttons
    let sizeConstant = CGFloat(60)
    
    var toilets = [Toilet]()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let dataController = DataController()
        
        dataController.getToilets({
            toilets in
            self.toilets = toilets
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotations(toilets)
            })

        })
        
        createButtons()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    // MARK: Location manager methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: \(error)")
    }
    
    
    // MARK: Dropping toilet pins
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let toiletAnnotation = annotation as? Toilet else {return nil}
        
        var annotationView = MKAnnotationView()
        if let reusableAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("toiletAnnotation") {
            annotationView = reusableAnnotationView
            annotationView.canShowCallout = true
        }
        
        else {
            annotationView = MKAnnotationView(annotation: toiletAnnotation, reuseIdentifier: "toiletAnnotation")
        }
        
        annotationView.annotation = toiletAnnotation
        annotationView.image = UIImage(named: "Pin")
        
        return annotationView
    }
    
    func currentLocationButtonTapped(sender: UIButton) {
        locationManager.startUpdatingLocation()
    }

    
    
}

