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
    let title: String?
    let subtitle: String?
    let openTimes: [String]
    let price: String
    let coordinate: CLLocationCoordinate2D
    
    init(adress: String, subAddress: String, openTimes: [String], price: String, coordinate: CLLocationCoordinate2D) {
        self.title = adress
        self.subtitle = subAddress
        self.openTimes = openTimes
        self.price = price
        self.coordinate = coordinate
    }
    

}


class DataController {
    // TODO: Add filters
    func getToilets(completion: (toilets: [Toilet]) -> () ){

        Alamofire.request(.GET, "http://139.59.144.155/klozet")
            .responseJSON { response in
                
                var toilets = [Toilet]()
                
                guard let data = response.data else {return}
                let json = JSON(data: data)
                
                print(json)
                
                for (objectId, toiletJson) in json {
                    
                    guard let coordinate = self.getCoordinate(toiletJson[objectId]) else {return}
                    let toilet = self.getToilet(toiletJson[objectId], coordinate: coordinate)
                    toilets.append(toilet)
                }
                
                completion(toilets: toilets)
        }

    }

    private func getToilet(propertiesJson: JSON, coordinate: CLLocationCoordinate2D) -> Toilet {
        guard
            //orice
            let price = propertiesJson["price"].string,
            //Open times
            //let openTimes = propertiesJson["open_times"].array,
            //Addresses
            let address = propertiesJson["address"].dictionary,
            let mainAddressJson = address["main_adress"],
            let mainAddress = mainAddressJson.string,
            let subAddressJson = address["sub_adress"],
            let subAddress = subAddressJson.string
        else {return Toilet(adress: "", subAddress: "", openTimes: [String](), price: "", coordinate: coordinate)}
        
        //let openTimes = openTime.componentsSeparatedByString(";")
        
        return Toilet(adress: mainAddress, subAddress: subAddress, openTimes: [String](), price: price, coordinate: coordinate)
    }
    
    private func getCoordinate(coordinateJson: JSON) -> CLLocationCoordinate2D? {
        guard
            let coordinates = coordinateJson["coordinates"].array,
            let latitude = coordinates[0].double,
            let longitude = coordinates[1].double
        else {return nil}
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

}
