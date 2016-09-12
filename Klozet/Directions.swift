//
//  Directions.swift
//  Klozet
//
//  Created by Marek Fořt on 07/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import MapKit


protocol DirectionsDelegate {
    var locationDelegate: UserLocation? { get }
}

extension DirectionsDelegate {
    //ETA for annotation view
    func getEta(destination: CLLocationCoordinate2D, completion: (eta: String) -> ())  {
        
        //Set path
        let directions = requestDirections(destination)
        
        //Calculate ETA
        directions.calculateETAWithCompletionHandler({
            etaResponse, error in
            guard let etaInterval = etaResponse?.expectedTravelTime else {return}
            
            let eta = self.convertEtaIntervalToString(etaInterval)
            
            completion(eta: eta)
        })
    }
    
    //Converting ETA in NSTimeInterval to minutes or hours
    private func convertEtaIntervalToString(etaInterval: NSTimeInterval) -> String {
        let etaInt = NSInteger(etaInterval)
        
        //Number of seconds in hour
        let oneHour = 3600
        let minutes = (etaInt / 60) % 60
        if etaInt > oneHour {
            let hours = (etaInt / oneHour) % oneHour
            return "\(hours)h \(minutes)m"
        }
            
        else {
            return "\(minutes) min"
        }
    }
    
    
    //ETA estimate
    private func requestDirections(destination: CLLocationCoordinate2D) -> MKDirections {
        
        let request = MKDirectionsRequest()
        
        guard
            let locationDelegate = self.locationDelegate,
            let userLocation = locationDelegate.getUserLocation() else {return MKDirections()}
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.transportType = .Walking
        
        let directions = MKDirections(request: request)
        
        return directions
    }
}