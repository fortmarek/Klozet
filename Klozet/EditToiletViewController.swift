//
//  EditToiletViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 1/17/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit

class EditToiletViewController: AddToiletViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        uploadCompletion = { [weak self] toilet, hoursImage, toiletImage, notes in
            self?.toiletViewModel.editToilet(toilet, hoursImage: hoursImage, toiletImage: toiletImage, notes: notes).start()
        }
        
        addToiletButton.setTitle("Done", for: .normal)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
