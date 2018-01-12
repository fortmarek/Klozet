//
//  PricePickerDelegate.swift
//  Klozet
//
//  Created by Marek Fořt on 1/12/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit 

protocol PricePickerDelegate {
    var prices: [String] {get}
}

extension PricePickerDelegate where Self: UIPickerViewDelegate, Self: UIPickerViewDataSource {
    func createPricesArray() -> [String] {
        var prices: [String] = ["Free"]
        for price in 1...100 {
            prices.append("\(price) CZK")
        }
        return prices
    }
}

