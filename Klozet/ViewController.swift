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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    //UI elements
    @IBOutlet weak var mapView: MKMapView!
    let currentLocationButton = UIButton()
    let filterButton = UIButton()
    let priceButton = UIButton()
    let timeButton = UIButton()
    let filterImage = UIImageView()
    let cancelImage = UIImageView()
    
    var priceButtonConstraint = NSLayoutConstraint()
    var timeButtonConstraint = NSLayoutConstraint()

    
    //Default button distance from the edges of the screen
    let cornerConstant = CGFloat(20)
    //Default width and height of buttons
    let sizeConstant = CGFloat(55)
    
    var toilets = [Toilet]()
    let locationManager = CLLocationManager()
    
    var currentLocationHeadingSelected = false
    var isFilterSelected = false
    var dragRecognizer = UIPanGestureRecognizer()

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
        
        dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragMap))
        dragRecognizer.delegate = self
        mapView.addGestureRecognizer(dragRecognizer)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didDragMap() {
        if dragRecognizer.state == .Began {
            currentLocationButton.selected = false
            
            currentLocationHeadingSelected = false
            locationManager.stopUpdatingHeading()
        }
        
    }
    
    
    // MARK: Location manager methods
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
    
        let mapCamera = mapView.camera
        mapCamera.heading = heading
        
        mapView.setCamera(mapCamera, animated: false)
        
    }
    
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
        
        let rightButton = UIButton.init(type: .DetailDisclosure)
        annotationView.rightCalloutAccessoryView = rightButton
        
        let leftButton = UIButton.init(type: .Custom)
        
        leftButton.backgroundColor = UIColor.orangeColor()
        leftButton.setImage(UIImage(named: "Walking"), forState: .Normal)
        leftButton.setImage((UIImage(named: "Walking")), forState: .Highlighted)
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: UIColor.whiteColor()]
        let randNumber = Int(arc4random_uniform(100))
        leftButton.setAttributedTitle(NSAttributedString(string: "\(randNumber) min", attributes: attributes), forState: .Normal)
        leftButton.setAttributedTitle(NSAttributedString(string: "\(randNumber) min", attributes: attributes), forState: .Highlighted)
        leftButton.titleLabel?.sizeToFit()
        leftButton.frame = CGRect(x: 0, y: 0, width: 55, height: 50)
        //image width is 22
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16.5, bottom: 10, right: 0)
        leftButton.titleEdgeInsets = UIEdgeInsets(top: 30, left: -(leftButton.titleLabel!.frame.size.width) / 2 - (leftButton.frame.size.width - leftButton.titleLabel!.frame.size.width) / 2 + 5, bottom: 0, right: 0)
        print(leftButton.titleLabel?.frame)
        print((leftButton.frame.size.width - leftButton.titleLabel!.frame.size.width) / 2)
        
        
        
        annotationView.leftCalloutAccessoryView = leftButton
        
        return annotationView
    }
    
    func currentLocationButtonTapped(sender: UIButton) {
        locationManager.startUpdatingLocation()
        determineCurrentLocationButtonImage()
    }
    
    private func determineCurrentLocationButtonImage() {
        if currentLocationHeadingSelected {
            currentLocationHeadingSelected = false
            currentLocationButton.selected = false
            locationManager.stopUpdatingHeading()
            setImageForSelectedHighlighted(currentLocationButton, image: "CurrentLocationSelected")
        }
        else if currentLocationButton.selected {
            currentLocationHeadingSelected = true
            setImageForSelectedHighlighted(currentLocationButton, image: "CurrentLocationHeading")
            locationManager.startUpdatingHeading()
        }
        else {
            setImageForSelectedHighlighted(currentLocationButton, image: "CurrentLocationSelected")
            currentLocationButton.selected = true
        }
    }
    
    private func setImageForSelectedHighlighted(button: UIButton, image: String) {
        button.setImage(UIImage(named: image), forState: .Selected)
        button.setImage(UIImage(named: image), forState: [.Selected, .Highlighted])
    }
    
    func priceButtonTapped(sender: UIButton) {
        priceButton.selected = !(priceButton.selected)
        
        let toiletsForFree = toilets.filter({$0.price != "Zdarma"})
        
        if priceButton.selected {
            mapView.removeAnnotations(toiletsForFree)
        }
        else {
            mapView.addAnnotations(toiletsForFree)
        }
        
        
    }
    
    func timeButtonTapped(sender: UIButton) {
        timeButton.selected = !(timeButton.selected)
    }
    
    

    
    
}

