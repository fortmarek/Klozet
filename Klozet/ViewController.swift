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

protocol FilterInterfaceDelegate {
    var priceButton: FilterPriceButton { get }
    var timeButton: FilterOpenButton { get }
    var cornerConstant: CGFloat { get }
    func addConstraint(_ view: UIView, attribute: NSLayoutAttribute, constant: CGFloat) ->  NSLayoutConstraint
    func addSubview(_ view: UIView)
}


class ViewController: UIViewController, UIGestureRecognizerDelegate, UserLocation, AnnotationController, FilterInterfaceDelegate, DirectionsDelegate, ShowDelegate {

    //UI elements
    @IBOutlet weak var mapView: MKMapView!
    
    //Buttons
    let currentLocationButton = UIButton()
    let filterButton = FilterButton()
    let priceButton = FilterPriceButton()
    let timeButton = FilterOpenButton()
    
    //Option buttons' constraints, used later for animation
    var priceButtonConstraint = NSLayoutConstraint()
    var timeButtonConstraint = NSLayoutConstraint()

    
    //Default button distance from the edges of the screen
    let cornerConstant = CGFloat(20)
    //Default width and height of buttons
    let sizeConstant = CGFloat(55)
    
    var toilets = [Toilet]()
    var toiletsNotOpen = [Toilet]()
    
    var locationDelegate: UserLocation?
    
    //button state for showing also the direction iPhone is facing (it's the third state => needed special var, can't do with just UIButton selected state)
    var currentLocationHeadingSelected = false
    var isFilterSelected = false
    
    //Used for recognizing if the map was moved by user, if it was then current location button should be no more selected
    var dragRecognizer = UIPanGestureRecognizer()
    
    var locationManager = CLLocationManager()
    
    var didOrderToilets = false
    var toiletsDelegate: ListToiletsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startTrackingLocation()
        locationManager.delegate = self
        mapView.delegate = self
        
        getToilets()
        
        createButtons()
        
        addDragRecognizer()
        print(NSLocale.current.identifier)
        print(NSLocale.current.languageCode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //TODO: Show custom view to first nicely ask the user, not just with default alert
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getToilets() {
        //DataController for fetching toilets
        let dataController = DataController()
        
        dataController.getToilets({
            toilets in
            self.toilets = toilets
            //UI changes, main queue
            DispatchQueue.main.async(execute: {
                //Placing toilets on the map
                self.mapView.addAnnotations(toilets)
            })
            
            self.orderToilets()
        })
    }
    
    
    
    //MARK: DragRecognizer
    
    fileprivate func addDragRecognizer() {
        //Start recognizing user interaction with map
        dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragMap))
        dragRecognizer.delegate = self
        mapView.addGestureRecognizer(dragRecognizer)
    }
    
    //Allow use of dragRecognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //If map was dragged, map is not following user's current location - current location should not be selected
    func didDragMap() {
        //Recognizing start of the drag, it's also called only once per interaction
        if dragRecognizer.state == .began {
            currentLocationButton.isSelected = false
            
            currentLocationHeadingSelected = false
            locationManager.stopUpdatingHeading()
        }
        
    }

    // MARK: Dropping toilet pins
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //Checking that annotation really is a Toilet class
        guard let toiletAnnotation = annotation as? Toilet else {return nil}
        
        var annotationView = MKAnnotationView()
        
        //User reusableAnnotationView
        if let reusableAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "toiletAnnotation") {
            annotationView = reusableAnnotationView
        }
        
        //Init of reusableAnnotationView
        else {
            let toiletAnnotationView = ToiletAnnotationView(annotation: toiletAnnotation, reuseIdentifier: "toiletAnnotation")
            
            toiletAnnotationView.centerOffset = CGPoint(x: 0, y: -toiletAnnotationView.frame.height/2)
            
            toiletAnnotationView.ShowDelegate = self
            
            //DirectionButton delegate = self => getting user location
            guard let directionButton = toiletAnnotationView.leftCalloutAccessoryView as? DirectionButton else {return toiletAnnotationView}
            directionButton.locationDelegate = self
            
            annotationView = toiletAnnotationView
        }

        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard
            let toiletAnnotationView = view as? ToiletAnnotationView,
            let toilet = toiletAnnotationView.annotation as? Toilet,
            let directionButton = toiletAnnotationView.leftCalloutAccessoryView as? DirectionButton
        else {return}
        
        directionButton.toilet = toilet
        directionButton.setEtaTitle(coordinate: toilet.coordinate)
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.tag = 0
    }
    
    func currentLocationButtonTapped(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        determineCurrentLocationButtonImage()
    }
    
    fileprivate func determineCurrentLocationButtonImage() {
        if currentLocationHeadingSelected {
            currentLocationHeadingSelected = false
            currentLocationButton.isSelected = false
            locationManager.stopUpdatingHeading()
            setImageForSelectedHighlighted(currentLocationButton, image: "CurrentLocationSelected")
        }
        else if currentLocationButton.isSelected {
            currentLocationHeadingSelected = true
            setImageForSelectedHighlighted(currentLocationButton, image: "CurrentLocationHeading")
            locationManager.startUpdatingHeading()
        }
        else {
            setImageForSelectedHighlighted(currentLocationButton, image: "CurrentLocationSelected")
            currentLocationButton.isSelected = true
        }
    }
    
    //Order toilets depending on distance from user
    fileprivate func orderToilets() {
        
        //Asynchronouly order toilets by distance, make them ready for list
        DispatchQueue.global().async {
            self.locationDelegate = self
            
            self.toilets = self.toilets.sorted(by: {
                self.getDistance($0.coordinate) < self.getDistance($1.coordinate)
            })
            
            //Done ordering toilets
            self.didOrderToilets = true
            self.toiletsDelegate?.updateToilets(toilets: self.toilets)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Check segue identifier
        if segue.identifier == "listSegue" {
            
            //Wait for toilets to be ordered by distance
            
            //Check viewController type
            guard let listViewController = segue.destination as? ListViewController else {return}
            
            listViewController.locationDelegate = self
            
            toiletsDelegate = listViewController
            
            //Passing toilets
            listViewController.toilets = self.toilets
            listViewController.didOrderToilets = self.didOrderToilets
        }
    }
    
    fileprivate func setImageForSelectedHighlighted(_ button: UIButton, image: String) {
        button.setImage(UIImage(named: image), for: .selected)
        button.setImage(UIImage(named: image), for: [.selected, .highlighted])
    }
    
    
    func addConstraint(_ view: UIView, attribute: NSLayoutAttribute, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: self.view, attribute: attribute, multiplier: 1.0, constant: constant)
        self.view.addConstraint(constraint)
        
        return constraint
    }
    
    func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }
}

protocol ShowDelegate {
    func showViewController(viewController: UIViewController)
}

extension ShowDelegate where Self: UIViewController {
    func showViewController(viewController: UIViewController) {
        self.show(viewController, sender: nil)
    }

}

