//
//  Address.swift
//  Klozet
//
//  Created by Marek Fořt on 11/29/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//

import Foundation


struct Address: Codable {
    let mainAddress: String
    let subAddress: String
}

extension Address{
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

extension Address: Equatable {
    static func ==(lhs: Address, rhs: Address) -> Bool {
        return lhs.mainAddress == rhs.mainAddress && lhs.subAddress == rhs.mainAddress
    }
}
