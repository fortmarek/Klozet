//
//  DataController.swift
//  Klozet
//
//  Created by Marek Fořt on 13/08/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit

struct OpenTimes {
    let hours: [String]
    let days: [Int]
    let isNonstop: Bool
}

extension OpenTimes: Decodable {
    enum OpenTimesKeys: String, CodingKey {
        case hours = "hours"
        case days = "days"
        case isNonstop = "nonstop"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OpenTimesKeys.self)
        let hours: [String] = try container.decode([String].self, forKey: .hours)
        let days: [Int] = try container.decode([Int].self, forKey: .days)
        let isNonstop: Bool = try container.decode(Bool.self, forKey: .isNonstop)
        self.init(hours: hours, days: days, isNonstop: isNonstop)
    }
}

struct Address {
    let mainAddress: String
    let subAddress: String
}

extension Address: Decodable {
    enum AddressKeys: String, CodingKey {
        case mainAddress = "main_address"
        case subAddress = "sub_address"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AddressKeys.self)
        let mainAddress: String = try container.decode(String.self, forKey: .mainAddress)
        let subAddress: String = try container.decode(String.self, forKey: .subAddress)
        self.init(mainAddress: mainAddress, subAddress: subAddress)
    }
}

class ToiletAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

struct Toilets {
    let toilets: [Toilet]
}

extension Toilets: Decodable {
    enum ToiletsKeys: String, CodingKey {
        case toilets = "toilets"
    }
}

struct Toilet {
    
    //MKAnnotation properties
    let toiletAnnotation: ToiletAnnotation
    let openTimes: OpenTimes
    let price: String
    let toiletId: Int
    
}

extension Toilet: Decodable {
    enum ToiletKeys: String, CodingKey {
        case address = "address"
        case openTimes = "open_times"
        case price = "price"
        case coordinates = "coordinates"
        case toiletId = "toilet_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ToiletKeys.self)
        let address: Address = try container.decode(Address.self, forKey: .address)
        let openTimes: OpenTimes = try container.decode(OpenTimes.self, forKey: .openTimes)
        let price: String = try container.decode(String.self, forKey: .price)
        let coordinates: [Double] = try container.decode([Double].self, forKey: .coordinates)
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        let toiletId: Int = try container.decode(Int.self, forKey: .toiletId)
        let toiletAnnotation: ToiletAnnotation = ToiletAnnotation(coordinate: coordinate, title: address.mainAddress, subtitle: address.subAddress)
        self.init(toiletAnnotation: toiletAnnotation, openTimes: openTimes, price: price, toiletId: toiletId)
    }
}

