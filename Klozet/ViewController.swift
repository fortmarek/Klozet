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
        
        let leftButton = setLeftCalloutView()
        annotationView.leftCalloutAccessoryView = leftButton
        
        //Add target
        leftButton.addTarget(self, action: #selector(getDirectionsFromAnnotation), forControlEvents: .TouchUpInside)
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        guard let toiletAnnotation = view.annotation as? Toilet else {return}
        
        view.tag = 1
        getEta(toiletAnnotation.coordinate, annotationView: view)
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        view.tag = 0
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
    
    func getDirectionsFromAnnotation(sender: UIButton) {
    
        guard
            let toiletView = view.viewWithTag(1) as? MKAnnotationView,
            let toiletAnnotation = toiletView.annotation as? Toilet
        else {return}
        
        getDirections(toiletAnnotation.coordinate)
    }
    
    
    func requestDirections(destination: CLLocationCoordinate2D) -> MKDirections {
        
        let request = MKDirectionsRequest()
        
        guard let userLocation = locationManager.location else {return MKDirections()}
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.transportType = .Walking
        
        let directions = MKDirections(request: request)
        
        return directions
    }
    
    func getDirections(destination: CLLocationCoordinate2D) {
        // TODO: Pass maps the adress
        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        destinationMapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        
    }
    
    
    
    
}

