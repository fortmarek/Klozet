//
//  UserLocation.swift
//  Klozet
//
//  Created by Marek Fořt on 08/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import MapKit

protocol UserLocation {
    var locationManager: CLLocationManager { get }
}

extension UserLocation {
    func getUserLocation() -> CLLocation? {
        guard let location = locationManager.location else {return nil}
        return location
    }
}

