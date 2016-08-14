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

//Location of the toilet
struct Location {
    let latitude: Double
    let longitude: Double
}

struct Toilet {
    let adress: String
    let openingTime: String
    let price: String
    let location: Location
}


class DataController {
    // TODO: Add filters
    func getToilets(completion: (toilets: [Toilet]) -> () ){

        Alamofire.request(.GET, "http://opendata.iprpraha.cz/CUR/FSV/FSV_VerejnaWC_b/S_JTSK/FSV_VerejnaWC_b.json")
            .responseJSON { response in
                
                var toilets = [Toilet]()
                
                guard let data = response.data else {return}
                let json = JSON(data: data)["features"]
                
                for (_, toiletJson) in json {
                    guard let location = self.getLocation(toiletJson["geometry"]) else {return}
                    let toilet = self.getToilet(toiletJson["properties"], location: location)
                    toilets.append(toilet)
                }
                
                completion(toilets: toilets)
        }

    }

    private func getToilet(propertiesJson: JSON, location: Location) -> Toilet {
        guard
            let price = propertiesJson["CENA"].string,
            let openingTime = propertiesJson["OTEVRENO"].string,
            let adress = propertiesJson["ADRESA"].string
        else {return Toilet(adress: "", openingTime: "", price: "", location: location)}
        
        return Toilet(adress: adress, openingTime: openingTime, price: price, location: location)
    }
    
    private func getLocation(locationJson: JSON) -> Location? {
        guard
            let latitude = locationJson["coordinates"][0].double,
            let longitude = locationJson["coordinates"][1].double
        else {return nil}
        
        return Location(latitude: latitude, longitude: longitude)
    }

}