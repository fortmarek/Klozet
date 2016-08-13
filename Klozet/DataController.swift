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
}


class DataController {
    // TODO: Add filters
    func getToilets() -> Toilet {
        
        Alamofire.request(.GET, "http://opendata.iprpraha.cz/CUR/FSV/FSV_VerejnaWC_b/S_JTSK/FSV_VerejnaWC_b.json")
            .responseJSON { response in
                
                guard let data = response.data else {return}
                let json = JSON(data: data)["features"]
                
                for toiletData in json {
                    print(toiletData)
                }
        }
        
        return Toilet(adress: String(), openingTime: String(), price: String())

    }

}