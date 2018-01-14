//
//  OpenTimes.swift
//  Klozet
//
//  Created by Marek Fořt on 11/29/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//

import Foundation


struct OpenTimes: Codable {
    let hours: [String]
    let days: [Int]
    let isNonstop: Bool
    //let isUnknown: Bool
}

extension OpenTimes {
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
        //isUknonwn = hours == nil && days == nil &&
        self.init(hours: hours, days: days, isNonstop: isNonstop)
    }
}

extension OpenTimes: Equatable {
    static func ==(lhs: OpenTimes, rhs: OpenTimes) -> Bool {
        return lhs.hours == rhs.hours && lhs.days == rhs.days && lhs.isNonstop == rhs.isNonstop
    }
}
