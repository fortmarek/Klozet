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
    
    init(adress: String, detailedAdress: String, openTimes: [String], price: String, coordinate: CLLocationCoordinate2D) {
        self.title = adress
        self.subtitle = detailedAdress
        self.openTimes = openTimes
        self.price = price
        self.coordinate = coordinate
    }
    

}


class DataController {
    // TODO: Add filters
    func getToilets(completion: (toilets: [Toilet]) -> () ){

        Alamofire.request(.GET, "http://opendata.iprpraha.cz/CUR/FSV/FSV_VerejnaWC_b/WGS_84/FSV_VerejnaWC_b.json")
            .responseJSON { response in
                
                var toilets = [Toilet]()
                
                guard let data = response.data else {return}
                let json = JSON(data: data)["features"]
                
                for (_, toiletJson) in json {
                    guard let coordinate = self.getCoordinate(toiletJson["geometry"]) else {return}
                    let toilet = self.getToilet(toiletJson["properties"], coordinate: coordinate)
                    toilets.append(toilet)
                }
                
                completion(toilets: toilets)
        }

    }

    private func getToilet(propertiesJson: JSON, coordinate: CLLocationCoordinate2D) -> Toilet {
        guard
            let price = propertiesJson["CENA"].string,
            let openTime = propertiesJson["OTEVRENO"].string,
            let adress = propertiesJson["ADRESA"].string
        else {return Toilet(adress: "", detailedAdress: "", openTimes: [String](), price: "", coordinate: coordinate)}
        
        
        let capitalizedPrice = price.capitalizeFirstLetter()
        let capitalizedAdress = adress.capitalizeFirstLetter()
        
        let openTimes = openTime.componentsSeparatedByString(";")
        
        //let capitalizedOpenTimes = openTimes.map({capitalize($0)})
        
        //print(capitalizedOpenTimes)
        
        return Toilet(adress: capitalizedAdress, detailedAdress: "", openTimes: [String](), price: capitalizedPrice, coordinate: coordinate)
    }
    
    private func capitalize(openTime: String) -> String {
        
        var openTimeCapitalized = [String]()
        
        for openTimeComponent in openTime.componentsSeparatedByString("-") {
            
            //Removing space at the sart of openTime
            if String(openTimeComponent.characters.prefix(1)) == " " {
                openTimeCapitalized.append(String(openTimeComponent.characters.dropFirst()).capitalizeFirstLetter())
            }
                
            else {
                openTimeCapitalized.append(openTimeComponent.capitalizeFirstLetter())
            }
        }
        return openTimeCapitalized.joinWithSeparator("-")
    }
    
    private func getCoordinate(coordinateJson: JSON) -> CLLocationCoordinate2D? {
        guard
            let coordinates = coordinateJson["coordinates"].array,
            let latitude = coordinates[1].double,
            let longitude = coordinates[0].double
        else {return nil}
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

}


extension String {
    func capitalizeFirstLetter() -> String {
        let firstLetterCapitalized = String(self.characters.prefix(1)).uppercaseString
        let dropFirstLetter = String(self.characters.dropFirst())
        
        return firstLetterCapitalized + dropFirstLetter
    }
}