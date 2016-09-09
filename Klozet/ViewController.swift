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


protocol AnnotationController {
    var toilets: Array<Toilet> { get set }
    var toiletsNotOpen: Array<Toilet> { get set }
    var mapView: MKMapView! { get }
}

protocol FilterController {
    var isFilterSelected: Bool { get }
    var cornerConstant: CGFloat { get }
    func addConstraint(view: UIView, attribute: NSLayoutAttribute, constant: CGFloat) ->  NSLayoutConstraint
}


class ViewController: UIViewController, UIGestureRecognizerDelegate, UserLocation, AnnotationController, FilterController {

    //UI elements
    @IBOutlet weak var mapView: MKMapView!
    
    //Buttons
    let currentLocationButton = UIButton()
    let filterButton = UIButton()
    let priceButton = FilterPriceButton()
    let timeButton = FilterOpenButton()
    let filterImage = UIImageView()
    let cancelImage = UIImageView()
    
    //Option buttons' constraints, used later for animation
    var priceButtonConstraint = NSLayoutConstraint()
    var timeButtonConstraint = NSLayoutConstraint()

    
    //Default button distance from the edges of the screen
    let cornerConstant = CGFloat(20)
    //Default width and height of buttons
    let sizeConstant = CGFloat(55)
    
    var toilets = [Toilet]()
    var toiletsNotOpen = [Toilet]()
    
    //button state for showing also the direction iPhone is facing (it's the third state => needed special var, can't do with just UIButton selected state)
    var currentLocationHeadingSelected = false
    var isFilterSelected = false
    
    //Used for recognizing if the map was moved by user, if it was then current location button should be no more selected
    var dragRecognizer = UIPanGestureRecognizer()
    
    var locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startTrackingLocation()
        locationManager.delegate = self
        mapView.delegate = self
        
        getToilets()
        
        createButtons()
        
        addDragRecognizer()
    }
    
    override func viewDidAppear(animated: Bool) {
        //TODO: Show custom view to first nicely ask the user, not just with default alert
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func getToilets() {
        //DataController for fetching toilets
        let dataController = DataController()
        
        dataController.getToilets({
            toilets in
            self.toilets = toilets
            //UI changes, main queue
            dispatch_async(dispatch_get_main_queue(), {
                //Placing toilets on the map
                self.mapView.addAnnotations(toilets)
            })
            
        })
    }
    
    
    
    //MARK: DragRecognizer
    
    private func addDragRecognizer() {
        //Start recognizing user interaction with map
        dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragMap))
        dragRecognizer.delegate = self
        mapView.addGestureRecognizer(dragRecognizer)
    }
    
    //Allow use of dragRecognizer
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //If map was dragged, map is not following user's current location - current location should not be selected
    func didDragMap() {
        //Recognizing start of the drag, it's also called only once per interaction
        if dragRecognizer.state == .Began {
            currentLocationButton.selected = false
            
            currentLocationHeadingSelected = false
            locationManager.stopUpdatingHeading()
        }
        
    }

    // MARK: Dropping toilet pins
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        //Checking that annotation really is a Toilet class
        guard let toiletAnnotation = annotation as? Toilet else {return nil}
        
        var annotationView = MKAnnotationView()
        
        //User reusableAnnotationView
        if let reusableAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("toiletAnnotation") {
            annotationView = reusableAnnotationView
        }
        
        //Init of reusableAnnotationView
        else {
            let toiletAnnotationView = ToiltetAnnotationView(annotation: toiletAnnotation, reuseIdentifier: "toiletAnnotation")
            
            //DirectionButton delegate = self => getting user location
            guard let directionButton = toiletAnnotationView.leftCalloutAccessoryView as? DirectionButton else {return toiletAnnotationView}
            directionButton.locationDelegate = self
            
            annotationView = toiletAnnotationView
        }

        return annotationView
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        guard
            let toiletAnnotationView = view as? ToiltetAnnotationView,
            let directionButton = toiletAnnotationView.leftCalloutAccessoryView as? DirectionButton
        else {return}
        
        directionButton.setEtaTitle()
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
        
        //Filter all toilets that are not for free
        let toiletsNotForFree = toilets.filter({$0.price != "Zdarma"})
        
        if priceButton.selected == false {
            mapView.removeAnnotations(toiletsNotForFree)
        }
        else {
            mapView.addAnnotations(toiletsNotForFree)
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.priceButton.selected = !(self.priceButton.selected)
        })
    }
    
    func addConstraint(view: UIView, attribute: NSLayoutAttribute, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: self.view, attribute: attribute, multiplier: 1.0, constant: constant)
        self.view.addConstraint(constraint)
        
        return constraint
    }
    
}

