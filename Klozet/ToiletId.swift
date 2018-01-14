//
//  ToiletId.swift
//  Klozet
//
//  Created by Marek Fořt on 1/14/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import Foundation

class ToiletId: Decodable {
    let toiletId: Int
    
    init(toiletId: Int) {
        self.toiletId = toiletId
    }
    
    enum ToiletIdKeys: String, CodingKey {
        case toiletId = "toilet_id"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ToiletIdKeys.self)
        let toiletId: Int = try container.decode(Int.self, forKey: .toiletId)
        self.init(toiletId: toiletId)
    }
}
