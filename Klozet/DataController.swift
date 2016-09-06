//
//  DataController.swift
//  Klozet
//
//  Created by Marek Fořt on 13/08/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit


class Toilet: NSObject, MKAnnotation {
    
    //MKAnnotation properties
    //Title - main address
    let title: String?
    
    //Subtitle - additional info about toilet's position
    let subtitle: String?
    
    let openTimes: [JSON]
    let price: String
    let coordinate: CLLocationCoordinate2D
    
    init(mainAdress: String, subAddress: String, openTimes: [JSON], price: String, coordinate: CLLocationCoordinate2D) {
        self.title = mainAdress
        self.subtitle = subAddress
        self.openTimes = openTimes
        self.price = price
        self.coordinate = coordinate
        
    }
    

}


class DataController {
    
    //Fetching toilet data
    func getToilets(completion: (toilets: [Toilet]) -> () ){
        
        //GET request for toilet data
        Alamofire.request(.GET, "http://139.59.144.155/klozet")
            .responseJSON { response in
                
                var toilets = [Toilet]()

                guard let data = response.data else {return}
                
                //Converting data to JSON
                let json = JSON(data: data)
                for (_, toiletJson) in json {
                    
                    //Coordinates
                    guard let coordinate = self.getCoordinate(toiletJson["coordinates"]) else {continue}
                    
                    //Getting other JSON toilet values then init of Toilet
                    let toilet = self.getToilet(toiletJson, coordinate: coordinate)
                    
                    toilets.append(toilet)
                }
                
                //Returning toilets array, when GET request done, app can start adding annotationViews to the map
                completion(toilets: toilets)
        }

    }
    
    //Parsing other toilet values from tolietJson
    private func getToilet(propertiesJson: JSON, coordinate: CLLocationCoordinate2D) -> Toilet {
        guard
            //Price
            let price = propertiesJson["price"].string,
            
            //Open times
            let openTimes = propertiesJson["open_times"].array,
            
            //Addresses
            let address = propertiesJson["address"].dictionary,
            let mainAddress = address["main_address"]?.string,
            let subAddress = address["sub_address"]?.string
            
            //At least one of the values is nil
            else {return Toilet(mainAdress: "", subAddress: "", openTimes: [], price: "", coordinate: coordinate)}

        
        return Toilet(mainAdress: mainAddress, subAddress: subAddress, openTimes: openTimes, price: price, coordinate: coordinate)
    }
    
    private func getCoordinate(coordinateJson: JSON) -> CLLocationCoordinate2D? {
        guard
            let coordinates = coordinateJson.array,
            let latitude = coordinates[1].double,
            let longitude = coordinates[0].double
        else {return nil}
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

}
