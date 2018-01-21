//
//  Toilet.swift
//  Klozet
//
//  Created by Marek Fořt on 11/29/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


struct Toilets {
    let toilets: [Toilet]
}

extension Toilets: Decodable {
    enum ToiletsKeys: String, CodingKey {
        case toilets = "toilets"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ToiletsKeys.self)
        let toilets: [Toilet] = try container.decode([Toilet].self, forKey: .toilets)
        self.init(toilets: toilets)
    }
}

class Toilet: NSObject, MKAnnotation, Decodable {
    
    //MKAnnotation properties
    let title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    let openTimes: [OpenTimes]
    var price: String
    var toiletId: Int
    let imageCount: Int
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, openTimes: [OpenTimes], price: String, toiletId: Int, imageCount: Int) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.openTimes = openTimes
        self.price = price
        self.toiletId = toiletId
        self.imageCount = imageCount
    }
    
    enum ToiletKeys: String, CodingKey {
        case address = "address"
        case openTimes = "open_times"
        case price = "price"
        case coordinates = "coordinates"
        case toiletId = "toilet_id"
        case imageCount = "image_count"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ToiletKeys.self)
        let toiletId: Int = try container.decode(Int.self, forKey: .toiletId)
        //print(toiletId)
        let address: Address = try container.decode(Address.self, forKey: .address)
        let openTimes: [OpenTimes] = try container.decode([OpenTimes].self, forKey: .openTimes)
        let price: String? = try container.decodeIfPresent(String.self, forKey: .price)
        let coordinates: [Double] = try container.decode([Double].self, forKey: .coordinates)
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        let imageCount: Int = try container.decode(Int.self, forKey: .imageCount)
        self.init(title: address.mainAddress, subtitle: address.subAddress, coordinate: coordinate, openTimes: openTimes, price: price ?? "Free", toiletId: toiletId, imageCount: imageCount)
    }
}
