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

class ViewController: UIViewController, UIGestureRecognizerDelegate, UserLocation {

    //UI elements
    @IBOutlet weak var mapView: MKMapView!
    
    //Buttons
    let currentLocationButton = UIButton()
    let filterButton = UIButton()
    let priceButton = UIButton()
    let timeButton = UIButton()
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
    
    
    func timeButtonTapped(sender: UIButton) {
        
        filterOpenToilet()
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            //Change timeButton image
            self.timeButton.selected = !(self.timeButton.selected)
        })
        
    }
    
    private func filterOpenToilet() {
        if timeButton.selected == false {
            //Filter toilets to open ones only
            let toiletsNotOpen = toilets.filter({
                isToiletOpen($0) == false
            })
            
            //Saving closed toilets so they can be added later
            self.toiletsNotOpen = toiletsNotOpen
            
            mapView.removeAnnotations(toiletsNotOpen)
        }
            //Add back closed toilets (filter not applied)
        else {
            mapView.addAnnotations(self.toiletsNotOpen)
        }
    }
    
    func isToiletOpen(toilet: Toilet) -> Bool {
        let toiletTimes = toilet.openTimes
        
        //Int of today's weekday
        let todayWeekday = NSDate().getTodayWeekday()
        
        //Getting dictionary of toilet opening times
        for toiletTimeDict in toiletTimes {
            
            //If the toilet is open nonstop, I can right away return true
            if toiletTimeDict["nonstop"].bool == true {
                return true
            }
            
            //Getting array of ints of open weekdays
            guard let toiletDays = toiletTimeDict["days"].arrayObject as? Array<Int> else {continue}
            
            //If the toilet is open on today's weekday, check additionaly time, otherwise continue iteration
            if toiletDays.indexOf(todayWeekday) != nil {
                guard let hours = toiletTimeDict["hours"].arrayObject as? Array<String> else {continue}
                if isOpenInHours(hours) {
                    return true
                }
            }
            
            else {
                continue
            }
        }
        
        return false
    }
    
    func isOpenInHours(hours: Array<String>) -> Bool {
        //If the hours interval is not set, we assume the toilet is open
        guard hours.count == 2 else {return true}
        
        let startHour = hours[0].getHours()
        let closeHour = hours[1].getHours()
        
        let today = NSDate()
        
        //Is the current time in the interval? If yes, then the toilet is open as of right now
        if today.compare(startHour) == .OrderedDescending && today.compare(closeHour) == .OrderedAscending {
            return true
        }
        
        else {
            return false
        }
        
        

    }    
}

