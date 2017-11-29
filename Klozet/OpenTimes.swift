//
//  OpenTimes.swift
//  Klozet
//
//  Created by Marek Fořt on 11/29/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//

import Foundation


struct OpenTimes {
//    let hours: [String]?
//    let days: [Int]?
    let isNonstop: Bool?
}

extension OpenTimes: Decodable {
    enum OpenTimesKeys: String, CodingKey {
        case hours = "hours"
        case days = "days"
        case isNonstop = "nonstop"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OpenTimesKeys.self)
//        let hours: [String]? = try container.decodeIfPresent([String].self, forKey: .hours)
//        let days: [Int]? = try container.decodeIfPresent([Int].self, forKey: .days)
        let isNonstop: Bool? = try container.decodeIfPresent(Bool.self, forKey: .isNonstop)
        self.init(isNonstop: isNonstop)
    }
}

extension OpenTimes: Equatable {
    static func ==(lhs: OpenTimes, rhs: OpenTimes) -> Bool {
        return lhs.isNonstop == rhs.isNonstop
    }
}
