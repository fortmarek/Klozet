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
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
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
        
        cancelButton.alpha = 0.0
        view.bringSubviewToFront(cancelButton)
        view.bringSubviewToFront(currentLocationButton)
        view.bringSubviewToFront(filterButton)
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
    
    @IBAction func currentLocationButtonTapped(sender: UIButton) {
        locationManager.startUpdatingLocation()
    }

    @IBAction func filterButtonTapped(sender: UIButton) {
        rotate()
        fadeOut()
        
    }
    
    func rotate() {
        UIView.animateKeyframesWithDuration(1, delay: 0, options: [.CalculationModePaced, UIViewKeyframeAnimationOptions(animationOptions: .CurveEaseOut)], animations: {
            
            let fullRotation = CGFloat(M_PI * 2)
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/3, animations: {
                self.filterButton.transform = CGAffineTransformMakeRotation(1 / 3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
                self.filterButton.transform = CGAffineTransformMakeRotation(2 / 3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                self.filterButton.transform = CGAffineTransformMakeRotation(3 / 3 * fullRotation)
            })
            
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animateWithDuration(1, animations: {
            self.filterButton.alpha = 0.0
            }, completion: nil)
        
        UIView.animateWithDuration(1, animations: {
            self.cancelButton.alpha = 1.0
            }, completion: nil)
    }
    
}

extension UIViewKeyframeAnimationOptions {
    
    init(animationOptions: UIViewAnimationOptions) {
        rawValue = animationOptions.rawValue
    }
    
}

