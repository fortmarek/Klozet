//
//  ToiletController.swift
//  Klozet
//
//  Created by Marek Fořt on 1/3/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import Foundation

protocol ToiletController {
    func addToilets(_ toilets: [Toilet])
    func removeToilets(_ toilets: [Toilet])
    var toilets: [Toilet] {get set}
    var toiletsNotOpen: [Toilet] {get set}
}
