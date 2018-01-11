//
//  DirectionsViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 1/11/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit


class DirectionsViewController: SingleToiletViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let toilet = self.toilet else {return}

        let rightBarButtonItem = SingleDirectionsButton(annotation: toilet)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.tintColor = .mainOrange
    }

}
